%=POPULATION=CLASS=========================================================
classdef ga_population < handle
%==========================================================================
% genetic algorithm population structure class
%
%--------------------------------------------------------------------------
    %=CLASS=PROPS==========================================================
    properties
        %element           type    description 
        %------------------------------------------------------------------
        size               int32;  % population size
        lchrom             int32;  % chromisome length
        maxgen             int32;  % maximum remaining generations
        task_list          int32;  % list of tasks to perform
        pcross            double;  % probability of crossover (~1)
        pmutate           double;  % probability of mutation  (~0)
        sumfitness        double;  % sum fitness of the generation
        minfitness        double;  % min fitness of the generation
        maxfitness        double;  % max fitness of the generation
        avefitness        double;  % ave fitness of the generation
        bestindiv  ga_individual;  % individual with best fitness score
        nmutate            int32;  % total number of mutations
        ncross             int32;  % total number of crossovers
        indiv      ga_individual;  % array of population members
    end
    %=PUBLIC=METHODS=======================================================
    methods
        %=POP==============================================================
        function self = ga_population(popsize, lchrom, ...
                                      maxgen, pcross, pmutate, task_list)
        %==================================================================
        % pop class constructor. creates instance of population object.
        % 
        %------------------------------------------------------------------
            % set class props
            self.maxgen = maxgen;
            self.lchrom = lchrom;
            self.pcross = pcross; 
            self.pmutate = pmutate;
            self.size=0;
            self.task_list = task_list;
            % generate random individuals based on popsize
            for i=1:popsize
                self.add_indiv
            end
        end
        
        %=ADD_INDIV========================================================
        function add_indiv(self, ind)
        %==================================================================
        % function to create a new member of the population, by random
        % chromosome generation if individual not provided
        %
        %   input           despription
        %   ---------------------------
        %   ind (optional)  individual to add to population (optional)
        %
        %------------------------------------------------------------------
            % Create individual member of the population
            if ~exist('ind','var')
                ind = ga_individual;
                bit_depth = 8;
                % random left chromisome, but all nodes on by default
                ind.chrom_l = util_coin_flip(0.5, self.lchrom);
                ind.chrom_l(1+0*bit_depth)=1; % node 1
                ind.chrom_l(1+1*bit_depth)=1; % node 2
                ind.chrom_l(1+2*bit_depth)=1; % node 3
                ind.chrom_l(1+3*bit_depth)=1; % node 4
                % random right chromisome, but all nodes on by default
                ind.chrom_r = util_coin_flip(0.5, self.lchrom);
                ind.chrom_r(1+0*bit_depth)=1; % node 1
                ind.chrom_r(1+1*bit_depth)=1; % node 2
                ind.chrom_r(1+2*bit_depth)=1; % node 3
                ind.chrom_r(1+3*bit_depth)=1; % node 4
            end
            self.indiv(self.size+1) = ind;
            self.siz;
        end %add_indiv
        
        %=UPDATE===========================================================
        function update(self)
        %==================================================================
        % function to run all individuals in the simulation and update all 
        % fitness scores.
        %
        %------------------------------------------------------------------
            self.siz;
            self.get_fitness_scores
            self.sumfit;
            self.minfit;
            self.maxfit;
            self.avefit;
            self.bestfit;
        end %update
        
        %=MATING_PROBABILITY===============================================
        function p = mating_probability(self, j)
        %==================================================================
        % function to determine probability that an individual will be
        % selected for mating, based on highest fitness in ratio to
        % to population.
        %
        %   output      description
        %   ---------------------------
        %   p           probability individual will mate
        %
        %------------------------------------------------------------------
            % calculate mating probability for individual j
            if self.sumfitness == 0
                p = 0;
            else
                p = self.indiv(j).fitness / self.sumfitness;
            end
        end
        
        %=SELECT_MATE======================================================
        function indiv_idx = select_mate(self)
        %==================================================================
        % function to select an individual from the population for mating,
        % based on roulette wheel selection.
        %
        %   output      description
        %   ---------------------------
        %   indiv_idx   index of individual selected for mating
        %
        %------------------------------------------------------------------
            rrand = util_rand_in_range(0, self.sumfitness);
            psum = 0;
            s = 1;
            while psum<=rrand && s<self.size
                s = s + 1;
                psum = psum + self.indiv(s).fitness;
            end
            indiv_idx = s;
        end %find_mate
        
        %=CROSSOVER_PAIR===================================================
        function [chi1, chi2] = crossover_pair(self, mate1_idx, mate2_idx)
        %==================================================================
        % function to select which genetic material is swapped during
        % mating, based on pcross.
        %
        %   input       despription
        %   ---------------------------
        %   mate1_idx   index of first member of mating pair
        %   mate2_idx   index of second member of mating pair
        %  <mateX_idx>  <note: some species combine genetic material from
        %                   more than two mating individuals>
        %
        %   output      description
        %   ---------------------------
        %   chi1        new 'child' individual generated from crossover
        %   chi2        new 'child' individual generated from crossover
        %
        %------------------------------------------------------------------
            % determine if crossover occurs
            crossover = util_coin_flip(self.pcross);
            par1 = self.indiv(mate1_idx); % parent 1
            par2 = self.indiv(mate2_idx); % parent 2
            % generate children
            chi1 = ga_individual; chi2 = ga_individual;
            chi1.chrom_l = par1.chrom_l; chi1.chrom_r = par1.chrom_r;
            chi2.chrom_l = par2.chrom_l; chi2.chrom_r = par2.chrom_r;
            % assign parents
            chi1.parent1 = par1; chi1.parent2 = par2;
            chi2.parent1 = par1; chi2.parent2 = par2;    
            if crossover
                % determine crossover location
                crossover_site = util_rand_in_range(1, self.lchrom);
                % set crossover locations
                par1.xsite = crossover_site;
                par2.xsite = crossover_site;
                
                % perform genetic crossover if parent is not elite
                if ~par1.elite
                    chi1.chrom_l(par1.xsite:end) = ...
                        par1.chrom_l(par1.xsite:end);
                    chi1.chrom_r(par1.xsite:end) = ...
                        par1.chrom_r(par1.xsite:end);
                    self.ncross = self.ncross + 1;
                end
                if ~par2.elite
                    chi2.chrom_l(par2.xsite:end) = ...
                        par2.chrom_l(par2.xsite:end);
                    chi2.chrom_r(par2.xsite:end) = ...
                        par2.chrom_r(par2.xsite:end);
                    self.ncross = self.ncross + 1;
                end               
            end
        end %crossover        
        
        %=MUTATE===========================================================
        function mutate(self, indiv)
        %==================================================================
        % function to perform genetic mutation on entire chromosome of 
        % given individual based on pmutate.
        %
        %   input       despription
        %   ---------------------------
        %   indiv       individual to perform mutation on
        %
        %   output      description
        %   ---------------------------
        %   none        none
        %
        %------------------------------------------------------------------
            % mutate left chromisome
            for i=1:self.lchrom
                do_mutation = util_coin_flip(self.pmutate);
                if do_mutation
                    indiv.chrom_l(i) = ~indiv.chrom_l(i);
                    self.nmutate = self.nmutate + 1;
                end
            end
            % mutate right chromisome
            for i=1:self.lchrom
                do_mutation = util_coin_flip(self.pmutate);
                if do_mutation
                    indiv.chrom_r(i) = ~indiv.chrom_r(i);
                    self.nmutate = self.nmutate + 1;
                end
            end    
        end %mutate
        
    end %methods
    %=PRIVATE=METHODS======================================================
    methods (Access = private)
        function siz(self)
            % Return size of population
            self.size = length(self.indiv);
        end

        function get_fitness_scores(self)
            % Run simulation to get fitness scores
            for i=1:self.size
                self.indiv(i).get_fitness_score(self.task_list); 
            end            
        end %get_fitness_scores
        
        function sumfit(self)
            % Return sum of fitness scores and update class prop
            sumfit = 0;
            for i=1:self.size
                sumfit = sumfit+self.indiv(i).fitness;
            end
            self.sumfitness=sumfit;
        end %sumfit
        
        function minfit(self)
            % Return minimum fitness score in population and update
            % class prop
            minfit = inf;
            for i=1:self.size
                if self.indiv(i).fitness < minfit
                    minfit = self.indiv(i).fitness;
                end
            end
            self.minfitness = minfit;
        end %minfit
        
        function maxfit(self)
            % Return minimum fitness score in population and update
            % class prop
            maxfit = 0;
            for i=1:self.size
                if self.indiv(i).fitness > maxfit
                    maxfit = self.indiv(i).fitness;
                end
            end
            self.maxfitness = maxfit;
        end %maxfit

        function avefit(self)
            % Return ave fitness score in population and update
            % class prop
            self.avefitness = self.sumfitness/double(self.size);
        end %avefit
        
        function bestfit(self)
            % Return indiv with best fitness and update
            % class prop
            maxfit=-1000;
            best = self.bestindiv;
            for i=1:self.size
                if self.indiv(i).fitness > maxfit
                    maxfit = self.indiv(i).fitness;
                    best = self.indiv(i);
                end
            end
            self.bestindiv = best;            
        end %bestfit        
    end %methods (Access = private)
end