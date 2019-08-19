function [DLC_cleaned framesFixed] = correctPositionJumps(DLC,opts)
% corrects nose and tail positions in deepLabCut videos whenever a jump in distance 
% greater than number of standard deviations specified. 
% Because points often jump for contiguous frames, this method chunks
% together segments of videos where large jumps are detected and performs
% linear interpolation on those chunks.
% NOTE: Ears don't swap positions in my test videos, but this method might
% have problems with body parts that look similar. May need some kind of
% swapping function before this...


bParts = fieldnames(DLC);
for bCount = 1:numel(bParts)
    d = sqrt((diff(DLC.(bParts{bCount})(:,1)).^2) + (diff(DLC.(bParts{bCount})(:,2)).^2));
    z = (d-nanmean(d))/nanstd(d);
    x = DLC.(bParts{bCount})(:,1);
    y = DLC.(bParts{bCount})(:,2);
    c = DLC.(bParts{bCount})(:,3);
    nanFrames = find(isnan(x));
    xNew = x; yNew = y;
    idx = find(abs(z)>=opts.jump_std);
    dIdx = diff(idx);
    for i = 1:length(idx)
        nanSt = idx(i)+1;
        nanEd = idx(i)+1;
        for dCount = i:length(dIdx)
            if dIdx(dCount)<opts.chunkSize
                nanEd = idx(dCount);
            else
                nanEd = idx(dCount);
                break;
            end
        end
        xNew(nanSt:nanEd) = NaN;
        yNew(nanSt:nanEd) = NaN;
    end
    framesFixed{bCount} = find(isnan(xNew));

    xNew = fillmissing(xNew,'linear');
    yNew = fillmissing(yNew,'linear');
    xNew(nanFrames) = NaN; % replace low confidence frames at beginning and ends of vids with NaNs
    yNew(nanFrames) = NaN;
    DLC_cleaned.(bParts{bCount})(:,1) = xNew; 
    DLC_cleaned.(bParts{bCount})(:,2) = yNew;
    DLC_cleaned.(bParts{bCount})(:,3) = c;
end
    
    
    