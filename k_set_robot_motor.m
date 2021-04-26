function k_set_robot_motor(k_handle, l_r_motor_pwr_percentage, pwr_mult)
%==========================================================================
% send command to robot to engage motors at desired level, which is
% converted to PWM pulse width. pwr_mult is an optional debugging value.
%
% input                      description
% --------------------------------
% k_handle                   khemera serial communication object
% l_r_motor_pwr_percentage   tuple representing power percentage to deliver
%                                [left motor, right motor]
% pwr_mult                   power delivery multiplier (increases
%                                simulation step-size for debugging)
%--------------------------------------------------------------------------
    if ~exist('pwr_mult','var')
        pwr_mult=1;
    end
    l_motor_pwr = 10*l_r_motor_pwr_percentage(1)*pwr_mult;
    r_motor_pwr = 10*l_r_motor_pwr_percentage(2)*pwr_mult; 
    kSetSpeed(k_handle,l_motor_pwr, r_motor_pwr);
end

