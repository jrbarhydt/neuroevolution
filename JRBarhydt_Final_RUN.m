% JRBarhydt_Final_RUN.m -- Neural Evolution via Genetic Algorithm to
% control a simulated Khemera robot during a box-pushing task.
%
% Intelligent Algorithms Final Project, SP'21
%
%--------------------------------------------------------------------------
% MATLAB Libraries Used:
%
%   kMatlab -- Matlab commands for Khepera
%   (http://ftp.k-team.com/pub/khepera/matlab/)
%   ======================================
%       by Yves Piguet (k-team.com), 08/1998
%          Skye Legon,  02/1999
%
%   KiKS -- KiKS is a Khepera Simulator
%   (http://www8.cs.umu.se/kurser/TDBD17/VT04/dl/kiks2.2.0/)
%   ======================================
%       by Theodore Nilsson (UMU.se), 03/2001
%
%--------------------------------------------------------------------------
% SETUP (IMPORTANT)
%     In order for this script to run, you must first run 
%                       kiks_setup
%     Or add the /kiks2.2.1/ folder to your path!
%
%--------------------------------------------------------------------------
try
    kiks;
catch err % kiks always errors on first boot.
    kiks;
end
%--------------------------------------------------------------------------
% TROUBLESHOOTING
%     Sometimes the kiks program returns an error, simply rerun
%     kiks without closing the window. If you see the default arena with a
%     cartoon khemera robot in the center, then the program has
%     successfully loaded and you may begin.
%
% =========================================================================
% This script uses selection, crossover and mutation to optimize 
% the fitness using a genetic algorithm method.
%--------------------------------------------------------------------------
% set run params
    display_animation = false;
    seed=0;
    popsize=20;
    chromosome_size=256;
    maxgen=30;
    pcross=0.4;
    pmutate=0.01;
    doping=false;
    task_list = [0]; % which task(s) to perform, i.e. [0, 1, 2, 5, 6, 7]
%--------------------------------------------------------------------------
% init vars
    i=1;
    pop=ga_population(popsize, chromosome_size, maxgen, ...
                      pcross, pmutate, task_list);
    maxfit=zeros(1,maxgen);
    minfit=zeros(1,maxgen);
    avefit=zeros(1,maxgen);
    if display_animation == false
        kiks_arena_window_close;
    end
% run first generation simulation
    pop.update();
% evolve
    while pop.maxgen>0
        disp("Running Generation #" + i + " ...");
        pop=ga_generation(pop, doping);
        maxfit(i)=pop.maxfitness;
        disp("    Max Fitness = " + maxfit(i));
        minfit(i)=pop.minfitness;
        avefit(i)=pop.avefitness;
        i=i+1;
    end
% display solution
    % plot results
    fig1=figure(5);
    subplot(3,1,1);
    plot(maxfit, "LineWidth", 3);
    xlabel("Generation No."); ylabel("Fitness Value");
    title("Maximally fit individual of each generation", "Color", "k");
    subplot(3,1,2);
    plot(minfit, "LineWidth", 3);
    xlabel("Generation No."); ylabel("Fitness Value");
    title("Minimally fit individual of each generation", "Color", "b");
    subplot(3,1,3);
    plot(avefit, "LineWidth", 3);
    xlabel("Generation No."); ylabel("Fitness Value");
    title("Average generation fitness", "Color", "r");

    dim = [.7 .6 .3 .3];
    str = sprintf(['Configuration: ' ...
        '\n  size=%i' ...
        '\n  chrom-size=%i' ...
        '\n  pcross=%.2f' ...
        '\n  pmutate=%.4f'], ...
        popsize,chromosome_size, pcross, pmutate);
    annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor','w')
    %darkBG(fig1);

