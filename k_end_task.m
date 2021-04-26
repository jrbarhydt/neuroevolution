%==========================================================================
function k_end_task(k_handle)
%==========================================================================
% disconnect from simulated khemera robot serial port.
%
% input         description
% --------------------------------
% k_handle      khemera serial communication object
%--------------------------------------------------------------------------
    kiks_kclose(k_handle);
end

