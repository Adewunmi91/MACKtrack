function files_created = cpAllM (source, dest)
% Load locations (for images and output data)
% Will overwrite folder and file names in destination

files_created={};
if (isdir (source)) && (isdir (dest)) && ~isempty (ls(source))
    %check for AllMeasurements.mat in source dir
    contents = dir (source);
    src_name = [source,filesep,'AllMeasurements.mat'];
    if exist(src_name, 'file')
          %copy AllMeasurements.mat file to destination
          [~, foldername, ~] = fileparts (source);
          %create the parent folder of destination first before copying
          %file
          destination = [dest, filesep,foldername];
          [success, ~,~]=mkdir (destination);
          if success
              [success, ~,~ ] = copyfile (src_name, destination);
              assert (success, 'Failed to copy file ',src_name, ' to ', destination)
              files_created = [files_created, src_name];
          else
              assert (success, 'Failed to create folder: ',destination )
          end            
    else
        isrealdir=@(x) logical (sum(isstrprop (x.name, 'alphanum'))); 
        index = arrayfun(isrealdir,contents);
        contents = contents (index);
        for fldr=1:length (contents)
            new_src = [source, filesep,contents(fldr).name]; 
            temp=cpAllM (new_src, dest);
            files_created = [files_created, temp];
        end
    end
end
end


            
            
            

    