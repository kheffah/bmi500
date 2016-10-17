function showperf(sim)
global sim

cla;
line(1:sim.trial, sim.perf(1:sim.trial));
%  title('Steps till Goal versus Learning Trials');
%  xlabel('Trial'); ylabel('Steps');
%  axis tight
