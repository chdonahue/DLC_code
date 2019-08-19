function K = getKinematics(DLC,theta,tVec)
% getKinematics.m: Requires a timevector related to each frame. Takes
% position data in DLC struct and returns a bunch of kinematic data. 
% TODO: Make angular stuff optional
% Match lengths of tVec and DLC coordinates: (Final pulses are always
        % extra!!)
        
bParts = fieldnames(DLC); 
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Match tVec length to DLC: (Final sync pulses are tossed!): 
lenDLC = size(DLC.(bParts{1}),1);
tPos = tVec(1:lenDLC);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tVel = conv(tPos,[.5 .5],'valid');
tAcc = conv(tVel,[.5 .5],'valid');
for bCount = 1:numel(bParts)    
    % Position:
    K.pos.(bParts{bCount}) = DLC.(bParts{bCount});
    
    % Velocity:
    K.vel.(bParts{bCount}) = diff(DLC.(bParts{bCount}))./diff(tPos);

    % Speed:
    K.speed.(bParts{bCount}) = sqrt(sum(K.vel.(bParts{bCount}).^2,2));

    % Acceleration:
    K.acc.(bParts{bCount}) = diff(K.vel.(bParts{bCount}))./diff(tVel);
    
    % Magnitude of Acceleration:
    K.magAcc.(bParts{bCount}) = sqrt(sum(K.acc.(bParts{bCount}).^2,2));
    
    % Calculate Kinematics in Egocentric Reference Frame: (Project onto
    % heading Vector:
    h = [cos(deg2rad(theta)) sin(deg2rad(theta))]; % heading vector
    hOrth = [h(:,2) -h(:,1)]; % Orthogonal to body (right side positive)
    v = K.vel.(bParts{bCount}); % Velocity
    a = K.acc.(bParts{bCount}); % Acceleration
    
    % Velocity:
    vH = (sum(v.*h(1:end-1,:),2)).*h(1:end-1,:); % Projection onto Heading Vector
    vOrth = (sum(v.*hOrth(1:end-1,:),2)).*hOrth(1:end-1,:); % Projection onto Orth Vector
    eVel(:,1) = sqrt((vOrth(:,1).^2 + vOrth(:,2).^2)).*sign(vOrth(:,1)).*sign(hOrth(1:end-1,1));
    eVel(:,2) = sqrt((vH(:,1).^2 + vH(:,2).^2)).*sign(vH(:,1)).*sign(h(1:end-1,1));
    K.ego.vel.(bParts{bCount}) = eVel;
    
    % Acceleration:
    aH = (sum(a.*h(1:end-2,:),2)).*h(1:end-2,:); % Projection onto Heading Vector
    aOrth = (sum(a.*hOrth(1:end-2,:),2)).*hOrth(1:end-2,:); % Projection onto Orth Vector
    eAcc(:,1) = sqrt((aOrth(:,1).^2 + aOrth(:,2).^2)).*sign(aOrth(:,1)).*sign(hOrth(1:end-2,1));
    eAcc(:,2) = sqrt((aH(:,1).^2 + aH(:,2).^2)).*sign(aH(:,1)).*sign(h(1:end-2,1));
    K.ego.acc.(bParts{bCount}) = eAcc;
       
end

% MAKE THE FOLLOWING OPTIONAL SINCE USER MAY NOT COMPUTE ANGLE...
% Angular Velocity:
theta_unwrap = unwrap(theta*pi/180)*180/pi;
K.heading = theta;
K.angVel = diff(theta_unwrap)./diff(tPos);
K.angAcc = diff(K.angVel)./diff(tVel);
K.cumAng = theta_unwrap;

