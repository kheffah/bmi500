function initagenttrial()
global agent

agent.ewo = zeros(agent.nh+1,agent.no);
agent.ewh = zeros((agent.ni) * agent.no, agent.nh);

%ewh = zeros((numInputs+1)*numOutputs, numHidden);
