function newstate = nextstate(action)
global env

% Simulates the environment: (s_t,a_t) -> s_t+1

%x = env.state(1) + 0.1 * env.state(2);
%xd = env.state(2) + 0.1 * (0.01 * (action-2) - 0.025 * cos(3*env.state(1));

x = env.state(1);
xdot = env.state(2);

%action = 3;

newx = x + env.deltaT * xdot;
newxdot = xdot + env.deltaT * (-9.8 * env.mass * cos(3 * x) + env.force / env.mass * (action-2) - env.friction * xdot);

if newx < -1.2
  newx = -1.2;
  newxdot = 0.;
end

%mm = [mm; newx newxdot action];

%if newxdot < -0.07
%  newxdot = -0.07;
%elseif newxdot > 0.07
%  newxdot = 0.07;
%end

newstate = [newx newxdot];
  
