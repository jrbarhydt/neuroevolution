%=GENERATION=FUNCTION======================================================
function new_pop = ga_generation(old_pop, doping)
%==========================================================================
% function to generate new population from given population, representing
% a new generation of the population.
%
%   input       despription
%   ---------------------------
%   old_pop     original population object
%
%   output      description
%   ---------------------------
%   new_pop     new population object
%
%--------------------------------------------------------------------------
    % instantiate new generation object
    new_pop = ga_population(0, old_pop.lchrom, old_pop.maxgen-1, ...
                            old_pop.pcross, old_pop.pmutate, ...
                            old_pop.task_list);
    % remember best individual
    new_pop.bestindiv = old_pop.bestindiv;
    %==================================================================
    % perform crossover to build new generation from the mating pool.
    %------------------------------------------------------------------
    for i=1:old_pop.size/2
        % select mating pair
        mate1_idx = old_pop.select_mate;
        mate2_idx = old_pop.select_mate; 
        % perform crossover and receive chilren
        [child1, child2] = old_pop.crossover_pair(mate1_idx, mate2_idx);
        % mutate children
        old_pop.mutate(child1);
        old_pop.mutate(child2);
        % add children to new generation
        new_pop.add_indiv(child1);
        new_pop.add_indiv(child2);
    end
    % optionally apply doping
    if doping == true
        doped_indiv_idx = util_rand_in_range(1, old_pop.size);
        new_pop.indiv(doped_indiv_idx) = old_pop.bestindiv;
    end
    % run simulation on new gen
    new_pop.update;
end
