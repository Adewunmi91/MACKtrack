function [measure, info] = loadID(id, options)
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% [measure, info] = loadID(id, options)
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% LOADID pulls results from an experimental set using a "Scope Runs" Google Doc -
% choose a set by its ID number
%
% INPUTS
% id          ID# of sets get data from
% options     (optional) structure specifying smoothing on data and pixel-to-micron conv.
%
% OUTPUTS:
% measure     full measurement information struct
% info        general information about experiment and tracking
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

% Set default smoothing/unit conversion options: 
if nargin<2
    options.Smoothing = ' None';
    options.SmoothingWindow = 3;
    options.PixelConversion = 4.03;
    options.FramesPerHour = 12;
end

% Load locations (for images and output data)
home_folder = mfilename('fullpath');
slash_idx = strfind(home_folder,filesep);
load([home_folder(1:slash_idx(end-2)), 'locations.mat'],'-mat')

% Find/load AllMeasurements.mat - a full file path can be specfied, or an
% ID corresponding to an entry on the ScopeRuns spreadsheet.
tic
if ~exist(num2str(id), 'file')
    data = readScopeRuns(locations.spreadsheet, id);

    info.name = [data.dates{1},'_',data.names{1}];
    load([locations.data,filesep,data.save_dir{1},filesep,info.name,filesep,'AllMeasurements.mat'])
    info.savename = [locations.data,filesep,data.save_dir{1},filesep,info.name,filesep,'AllMeasurements.mat'];
else
    load(id)
    info.savename = id;
end

% Parse and smooth AllMeasurements
info.CellData = AllMeasurements.CellData;
info.fields = fieldnames(AllMeasurements);
info.ImageDirectory = [locations.scope, AllMeasurements.parameters.ImagePath];
measure = struct;
for i = 1:length(info.fields)
    if ~strcmpi(info.fields{i},'parameters') && ~strcmpi(info.fields{i},'CellData')
        
        if ~iscell(AllMeasurements.(info.fields{i}))
            measure.(info.fields{i}) = smoothMeasurement(AllMeasurements.(info.fields{i}), ...
                options,info.CellData, info.fields{i});
        else
            measure.(info.fields{i}) = AllMeasurements.(info.fields{i});
        end
    end
end
info.fields = fieldnames(measure);

% Add measurement-specific information and add to AllParameters:
% - for see_nfkb calculate base image distributions and threshold for positiev NFkB expression
% - for see_nfkb_native, calculate adjusted image distributions

% Read in 1st image from each XY position, calculate background mean/std (resave AllParameters)

p = AllMeasurements.parameters;

if isfield(AllMeasurements,'NFkBNuclear')
    if ~isfield(p, 'nfkb_thresh')
        disp('Measuring and saving initial image distributions')
        nfkb_thresh = zeros(1,length(p.XYRange));
        p.img_distr = zeros(2,length(p.XYRange));
        for ind = 1:length(p.XYRange)
            i = p.XYRange(ind);
            j = min(p.TimeRange);
            expr = p.nfkbModule.ImageExpr;
            nfkb = checkread([locations.scope, p.ImagePath, eval(expr)],p.BitDepth);
            nfkb_thresh(ind) = otsuthresh(nfkb,false(size(nfkb)),'log');
            [~,p.img_distr(:,ind)] = modebalance(nfkb,2,p.BitDepth,'measure');
        end
        p.nfkb_thresh = mean(nfkb_thresh);
        AllMeasurements.parameters = p;
        save(info.savename,'AllMeasurements')
    end
elseif isfield(AllMeasurements, 'NFkBdimNuclear')
    if ~isfield(p, 'adj_distr')
        disp('Measuring and saving initial (flatfield-corrected) image distributions')
        p.adj_distr = zeros(2,length(p.XYRange));
        for ind = 1:length(p.XYRange)
            i = p.XYRange(ind);
            j = min(p.TimeRange);
            expr = p.nfkbModule.ImageExpr;
            nfkb = checkread([locations.scope, p.ImagePath, eval(expr)],p.BitDepth);
            if ind==1
                X = backgroundcalculate(size(nfkb));
            end
            warning off MATLAB:nearlySingularMatrix
            pStar = (X'*X)\(X')*double(nfkb(:));
            warning on MATLAB:nearlySingularMatrix

            % Apply background correction
            nfkb = reshape((double(nfkb(:) - X*pStar)),size(nfkb));
            nfkb = nfkb-min(nfkb(:)); % Set minimum to zero
            [~,p.adj_distr(:,ind)] = modebalance(nfkb,1,p.BitDepth,'measure');
            AllMeasurements.parameters = p;
            save(info.savename,'AllMeasurements')
        end
    end
end
info.parameters = p;

toc1 = toc;
disp(['Loaded "', info.savename, '" in ', num2str(round(toc1*100)/100),' sec']) 