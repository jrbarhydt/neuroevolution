%=INDIVIDUAL=CLASS=========================================================
classdef ga_individual < handle
%==========================================================================
% genetic algorithm individual structure class
% note: fitness based on maximizing u(x, y)=peaks(x, y)
%--------------------------------------------------------------------------
    %=CLASS=PROPS==========================================================
    properties
        %element           type    description 
        %------------------------------------------------------------------
        xsite             int32;   % crossover site index
        fitness          double;   % individual fitness score
        chrom_l         logical;   % binary chromosome array for left net
        chrom_r         logical;   % binary chromosome array for right net
        elite           logical;   % ignore crossover
        parent1   ga_individual;   % parent 1
        parent2   ga_individual;   % parent 2
    end
    %=PUBLIC=METHODS=======================================================    
    methods
        %=INDIVIDUAL=======================================================
        function self = ga_individual()
        %==================================================================
        % individual class constructor. creates instance of individual.
        % 
        %------------------------------------------------------------------
            self.elite = false;
        end

        %=DECODE=========================================================== 
        function [nn_weights_l, nn_weights_r] = decode(self)
        %==================================================================
        % calculates decimal value based on individual's chromosome content
        % which contains four sets of 8 bit values. The first bit of the
        % set determines the existence of the node, and the other 7 bits
        % represent the value in the range [0, 1].
        % 
        %   output          despription
        %   ---------------------------
        %   decivalue       decimal value
        %
        %------------------------------------------------------------------
            nn_weights_l = util_bin_to_vals(self.chrom_l);
            nn_weights_r = util_bin_to_vals(self.chrom_r);
        end
        
        %=FITNESS==========================================================
        function fitness = get_fitness_score(self, task_list)
        %==================================================================
        % calculates fitness score based on individual's simulation
        % performance
        % 
        %   output          despription
        %   ---------------------------
        %   fitness         decimal value
        %
        %------------------------------------------------------------------
            [nn_weights_l, nn_weights_r] = self.decode;
            fitness_ave = 0;
            for task = task_list
                [box_init_pos, box_pos, robot_pos] = ...
                    k_run_sim(task, [nn_weights_l; nn_weights_r]);
                fitness = 1.0*util_get_distance(box_init_pos, box_pos) - ...
                          0.5*util_get_distance(box_pos, robot_pos);
                if fitness < 0 % if box is never moved
                    fitness = 0;
                end
                fitness_ave = fitness_ave + fitness;
            end
            fitness = fitness_ave/length(task_list);
            self.fitness = fitness;
        end
    end
end

