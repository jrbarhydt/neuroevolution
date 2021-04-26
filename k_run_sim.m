function [box_init_pos, box_pos, robot_pos] = ...
    k_run_sim(task_number, nn_weights)
%==========================================================================
% runs the khemera simulation and returns box starting/ending position and
% robot ending position.
%
% inputs        description
% -------------------------------------------------
% task number   0-8 value for selecting task instance. 
%                   note task -1 is for testing, as it 
%                   starts with the robot and ball lined
%                   up for an easy high score.
% nn_weights    vector of neural network weights         
%
% output
% --------------------------------
% distance      distance between points
%--------------------------------------------------------------------------
% get khemera serial comms handle
    k_handle = k_init_task(task_number);
% get initial ball position in arena coordinates
    [~, box_init_pos] = k_get_arena_data;
% init controller input / output
    input = zeros(1, 14);
    prev_input = zeros(1, 14);
    output = zeros(1, 2); 
    for i = 0:150
        sensor_vals = k_get_sensor_vals(k_handle);
        input = sensor_vals(1:14);
        output(1) = rnn(input, prev_input, nn_weights(1,:));
        output(2) = rnn(input, prev_input, nn_weights(2,:));
        k_set_robot_motor(k_handle, output);
        [robot_pos, box_pos] = k_get_arena_data;
        prev_input = input;
    end
% close serial comms
    k_end_task(k_handle);
end

