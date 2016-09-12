function Q = plotQ(n)
global agent

Q = zeros(n,n);

c = 0;
dx1 = (agent.maxinput(1)-agent.mininput(1))/(n-1);
dx2 = (agent.maxinput(2)-agent.mininput(2))/(n-1);
x1s = agent.mininput(1):dx1:agent.maxinput(1);
x2s = agent.mininput(2):dx2:agent.maxinput(2);
for c = 1:n
  for r = 1:n
    p = calcoutput([x1s(c) x2s(r)]);
    Q(r,c) = max(p);
%    [sortedp,sortedi] = sort(p);
%    Q(r,c) = sortedi(3);

  end
end

surf(ones(n,1)*x1s,x2s'*ones(1,n),-Q);
view([20 60]);
xlabel('Position'); ylabel('Velocity'); zlabel('Steps')
title('Value Function')
axis tight


