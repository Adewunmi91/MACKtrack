function [measure, info, AllMeasurements] = loadID(ID, verbose,varargin)
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% [measure, info, AllMeasurements] = loadID(ID, options)
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% LOADID pulls results from an experimental set using a "Scope Runs" Google Doc -
% choose a set by its ID number
%
% INPUTS
% ID          ID# of sets get data from (or AllMeasurements.mat file location, or AllMeasurements object)
%
% OUTPUTS:
% measure          full measurement information struct
% info             general information about experiment and tracking
% AllMeasurements  originally-saved output file, augmented w/ measurement-specific information
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if nargin<2
    verbose =1 ;
end
paths = loadpaths;
if ~isempty(varargin)
    locations = varargin{1};
else
    
    fh =load(fullfile(paths.MACKtrack, 'locations.mat'));
    locations = fh.locations;
end


tic;

if istext(ID) || isnumeric(ID) % Load file if a location or row index of a spreadsheet entry
    % Find/load AllMeasurements.mat - a full file path can be specfied, or an
    % ID corresponding to an entry on the ScopeRuns spreadsheet.
    if ~isfile(num2str(ID)) && isnumeric(ID)
        %         data = readScopeRuns(locations.spreadsheet, ID);
        data=read_id(ID);
        info.name = [data.SaveFolder{1}];
        fileName = [locations.data,filesep,data.SaveDir{1},filesep,info.name,filesep,'AllMeasurements.mat'];
%         load(fileName)
        fh=loadFile(fileName, 'Fresh',false);
%         info.savename = [locations.data,filesep,data.SaveDir{1},filesep,info.name,filesep,'AllMeasurements.mat'];
        info.savename = fileName;
        
    elseif isfile(num2str(ID))
        ID = namecheck(ID);
        fh=loadFile(ID, 'Fresh', false);
        info.savename = ID;
    else
        error(['Specified file/index (''ID'') is invalid'])
    end
    AllMeasurements = fh.AllMeasurements;
elseif isstruct(ID)
    AllMeasurements = ID;
    info.savename = [locations.data,AllMeasurements.parameters.SaveDirectory,filesep,'AllMeasurements.mat'];
else
    error('loadID accepts an "AllMeasurements" structure, or a file location/spreadsheet row index.')
end

info.locations = locations;


% Parse AllMeasurements
info.CellData = AllMeasurements.CellData;
info.fields = fieldnames(AllMeasurements);
% info.ImageDirectory = [AllMeasurements.parameters.ImagePath];
info.ImageDirectory = AllMeasurements.parameters.ImagePath;
measure = struct;
for i = 1:length(info.fields)
    if ~strcmpi(info.fields{i},'parameters') && ~strcmpi(info.fields{i},'CellData')
        measure.(info.fields{i}) = AllMeasurements.(info.fields{i});
    end
end
info.fields = fieldnames(measure);

