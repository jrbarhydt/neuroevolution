%==========================================================================
    function x = util_rand_in_range(min, max)
%==========================================================================
% generate random val based on uniform distribution (see pdf below)
% f(x)   = { 1/(max-min), x in [min, max]
%          {           0, else
%
% input         description
% -------------------------------------------------
% min           minimum value
% max           maximum value
%
% output
% --------------------------------
% x             random value
%--------------------------------------------------------------------------
        x = (max-min)*rand + min;
%--------------------------------------------------------------------------