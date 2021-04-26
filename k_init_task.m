%==========================================================================
function k_handle = k_init_task(task_number)
%==========================================================================
% connect to simulated khemera robot and create arena with task-0 starting
% parameters.
%
% input         description
% --------------------------------
% task number   0-8 value for selecting task instance. 
%                   note task -1 is for testing, as it 
%                   starts with the robot and ball lined
%                   up for an easy high score.
%
% output
% --------------------------------
% k_handle      khemera serial communication object
%--------------------------------------------------------------------------
    switch task_number
        case -1
            robot_loc = [50, 100];
            box_loc = [180, 100];
            rot_speed = 14.25;
        case 0
            robot_loc = [50, 150];
            box_loc = [180, 140];
            rot_speed = 17.5;
        case 1
            robot_loc = [50, 150];
            box_loc = [180, 100];
            rot_speed = 17.5;
        case 2
            robot_loc = [50, 150];
            box_loc = [180, 50];
            rot_speed = 20; 
        case 3
            robot_loc = [50, 110];
            box_loc = [180, 140];
            rot_speed = 15;
        case 4
            robot_loc = [50, 110];
            box_loc = [180, 110];
            rot_speed = 16.25;
        case 5
            robot_loc = [50, 110];
            box_loc = [180, 50];
            rot_speed = 16.25;
        case 6
            robot_loc = [50, 50];
            box_loc = [180, 150];
            rot_speed = 9.25;
        case 7
            robot_loc = [50, 50];
            box_loc = [180, 110];
            rot_speed = 9.25;
        case 8
            robot_loc = [50, 50];
            box_loc = [180, 50];
            rot_speed = 10;
    end
    % initialize arena
    arena = zeros(600,200);
    % position khepera robot
    arena(robot_loc(1), robot_loc(2))=-1;
    % position box
    arena(box_loc(1), box_loc(2))=3;
    % instantiate arena
    kiks_arena(arena);
    % initialize and open khemera comms
    port=-1;
    baud=9600;
    k_handle=kiks_kopen([port,baud,1]);
    % init robot to zero
    kSetSpeed(k_handle,0,0);
    % rotate robot to desired angle for this task
    for i = 0:30
        kSetSpeed(k_handle,rot_speed,-rot_speed);
    end
    % reset robot to zero
    kSetSpeed(k_handle,0,0);
    
end

