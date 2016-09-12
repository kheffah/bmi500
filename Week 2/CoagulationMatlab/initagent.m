function initagent()
global agent

n = sqrt(agent.nh);
if n*n ~= agent.nh,
  disp('numHidden must be a square');
end
x1inc = (agent.maxinput(1)-agent.mininput(1))/(n-1);
x2inc = (agent.maxinput(2)-agent.mininput(2))/(n-1);
agent.wh = zeros(agent.ni,agent.nh);
m = 0;
for i1=agent.mininput(1):x1inc:agent.maxinput(1)
  for i2 = agent.mininput(2):x2inc:agent.maxinput(2),
    m = m + 1;
    agent.wh(1,m) = i1;
    agent.wh(2,m) = i2;
  end
end

%  wo = (rand(numHidden+1,numOutputs)-0.5) * 1;
agent.wo = zeros(agent.nh+1,agent.no);



%agent.wh = (rand(agent.ni,agent,nh)-0.5) * 0.1;
%agent.wo = (rand(agent.nh+1,agent.no)-0.5) * 0.1;
%agent.ewh = zeros((agent.ni)*agent.no, agent.nh);
%agent.ewo = zeros(agent.nh+1,agent.no);
