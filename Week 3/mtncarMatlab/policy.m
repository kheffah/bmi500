function act = policy(p)

%epsilon-greedy policy: action values -> next action

global agent

[~,action] = max(p);
if rand < agent.epsilon
  action = ceil(rand*3);
end
act = action;
%acts = [acts action];
  
