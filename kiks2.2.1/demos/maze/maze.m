% -----------------------------------------------------
%  (c) 2000-2004 Theodor Storm <theodor@tstorm.se>
%  http://www.tstorm.se
% -----------------------------------------------------
function maze(port,baud,maze_size)
% maze(port,baud)
% port = serial port to communicate with (port<0 ==> simulated robot, port>=0 ==> real robot
% baud = baud rate
% maze_size = size of maze

if(nargin<3) maze_size=16; end;
if(nargin<2) baud=9600; end;
if(nargin<1) port=-1; end;

if port<0 % only if this is a simulated robot
   kiks_arena(kiks_generate_maze(maze_size,maze_size)); % set up a new arena using the kiks_generate_maze function
end;

ref=kiks_kopen([port,baud,1]);
reflex = 0;
speed = [1 1];
loops=0; % for calculating loops/second
t0=clock; % for calculating loops/second
kSetEncoders(ref,0,0);
lights=kAmbient(ref);
while (min(lights)>0) % stop when robot gets near the light
   loops=loops+1; % for calculating loops/second
   reflex = kProximity(ref);
   weightsL = [-1 4 0  3 0 0 0 0 0]; %weightsL = [0 0 0 0 0 0 0 0 0];
   weightsR = [ 3 0 0 -8 0 0 0 0 0]; %weightsR = [0 0 0 0 0 0 0 0 0];
   speed = calcspd(weightsL,weightsR,reflex);
   if speed==[0 0] speed=[1 1]; end;
   kSetSpeed(ref,speed(1),speed(2));   
   mov_err = kGetStatus(ref);
   backup(ref,[mov_err(3) mov_err(6)],speed);
   lights = kAmbient(ref); 
end;
kSetSpeed(ref,0,0);
% calculate stats
fprintf('%1.0f seconds simulated in %1.0f seconds (%3.0f%% of real time)\n',kiks_ktime(port),etime(clock,t0),(kiks_ktime(port)/etime(clock,t0))*100)
fprintf('%1.1f loops / second\n',loops/kiks_ktime(port))
% close port
kiks_kclose(ref);


function out = calcspd(weightsL, weightsR, reflex)
mL = weightsL(1);
mR = weightsR(1);
  for i=2:9
    mL = weightsL(i)*(1/1023)*reflex(i-1)+mL;
    mR = weightsR(i)*(1/1023)*reflex(i-1)+mR;
 end
out = [round(mL) round(mR)];


function R = backup(ref,mov_err,spd)
if mov_err>spd*0.8
   % back up
   kSetEncoders(ref,0,0);
   kMoveTo(ref,-100,-500);
%   kiks_pause(1);
   status=kGetStatus(ref);
   while(status(1)+status(2)<2)
      status=kGetStatus(ref);
   end;
end;
