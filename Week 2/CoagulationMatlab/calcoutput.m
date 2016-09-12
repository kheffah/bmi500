function out = calcoutput(x)
% calcoutput:  y = calcoutput(x)  or  calcoutput(x)
%  If output is requested, then hidden and output layer values not stored in agent.
% 
% Neural Network to get the value of each action given current state
% Neural Network with radial basis activation: 
%      agent.wh    : center vector (#inputs) x (#hidden)
%      agent.sigma : scale factor
%      agent.wo    : weights for output layer  (#hidden + 1)x(#outputs)
global agent


h = exp(- sum((x' * ones(1,size(agent.wh,2)) - agent.wh).^2) * agent.sigma);  
out = [h 1] * agent.wo;
  
if nargout == 0
  agent.x = x;
  agent.h = h;
  agent.p = out;
end
  



