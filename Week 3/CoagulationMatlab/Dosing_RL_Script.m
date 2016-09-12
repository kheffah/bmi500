%cd('CoagulationMatlab')   Make sure you're in the right folder
global agent env sim
%% Define data structures.
env.indx_patient = 1; % patient#1, patient#2, or patient#3
env.state = [0 0];
env.r = -1;				% reinforcement
env.display = 1;
env.displayrate = 1;
env.deltaT = 1;			% time step for integration

%Methods
% nextstate
% showenv
agent.ni = 2;				% number of inputs
agent.nh = 20;				% number of hidden units
agent.no = 3;				% number of outputs
agent.epsilon = 0.01;       % random action probability
agent.sigma = 1;			% width parameter for hidden gaussians
agent.orate = 0.01;			% output learning rate
agent.hrate = 0.005;			% hidden learning rate
agent.lambda = 0.5;			% decay factor for eligibilities
agent.gamma = 0.99;			% discount factor
agent.displaysurf = 1;
agent.displaysurfrate = 10;
agent.displayrbfs = 1;
agent.displayrbfsrate = 10;
agent.maxinput = [120  10];
agent.mininput = [0   0];

agent.wh = [];				% hidden layer weights
agent.wo = [];				% output layer weights
agent.x = [];				% input 
agent.h = [];				% output of hidden layer
agent.p = [];				% output of output layer
agent.action = 0;			% output action
agent.ewh = [];				% hidden layer eligibilities
agent.ewo = [];				% output layer eligibilities
%
sim.maxtrials = 50;
sim.display = 1;
sim.displayrate = 1;

sim.reset = 0;
sim.running = 1;
sim.trial = 0;
sim.step = 0;				% step within trial
sim.perf = zeros(1,50);		% allocate space for 10,00 trials
%% initialization
%initagenttrial()
initagent()
initstate()
initgui()
startsim()
