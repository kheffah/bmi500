function resetsim()
global sim

disp('resetting');

sim.trial = 0;
sim.running = 0;

initagent;
