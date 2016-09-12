function updateelig()
global agent

% Set all but action output to zero, so their traces aren't updated.
outderivs = zeros(1,agent.no);
%outderivs(action) = p(action) * (1-p(action));  %for sigmoid
outderivs(agent.action) = 1.;  

outdw = outderivs .* agent.wo(1:agent.no);
  
agent.ewo = agent.lambda * agent.ewo + [agent.h 1]' * outderivs;  %lambda et-1 x dOutput/dwo   Q(a) = [h 1] * agent.wo;

if agent.hrate ~= 0
  for ou = 1:agent.no
    row = (ou-1)*(agent.ni)+1; %row = (ou-1)*(numInputs+1)+1;
    agent.ewh(row:row+agent.ni-1,:) = agent.lambda * agent.ewh(row:row+agent.ni-1,:) + ...
        agent.x' * (agent.h .* (1-agent.h)) * outdw(ou); 
    %newewh(row:row+numInputs,:) = lambda * ewh(row:row+numInputs,:) ... 
	%+ [x 1]' * (h .* (1-h)) * outdw(ou);
  end
end



%for hu = 1:numHidden
%  for ou = 1:numOutputs
%    ewo(hu,ou) = lambda * ewo(hu,ou) + outderivs(ou) * h(hu);
%    for iu = 1:numInputs
%      row = ou*(numInputs+1) + iu;
%      ewh(row,hu) = lambda * ewh(row,hu) + ...
%       outderivs(ou) * wo(hu,ou) * h(hu) * (1-h(hu)) * x(iu);
%    end
%    ewh(row+1,hu) = lambda * ewh(row+1,hu) + ...
%outderivs(ou) * wo(hu,ou) * h(hu) * (1-h(hu));
%  end 
%  ewo(numHidden+1,ou) = lambda * ewo(numHidden+1,ou) + outderivs(ou);
%  ewh(row,hu) = lambda * ewh(row,hu) + ...
%    outderivs(ou) * wo(hu,ou) * h(hu) * (1-h(hu)) * x(iu);


