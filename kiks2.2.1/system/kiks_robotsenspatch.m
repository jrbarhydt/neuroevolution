% -----------------------------------------------------
%  (c) 2000-2004 Theodor Storm <theodor@tstorm.se>
%  http://www.tstorm.se
% -----------------------------------------------------

function ptch = kiks_robotsenspatch(id,nr)
ptch=patch('Facecolor',[.25 .3 .35 ],'EdgeColor','none','tag',sprintf('%dsens',id));