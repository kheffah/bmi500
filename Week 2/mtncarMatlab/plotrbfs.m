function showrbfs()
global agent Q

%  r = sqrt(-log(0.1)/agent.sigma);
%  circle(agent.wh',r);
%end

n=50;

Q = zeros(n,n); %,3);

scale = size(colormap,1);

dx1 = (agent.maxinput(1)-agent.mininput(1))/(n-1);
dx2 = (agent.maxinput(2)-agent.mininput(2))/(n-1);
x1s = agent.mininput(1):dx1:agent.maxinput(1);
x2s = agent.mininput(2):dx2:agent.maxinput(2);
for c = 1:n
  for r = 1:n
    p = calcoutput([x1s(c) x2s(r)]);
    [junk,index] = max(p);
    if index == 1,
      Q(r,c,:) = 60;
    elseif index == 2,
      Q(r,c,:) = 1;
    else 
      Q(r,c,:) = 30;
    end
%    Q(r,c) = (index-1)/2 * scale ; %index into colormap
  end
end


image(Q);
axis xy
axis tight
%Q(1,1)=Q(1,1)+0.02;

%contourf(Q,[1.5 2.5]);
title('Actions Using Current Value Function');
xlabel('Position'); ylabel('Velocity');
%colorbar;




