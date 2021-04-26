%==========================================================================
function x = util_coin_flip(p, quantity)
%==========================================================================
% perform a coin flip based on bernoulli distribution (see pdf below)
% f(x|p) = { 1-p, x=0
%          {   p, x=1
%
% input         description
% -------------------------------------------------
% p             probability of success, 0<=p<=1
%
% output
% --------------------------------
% x             outcome of bernoulli trial (flip)
%--------------------------------------------------------------------------
    if ~exist('quantity','var')
        quantity = 1;
    end
    x = rand(1, quantity)<p;
%--------------------------------------------------------------------------