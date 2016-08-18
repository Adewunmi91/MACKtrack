
function copyAllM (id, path)
% Load locations (for images and output data)
home_folder = mfilename('fullpath');
slash_idx = strfind(home_folder,filesep);
load([home_folder(1:slash_idx(end-1)), 'locations.mat'],'-mat')

% Find/load AllMeasurements.mat - a full file path can be specfied, or an
% ID corresponding to an entry on the ScopeRuns spreadsheet.


    data = readScopeRuns(locations.spreadsheet, id);
    info.name = [data.save_folder{1}];
    load([locations.data,filesep,data.save_dir{1},filesep,info.name,filesep,'AllMeasurements.mat'])
    info.savename = [locations.data,filesep,data.save_dir{1},filesep,info.name,filesep,'AllMeasurements.mat'];

    %make directory using path + info.name
    %copy file at info.savenae to new directory
    destination = [path, filesep,info.name];
    mkdir (destination);
    copyfile (info.savename, destination);
    