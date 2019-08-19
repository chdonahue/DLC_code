% basler2mp4.m
% Script to batch process basler videos and create compressed .mp4 videos
clear variables

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER VARIABLES:
videoDir = 'D:\baslerVideos\aamDREADD_DA\'; % Directory where basler directories are held:
frameRate = 70; % frame rate (fps)
crf = 10; % compression factor (look at ffmpeg description)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cmdStr = '';
dirContents = dir(videoDir);
for fNum = 1:size(dirContents,1)
   [a,b,c] = fileattrib([videoDir,dirContents(fNum).name]);
   if b.hidden==0 && b.directory==1
        f = dir([videoDir,dirContents(fNum).name,'\*_0001.tiff']);
        if isempty(f)
            continue;
        end
        outputFile = [videoDir,dirContents(fNum).name,'.mp4'];
        fName = regexprep(f(1).name,'_\d*.tiff','');
        thisFileStr = ['ffmpeg -framerate ',num2str(frameRate),' -start_number 1 -i ',...
            ['"',videoDir,dirContents(fNum).name,'\',fName,'_%04d.tiff" '],'-crf ',num2str(crf),' ',outputFile,' & '];
        cmdStr = [cmdStr,thisFileStr];
   end   
end    
idx = strfind(cmdStr,'&'); % remove last &
cmdStr(idx(end):end) = [];

% process ffmpeg command:
system(cmdStr)