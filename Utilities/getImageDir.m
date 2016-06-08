function dir = getImageDir(id)
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
%From LoadID 3/24/16

%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

% Load locations (for images and output data)
home_folder = mfilename('fullpath');
slash_idx = strfind(home_folder,filesep);
load([home_folder(1:slash_idx(end-1)), 'locations.mat'],'-mat')

% Find/load AllMeasurements.mat - a full file path can be specfied, or an
% ID corresponding to an entry on the ScopeRuns spreadsheet.

if ~exist(num2str(id), 'file') && isnumeric(id)
    data = readScopeRuns(locations.spreadsheet, id);
    %returns save_folder, image_paths, xy_ranges, time_ranges,
    %parameter_files, and save_dir
    %info.name = [data.save_folder{1}];
    %locations.scope has the image folder name; locations.spreadsheet has
    %link, locations.data has tracking folder
   %load([locations.data,filesep,data.save_dir{1},filesep,info.name,filesep,'AllMeasurements.mat'])
    dir = [locations.scope,filesep,data.image_paths{1},filesep];
else
    error(['Specified file/index (''id'') is invalid'])
end
