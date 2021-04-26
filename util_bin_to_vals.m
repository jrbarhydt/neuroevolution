%==========================================================================
    function nn_weights = util_bin_to_vals(bin)
%==========================================================================
% binary decoding function
%
% input     description
% --------------------------------
% bin       list of binary values
%
%
% outputs   description
% --------------------------------------------------
% n1        denotes connectivity of hidden node 1
% w1        denotes weight of hidden node 1
% n2        denotes connectivity of hidden node 2
% w2        denotes weight of hidden node 2
% n3        denotes connectivity of hidden node 3
% w3        denotes weight of hidden node 3
% n4        denotes connectivity of hidden node 4
% w4        denotes weight of hidden node 4
% w5-w72    denotes weights of inputs
%--------------------------------------------------------------------------
% init
    bin_a = bin(1:32);
    bin_b = bin(33:end);
    l_val = (length(bin_a)-4)/4; % 7 bits for hidden layer weights
    l_valb = 4; % 4 bits for input weights
    max_int = util_bin_to_int(ones(1,l_val));
    max_intb = util_bin_to_int(ones(1,l_valb));
    w=zeros(1,length(bin_b)/l_valb);
% determine connectivity vals
    n1=bin_a(1);n2=bin_a(2+l_val);n3=bin_a(3+2*l_val);n4=bin_a(4+3*l_val);
%--------------------------------------------------------------------------
% calculate w1 integer value
    w1_int = util_bin_to_int(bin_a(0*l_val+2:1+1*l_val));
%--------------------------------------------------------------------------
% calculate w2 integer value
    w2_int = util_bin_to_int(bin_a(1*l_val+3:2+2*l_val));
%--------------------------------------------------------------------------
% calculate w2 integer value
    w3_int = util_bin_to_int(bin_a(2*l_val+4:3+3*l_val));
%--------------------------------------------------------------------------
% calculate w2 integer value
    w4_int = util_bin_to_int(bin_a(3*l_val+5:4+4*l_val));
%--------------------------------------------------------------------------
% calculate input weights
    for i=1:length(w)
        w(i) = util_bin_to_int(bin_b(1+(i-1)*l_valb:(i)*l_valb));
        w(i) = w(i)/max_intb;
    end
%--------------------------------------------------------------------------
% convert integer values to double
    w1 = w1_int/max_int;
    w2 = w2_int/max_int;
    w3 = w3_int/max_int;
    w4 = w4_int/max_int;
    
    nn_weights = horzcat([n1,w1,n2,w2,n3,w3,n4,w4],w);