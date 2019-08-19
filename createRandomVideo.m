function createRandomVideo(fileList,outputFile,numFramesPerVid)
% creates .avi random video from list

v = VideoWriter(strcat(outputFile,'.avi'));
open(v);


frameCount = 1;
for fNum = 1:length(fileList)
    fileList{fNum}
    obj = VideoReader(fileList{fNum});
    numFrames = ceil(obj.FrameRate*obj.Duration);
    
    r = randperm(numFrames);
    frameID = sort(r(1:numFramesPerVid));
    for frameNum = 1:length(frameID)
        obj.CurrentTime = (1/obj.FrameRate)*frameID(frameNum);
        frame = readFrame(obj);
        writeVideo(v,frame);
        frameCount = frameCount+1;
    end
    

    
end

close(v);


