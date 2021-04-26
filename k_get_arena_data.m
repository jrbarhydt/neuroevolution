%==========================================================================
function [robot_pos, box_pos] = k_get_arena_data()
%==========================================================================
% retrieve khemera robot location and box location from global arena info.
%
% output        description
% --------------------------------
% robot_pos     tuple value of robot position [x, y]
% box_pos       tuple value of box position [x, y]
%--------------------------------------------------------------------------
    global KIKS_ROBOT_MATRIX KIKS_MMPERPIXEL KIKS_BALLDATA

    robot_pos = [(KIKS_ROBOT_MATRIX(1,1,1)/KIKS_MMPERPIXEL),...
                 (KIKS_ROBOT_MATRIX(1,1,2)/KIKS_MMPERPIXEL)];
    box_pos  = [(KIKS_BALLDATA(1,1)/KIKS_MMPERPIXEL),...
                 (KIKS_BALLDATA(1,2)/KIKS_MMPERPIXEL)];
end

