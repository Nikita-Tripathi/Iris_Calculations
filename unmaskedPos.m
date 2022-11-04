function [cPos, mPos] = unmaskedPos(mask1,mask2, k)
% UNMASKED POS returns k random _unmasked_ bit positions
%   Detailed explanation goes here

    % Generate positions (prototype - only generates for one trial) (make into a funciton later)
    cMask = mask1 & mask2;
    p = find(cMask);                        % Find all indices (linear!!!) where cMask is non-zero
    mPos = p(randperm(length(p), k));       % Get k randomly picked positions from p
    [x, y] = ind2sub([64 512], mPos);       % Convert linear indices to x,y coordinates
    z = randi([1 7], k, 1);                 % Make k random z coordinates (for iris codes)
    cPos = sub2ind([64 512 7], x, y, z);    % Convert x,y,z coordinates to linear (easier to use)


end

