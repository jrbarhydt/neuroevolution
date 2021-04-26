%==========================================================================
function sensor_vals = k_get_sensor_vals(k_handle)
%==========================================================================
% retrieve khemera sensor values and calculate edges according to diagram.
%     values are returned relative to max in range [0,1]
%      ___________        
%     /   3   4   \        inputs and edges:
%    2             5       1-8 proximity sensor values
%   1  |H|     |H|  6        9 sensor 1-2 (left edge)
%   |  |H|     |H|  |       10 sensor 2-3 (front-left edge)
%    \             /        11 sensor 3-4 (front edge)
%      \_8_____7_/          12 sensor 4-5 (front-right edge)
%                           13 sensor 5-6 (right edge)
%                           14 sensor 7-8 (rear edge)
%
% input         description
% --------------------------------
% k_handle      khemera serial communication object
%
% output
% --------------------------------
% sensor_vals   vector of sensor and edge-detection values (0-1024)
%--------------------------------------------------------------------------
    sensor_vals       = zeros(1, 16);
    sensor_vals(1:8)  = kProximity(k_handle);
    sensor_vals(9:13) = sensor_vals(1:5)-sensor_vals(2:6);
    sensor_vals(14)   = sensor_vals(7)-sensor_vals(8);
    sensor_vals       = sensor_vals./1024;
end

