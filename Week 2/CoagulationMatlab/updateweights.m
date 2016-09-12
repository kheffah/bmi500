function updateweights(error)
global agent

agent.wo = agent.wo + agent.orate * agent.ewo .* (ones(agent.nh+1,1) * error); %learning_rate x eligibility trace x error 

if agent.hrate ~= 0
  for ou = 1:agent.no
    row = (ou-1)*(agent.ni)+1; %    row = (ou-1)*(numInputs+1)+1;
    agent.wh = agent.wh + agent.hrate * error(ou) * agent.ewh(row:row+agent.ni-1,:); %ewh(row:row+numInputs,:);
  end
end




