% -----------------------------------------------------
%  (c) 2000-2004 Theodor Storm <theodor@tstorm.se>
%  http://www.tstorm.se
% -----------------------------------------------------

function ptch = kiks_robotlmppatch(id)
ptch=patch('Facecolor',[0.5 0.5 0.5],'EdgeColor','none','tag',sprintf('@handle %d',id));