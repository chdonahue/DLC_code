% testScript.m
        
clear variables

csvFile = 'CD181219A_190111_DeepCut.csv'; 
videoFile = 'CD181219A_190111_video.avi';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORT DLC .CSV FILE INTO MATLAB:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DLC = load_DLC_data(csvFile);

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN DATA:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters used for cleaning data:
opts.confTol = 0.95; % tolerance for confidence interval (anything below gets flagged)
[DLC_cleaned framesFixed] = interpolateLowConfidencePositions(DLC,opts);

% Parameters for detecting position jumps:
opts.jump_std = 6; % number of stds:
opts.chunkSize = 35; % number of contiguous frames to search for position jumps
[DLC_cleaned framesFixed] = correctPositionJumps(DLC_cleaned,opts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: 
% 1. Some kind of manual step to show how well interpolation worked!
% 2. Check ear distances if applicable: (earDistCheck.m)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get center position (use boundary and thresholding to get this) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Optional function to find center of mass and add another point. 

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET AND APPLY COORDINATE TRANSFORM TO DLC DATA:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vidRange = [.3 .7]; % Test frame randomly taken from this range
A = defineCoordinateSystem(videoFile,vidRange);
T = getCoordinateTransform(A);
DLC_trans = applyTransform(DLC_cleaned,T);
    % Future versions will allow offsets for origin in case poor landmarks
    % exist
    
    % Another thing I want to do is a function to add landmarks in case we
    % wish to know the coordinates of arbitrary things in the environment

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET HEAD ANGLE:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
opts.bodyID.head = 1; % Column in CSV file for nose, etc. 
opts.bodyID.ears = [2 3];
opts.bodyID.tail = 4;
opts.analysis_method = 2; % There are 3 methods: look at function for details
[theta headAngleInfo] = getHeadAngle(DLC_trans,opts);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OPEN PHOTOMETRY DATA AND GET TIME VECTOR: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(photometryFile); 
tVec = data.epocs.Cam1.onset; % in seconds

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXTRACT KINEMATICS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
K = getKinematics(DLC_trans,theta,tVec);



%%%%%%%%%%%%%%%%%%%%%%%%
% SOMETHING TO SAVE DATA:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TBD....



