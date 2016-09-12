global env agent perf sim

more off				% so matlab won't freeze when output hits pagefull

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Initialize gui.
initgui;


envtag = findobj('Tag','envaxis');
agenttag = findobj('Tag','agentsurfaxis');
simtag = findobj('Tag','simperfaxis');

axes(findobj('Tag','envaxis'));
plot([-1.2:0.1:0.5],sin(3*[-1.2:0.1:0.5]),'k-');
axis([-1.2 .5 -1 1]);
title('Mountain Car World');
xlabel('Position'); ylabel('Height');
hold on
fill([-0.05 0.05],[0 0.05],'r','erasemode','xor','tag','car');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Define data structures.

env.state = [0 0];
env.r = 0;				% reinforcement
env.display = 1;
env.displayrate = 1;
env.mass = 0.2;				% mass of car
env.force = 0.2;			% force of each push
env.friction = 0.5;			% coefficient of friction
env.deltaT = 0.1;			% time step for integration

%Methods
% nextstate
% showenv

agent.ni = 2;				% number of inputs
agent.nh = 25;				% number of hidden units
agent.no = 3;				% number of outputs
agent.epsilon = 0.01;			% random action probability
agent.sigma = 1;			% width parameter for hidden gaussians
agent.orate = 0.01;			% output learning rate
agent.hrate = 0.0;			% hidden learning rate
agent.lambda = 0.5;			% decay factor for eligibilities
agent.gamma = 1;			% discount factor
agent.displaysurf = 1;
agent.displaysurfrate = 10;
agent.displayrbfs = 1;
agent.displayrbfsrate = 10;
agent.maxinput = [0.5 1.5];
agent.mininput = [-1.2 -1.5];

agent.wh = [];				% hidden layer weights
agent.wo = [];				% output layer weights
agent.x = [];				% input 
agent.h = [];				% output of hidden layer
agent.p = [];				% output of output layer
agent.action = 0;			% output action
agent.ewh = [];				% hidden layer eligibilities
agent.ewo = [];				% output layer eligibilities

%Methods
% initagent
% updateelig
% calcoutput
% updateweights
% showrbfs

sim.maxtrials = 1000;
sim.display = 1;
sim.displayrate = 1;

sim.reset = 0;
sim.running = 1;
sim.trial = 0;
sim.step = 0;				% step within trial
sim.perf = zeros(1,10000);		% allocate space for 10,000 trials

%Methods
% showperf
% initgui
% runtillpaused
% reset

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Set initial values in gui.

set(findobj('tag','dispenv'),'String',num2str(env.displayrate));
set(findobj('tag','toggleenv'),'Value',env.display);

set(findobj('tag','nh'),'String',num2str(agent.nh));
set(findobj('tag','epsilon'),'String',num2str(agent.epsilon));
%set(findobj('tag','sigma'),'String',num2str(agent.sigma));
set(findobj('tag','orate'),'String',num2str(agent.orate));
set(findobj('tag','hrate'),'String',num2str(agent.hrate));
set(findobj('tag','lambda'),'String',num2str(agent.lambda));
set(findobj('tag','gamma'),'String',num2str(agent.gamma));
set(findobj('tag','dispagentsurf'),'String',num2str(agent.displaysurfrate));
set(findobj('tag','toggleagentsurf'),'Value',agent.displaysurf);
set(findobj('tag','dispagentrbfs'),'String',num2str(agent.displayrbfsrate));
set(findobj('tag','toggleagentrbfs'),'Value',agent.displayrbfs);

set(findobj('tag','dispsimperf'),'String',num2str(sim.displayrate));
set(findobj('tag','togglesimperf'),'Value',sim.display);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Initialize simulation.  Same function as the 'reset' menu item.

%%%%%%%------Fixes to take care of Matlab bugs!!------%%%%%%%%

set(envtag,'Tag','envaxis');
set(agenttag,'Tag','agentsurfaxis');
set(simtag,'Tag','simperfaxis');
findobj('Tag','simperfaxis')

resetsim;