% Add measurement-specific information and add to AllParameters:
% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% - for see_nfkb calculate base image distributions and threshold for positive NFkB expression
% - for see_nfkb_native, calculate (adjusted) nfkb & nuclear image distributions
% - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Read in 1st image from each XY position, calculate background mean/std (resave AllParameters)
p = AllMeasurements.parameters;
try
    if isfield(AllMeasurements, 'NFkBdimNuclear')
        if ~isfield(p, 'adj_distr')
            disp('Measuring and saving initial (flatfield-corrected) image distributions')
            p.adj_distr = zeros(2,length(p.XYRange));
            for ind = 1:length(p.XYRange)
                % NFkB image distribution
                i = p.XYRange(ind);
                j = min(p.TimeRange);
                expr = p.nfkbdimModule.ImageExpr;
                if ~exist('bit_depth','var')
                    if isfield(p,'BitDepth')
                        bit_depth = p.BitDepth;
                    else
                        imfo = imfinfo([locations.scope, p.ImagePath, eval(expr)]);
                        bit_depth = imfo.BitDepth;
                    end
                end
                img = checkread([locations.scope, p.ImagePath, eval(expr)],bit_depth,1,1);
                if ind==1
                    X = backgroundcalculate(size(img));
                end
                warning off MATLAB:nearlySingularMatrix
                pStar = (X'*X)\(X')*double(img(:));
                warning on MATLAB:nearlySingularMatrix
                % Apply background correction
                img = reshape((double(img(:) - X*pStar)),size(img));
                
                img = img-min(img(:)); % Set minimum to zero
                [~,p.adj_distr(:,ind)] = modebalance(img,1,bit_depth,'measure');
            end
            AllMeasurements.parameters = p;
            save(info.savename,'AllMeasurements')
        end
    elseif isfield(AllMeasurements,'NFkBNuclear')
        if ~isfield(p, 'nfkb_thresh')
            disp('Measuring and saving initial image distributions')
            nfkb_thresh = zeros(1,length(p.XYRange));
            p.img_distr = zeros(2,length(p.XYRange));
            for ind = 1:length(p.XYRange)
                i = p.XYRange(ind);
                j = min(p.TimeRange);
                expr = p.nfkbModule.ImageExpr;
                if ~exist('bit_depth','var')
                    if isfield(p,'BitDepth')
                        bit_depth = p.BitDepth;
                    else
                        imfo = imfinfo([locations.scope, p.ImagePath, eval(expr)]);
                        bit_depth = imfo.BitDepth;
                    end
                end
                img = checkread([locations.scope, p.ImagePath, eval(expr)],bit_depth,1,1);
                nfkb_thresh(ind) = quickthresh(img,false(size(img)),'log');
                [~,p.img_distr(:,ind)] = modebalance(img,2,bit_depth,'measure');
            end
            p.nfkb_thresh = mean(nfkb_thresh);
            AllMeasurements.parameters = p;
            save(info.savename,'AllMeasurements')
        end
        if ~isfield(p, 'adj_distr')
            disp('Measuring and saving initial (flatfield-corrected) image distributions')
            p.adj_distr = zeros(2,length(p.XYRange));
            for ind = 1:length(p.XYRange)
                % NFkB image distribution
                i = p.XYRange(ind);
                j = min(p.TimeRange);
                expr = p.nfkbModule.ImageExpr;
                if ~exist('bit_depth','var')
                    if isfield(p,'BitDepth')
                        bit_depth = p.BitDepth;
                    else
                        imfo = imfinfo([locations.scope, p.ImagePath, eval(expr)]);
                        bit_depth = imfo.BitDepth;
                    end
                end
                img = checkread([locations.scope, p.ImagePath, eval(expr)],bit_depth,1,1);
                if ind==1
                    X = backgroundcalculate(size(img));
                end
                warning off MATLAB:nearlySingularMatrix
                pStar = (X'*X)\(X')*double(img(:));
                warning on MATLAB:nearlySingularMatrix
                % Apply background correction
                img = reshape((double(img(:) - X*pStar)),size(img));
                
                img = img-min(img(:)); % Set minimum to zero
                [~,p.adj_distr(:,ind)] = modebalance(img,1,bit_depth,'measure');
            end
            AllMeasurements.parameters = p;
            save(info.savename,'AllMeasurements')
        end
        
        % Load nuclear image for nucIntenstiy Module (dim assumed - unimodal model)
        %     elseif isfield(AllMeasurements, 'MeanIntensityNuc')
    elseif isfield(AllMeasurements, 'MeanIntensityNuc')
        if ~isfield(p, 'adj_distr')
            disp('Measuring and saving initial (flatfield-corrected) image distributions')
            p.adj_distr = zeros(2,length(p.XYRange));
            for ind = 1:length(p.XYRange)
                i = p.XYRange(ind);
                j = min(p.TimeRange);
                expr = p.nucintensityModule.ImageExpr;
                if ~exist('bit_depth','var')
                    if isfield(p,'BitDepth')
                        bit_depth = p.BitDepth;
                    else
                        imfo = imfinfo([locations.scope, p.ImagePath, eval(expr)]);
                        bit_depth = imfo.BitDepth;
                    end
                end
                img = checkread([locations.scope, p.ImagePath, eval(expr)],bit_depth,1,1);
                if ind==1
                    X = backgroundcalculate(size(img));
                end
                warning off MATLAB:nearlySingularMatrix
                pStar = (X'*X)\(X')*double(img(:));
                warning on MATLAB:nearlySingularMatrix
                % Apply background correction
                img = reshape((double(img(:) - X*pStar)),size(img));
                
                img = img-min(img(:)); % Set minimum to zero
                [~,p.adj_distr(:,ind)] = modebalance(img,1,bit_depth,'measure');
            end
            AllMeasurements.parameters = p;
            save(info.savename,'AllMeasurements')
        end
        
    end
    
catch me
    disp(me)
    warning('Couldn''t find original images to measure background distributions - these may be required for some visualization functions.');
end


info.parameters = p;

toc1 = toc;

if verbose
    disp("In loadID: "+newline+['Loaded "', info.savename, '" in ', num2str(round(toc1*100)/100),' sec'])
end