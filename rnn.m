%==========================================================================
    function output = rnn(input, prev_input, nn_weights)
%==========================================================================
% recursive neural network, up to 4 hidden layer nodes, single 
% previous input
%
% inputs    description
% --------------------------------
% bin       list of binary values
%
%
% output
% --------------------------------
% dec       decimal integer value
%--------------------------------------------------------------------------
    input_weights = nn_weights(9:end);
    hidden_weights = [nn_weights(1)*nn_weights(2) ...
                      nn_weights(3)*nn_weights(4) ...
                      nn_weights(5)*nn_weights(6) ...
                      nn_weights(7)*nn_weights(8)];
    % calc input weights dot product
    hidden_1 = dot(input, input_weights( 1:14));
    hidden_2 = dot(input, input_weights(15:28));
    hidden_3 = dot(input, input_weights(29:42));
    hidden_4 = dot(input, input_weights(43:56));
    % add recurrence input
    hidden_1 = hidden_1 + dot(prev_input, input_weights( 1:14));
    hidden_2 = hidden_2 + dot(prev_input, input_weights(15:28));
    hidden_3 = hidden_3 + dot(prev_input, input_weights(29:42));
    hidden_4 = hidden_4 + dot(prev_input, input_weights(43:56));    
    % calculate activation values
    theta_hidden = [util_sigmoid(hidden_1) ...
                    util_sigmoid(hidden_2) ...
                    util_sigmoid(hidden_3) ...
                    util_sigmoid(hidden_4)];
    % calc output weights dot product
    hidden_nodes = dot(theta_hidden, hidden_weights);
    output = util_sigmoid(hidden_nodes);
    
    end %for
%--------------------------------------------------------------------------

