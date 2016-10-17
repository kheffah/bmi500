function initstate()
global env

%env.state = [rand*1.7-1.2 rand*3.0-1.5]; %initial state
env.state = [rand*1.7-1.2 0]; %initial state

%env.state = [rand*1.7-1.2 rand*.14-0.07]; %initial state