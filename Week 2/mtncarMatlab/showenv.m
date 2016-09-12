function showenv(handle)
global env agent delay

if ~isempty(delay) & delay ~= 0, pause(delay), end;

x1 = env.state(1)-0.05;
x2 = x1 + 0.1;
y1 = sin(3*env.state(1));
y2 = y1+0.1;

if agent.action == 1
  color = [1 0 0]*.9;
elseif agent.action == 3
  color = [0 1 0]*.9;
else
  color = [1 1 1]*.9;
end

set(handle,'xdata',[x1 x2 x2 x1],'ydata',[y1 y1 y2 y2],'FaceColor',color);
