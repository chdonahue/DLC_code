function [DLC_cleaned,framesFixed] = interpolateLowConfidencePositions(DLC,opts)
% This interpolates values for low confidence positions
% Any value below conf_tol will be erased and replaced with linear
% interpolation. 
% framesFixed gives a list of frameIDs for each body part that was
% interpolated. 

bParts = fieldnames(DLC);
for bCount = 1:numel(bParts)
   c = DLC.(bParts{bCount})(:,3); % confidence values for each point
   x = DLC.(bParts{bCount})(:,1);
   y = DLC.(bParts{bCount})(:,2);
   idx = find(c<=opts.confTol); % find low confidence positions
   framesFixed{bCount} = idx;
   
   % Linear Interpolation:
   xNew = x; yNew = y;
   xNew(idx) = NaN; yNew(idx) = NaN;
   xNew = fillmissing(xNew,'linear');
   yNew = fillmissing(yNew,'linear');
   
   % Do not interpolate early or late frames:
   xNew(1:find(c>opts.confTol,1,'first'))=  NaN;
   yNew(1:find(c>opts.confTol,1,'first'))=  NaN;
   xNew(find(c>opts.confTol,1,'last'):end)=  NaN;
   yNew(find(c>opts.confTol,1,'last'):end)=  NaN;
   
   DLC_cleaned.(bParts{bCount})(:,1) = xNew; 
   DLC_cleaned.(bParts{bCount})(:,2) = yNew;
   DLC_cleaned.(bParts{bCount})(:,3) = c;
end

