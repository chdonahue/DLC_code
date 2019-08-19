function [DLC_trans] = applyTransform(DLC,T)
% Applies linear transform to all DLC coordinates

bParts = fieldnames(DLC);
for bCount = 1:numel(bParts)
    xy = DLC.(bParts{bCount})(:,1:2);
    xyT = [(T.R*xy' + T.trans)*(1/T.scaling)]';
    DLC_trans.(bParts{bCount})(:,1:2) = xyT; 
end