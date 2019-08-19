function [theta headAngleInfo] = getHeadAngle(DLC,opts)
% getHeadAngle.m (Perform after coordinate transform!)
% 0 is north, 90 is east, 180 is south, -90 is west (output in degrees)
% This will get the head angle based on one of several analysis methods:
    % 1: Requires labeling of both ears and nose. Takes midpoint between ears
            % and finds vector to nose position.
    % 2: Requires both ears and nose. Finds orthogonal vector to ears in
            % direction of the nose. 
    % 3: Compute and arbitrary angle where (HEAD) is the head of the vector and (TAIL)
        % is the tail of the vector


bParts = fieldnames(DLC);

headAngleInfo.method = opts.analysis_method;
headAngleInfo.opts = opts.bodyID;

switch opts.analysis_method
    case 1 % Midpoint of ears to head:        
        disp(['NOSE FIELD: ',bParts{opts.bodyID.head}])
        disp(['EAR FIELDS: ',bParts{opts.bodyID.ears(1)},',',...
            bParts{opts.bodyID.ears(2)}])

        % Get Vector between midpoint and head:
        headVec(:,1) = DLC.(bParts{opts.bodyID.head})(:,1) - ...
            (DLC.(bParts{opts.bodyID.ears(1)})(:,1) + ...
            DLC.(bParts{opts.bodyID.ears(2)})(:,1))/2;        
        headVec(:,2) = DLC.(bParts{opts.bodyID.head})(:,2) - ...
            (DLC.(bParts{opts.bodyID.ears(1)})(:,2) + ...
            DLC.(bParts{opts.bodyID.ears(2)})(:,2))/2;
        theta = rad2deg(sign(headVec(:,1)) .* acos(headVec(:,2)./(sqrt(headVec(:,1).^2+headVec(:,2).^2))));
        

        
    case 2 % orthogonal vector to ears in direction of head:
        disp(['NOSE FIELD: ',bParts{opts.bodyID.head}])
        disp(['EAR FIELDS: ',bParts{opts.bodyID.ears(1)},',',...
            bParts{opts.bodyID.ears(2)}])

        % Get Vector for ears:
        earVec(:,1) = DLC.(bParts{opts.bodyID.ears(1)})(:,1) - ...
            DLC.(bParts{opts.bodyID.ears(2)})(:,1);
        earVec(:,2) = DLC.(bParts{opts.bodyID.ears(1)})(:,2) - ...
            DLC.(bParts{opts.bodyID.ears(2)})(:,2);

        % Get Vector between midpoint and head:
        headVec(:,1) = DLC.(bParts{opts.bodyID.head})(:,1) - ...
            (DLC.(bParts{opts.bodyID.ears(1)})(:,1) + ...
            DLC.(bParts{opts.bodyID.ears(2)})(:,1))/2;        
        headVec(:,2) = DLC.(bParts{opts.bodyID.head})(:,2) - ...
            (DLC.(bParts{opts.bodyID.ears(1)})(:,2) + ...
            DLC.(bParts{opts.bodyID.ears(2)})(:,2))/2;
        
        % Get Orthogonal vectors to ears and find the one that points in head direction:
        hVecA = [-earVec(:,2) earVec(:,1)];
        hVecB = [earVec(:,2) -earVec(:,1)];
        dA = hVecA(:,1).*headVec(:,1) + hVecA(:,2).*headVec(:,2); % dot product A
        dist_A = sqrt(hVecA(:,1).^2+ hVecA(:,2).^2);
        dist_hVec = sqrt(headVec(:,1).^2+ headVec(:,2).^2);
        thetaA = acos(dA./(dist_A.*dist_hVec));
        headVec2 = NaN(size(hVecA));
        headVec2(find(thetaA<=(pi/2)),:) = hVecA(find(thetaA<=(pi/2)),:);
        headVec2(find(thetaA>(pi/2)),:) = hVecB(find(thetaA>(pi/2)),:);
        theta = rad2deg(sign(headVec2(:,1)) .* acos(headVec2(:,2)./(sqrt(headVec2(:,1).^2+headVec2(:,2).^2))));

    case 3 % TBD
        disp(['HEAD FIELD: ',bParts{opts.bodyID.head}])
        disp(['TAIL FIELD: ',bParts{opts.bodyID.tail}])        
        % Get Vector: Head and Tail
        headVec(:,1) = DLC.(bParts{opts.bodyID.head})(:,1) - ...
            (DLC.(bParts{opts.bodyID.tail})(:,1));        
        headVec(:,2) = DLC.(bParts{opts.bodyID.head})(:,2) - ...
            (DLC.(bParts{opts.bodyID.tail})(:,2));
        theta = rad2deg(sign(headVec(:,1)) .* acos(headVec(:,2)./(sqrt(headVec(:,1).^2+headVec(:,2).^2))));
        
end


