function guiparms(which,string)
global env agent perf sim

if nargin > 1
  value = eval(string);
end

switch (which)
  case 'dispenv'
    env.displayrate = value;
    env.display = value > 0;
    env
  case 'dispagentsurf'
    agent.displaysurfrate = value;
    agent.displaysurf = value > 0;
    agent
  case 'dispagentrbfs'
    agent.displayrbfsrate = value;
    agent.displayrbfs = value > 0.;
    agent
  case 'dispsimperf'
    sim.displayrate = value;
    sim.display = value > 0.;
    sim
  case 'toggleenv'
    env.display = ~env.display;
    env
  case 'toggleagentsurf'
    agent.displaysurf = ~agent.displaysurf;
    agent
  case 'toggleagentrbfs'
    agent.displayrbfs = ~agent.displayrbfs;
    agent
  case 'togglesimperf'
    sim.display = ~sim.display;
    sim
  case 'nh'
    agent.nh = value;
    resetsim;
    agent
  case 'hrate'
    agent.hrate = value;
    agent
  case 'orate'
    agent.orate = value;
    agent
  case 'lambda'
    agent.lambda = value;
    agent
  case 'gamma'
    agent.gamma = value;
    agent
  case 'epsilon'
    agent.epsilon = value;
    agent
end
