% cd('mtncarMatlab') % make sure you're in the right folder
global agent env sim
%% Define data structures.
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
%
sim.maxtrials = 1000;
sim.display = 1;
sim.displayrate = 1;

sim.reset = 0;
sim.running = 1;
sim.trial = 0;
sim.step = 0;				% step within trial
sim.perf = zeros(1,10000);		% allocate space for 10,000 trials
%% initialization
%initagenttrial()
initagent()
initstate()
initgui()
startsim()
