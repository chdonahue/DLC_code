function A = defineCoordinateSystem(videoFile,vidRange)
% User defines x-axis, scale, and origin which become the basis for coordinate
% transform

vidObj = VideoReader(videoFile);
vidLength = vidObj.Duration;

% loop through random frame
r = rand;
s = 1/(vidRange(2)-vidRange(1));
f = round(((r/s)+vidRange(1))*vidLength); % finds frame in vidRange part of video
vidObj.CurrentTime = f;
vidFrame = rgb2gray(readFrame(vidObj));

str = [];
while ~strcmpi(str,'y')
    figure
    imshow(vidFrame);
    disp(['DEFINE THE X-AXIS'])
    hold on
    [x1,y1] = ginput(1);
    plot(x1,y1,'r.','MarkerSize',20)
    [x2,y2] = ginput(1);
    plot(x2,y2,'r.','MarkerSize',20)
    plot([x1 x2],[y1 y2],'k','LineWidth',2)
    prompt = 'Keep (y)?';
    str = input(prompt,'s');
end
A.xAxis = [x1 y1; x2 y2];
prompt = 'Length of Axis in cm? ';
d = input(prompt);
A.xLength = d;

disp(['DEFINE THE ORIGIN'])
hold on
[x0,y0] = ginput(1);
plot(x0,y0,'b.','MarkerSize',20)
A.origin = [x0 y0];




