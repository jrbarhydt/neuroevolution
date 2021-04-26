%==========================================================================
    function dist = util_get_distance(point_1, point_2)
%==========================================================================
% calculate the euclidean distance between two points.
%
% inputs        description
% -------------------------------------------------
% point_1       tuple of point 1 [x1, y1]
% x2, y2        tuple of point 2 [x2, y2]
%
% output
% --------------------------------
% distance      distance between points
%--------------------------------------------------------------------------
    dist = sqrt((point_1(1)-point_2(1))^2+(point_1(2)-point_2(2))^2);
%--------------------------------------------------------------------------