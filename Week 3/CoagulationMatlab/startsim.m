function startsim()

global env agent sim

sim.running = 1;

while sim.running
    
    sim.trial = sim.trial + 1;
    initagenttrial;
    sim.step = 0;
    env.r = -1;
    
    initstate;
    
    while (env.r <= 0) && sim.running,
        sim.step = sim.step + 1;
        if sim.step == 1
      %% Q1. what is the "state" in the Heparin Dosing example?
      %% Q2. What is the Neural Network doing in this script?
            calcoutput(env.state); % call the neural network to get the value of each action given current state
      %% Q3. What is the policy?
            agent.action = policy(agent.p); % epsilon-greedy policy: action values -> next action
        end
        %% You can ignore this
        updateelig; % update eligibility traces
        
        %%  Q4. What does the environment represent?
        %%  Q5. What are the actions based on this script?
        env.state = nextstate(agent.action,env.indx_patient);
        
        if env.display,
            h = findobj('Tag','car');
            showenv(h);
        end
        %% Q6. How is the reward defined in this example? 
        env.r = tansig(0.06*(env.state(1)-70)) - tansig(0.06*(env.state(1)-90))-1 ;
        [env.state env.r]
        p = calcoutput(env.state);	% without saving hidden and output outputs in struct
        action = policy(p); %max_b Q(s_t+1,b)
        error = env.r + agent.gamma * p(action) - agent.p(agent.action); % r_t+1 + gamma * max_b Q(s_t+1,b) - Q(s_t,a_t)
        
        errorVector = zeros(1,agent.no);
        errorVector(agent.action) = error;
        
        %% Q7. How are the weights getting updated?
        updateweights(errorVector);
        
        calcoutput(env.state);
        agent.action = action;  %sarsa.  Use action already chosen for this state
        
        drawnow;				% to handle all gui events
        
    end					% end of one trial
    
    %% Q8. How would you improve:
     %  a) State definition?
     %  b) Action definition?
     %  c) Optimization?
    
    
    if sim.running,
        
        sim.perf(sim.trial) = sim.step;
        
        if agent.displaysurf && rem(sim.trial,agent.displaysurfrate) == 0,
            a = findobj('Tag','agentsurfaxis');
            axes(a);
            plotQ(20);
            set(a,'Tag','agentsurfaxis');
        end
        
        if agent.displayrbfs && rem(sim.trial,agent.displayrbfsrate) == 0,
            a = findobj('Tag','agentrbfsaxis');
            axes(a);
            plotrbfs;
            set(a,'Tag','agentrbfsaxis');
        end
        
        if sim.display && rem(sim.trial,sim.displayrate) == 0,
            a = findobj('Tag','simperfaxis');
            axes(a);
            showperf;
            %      set(a,'Tag','simperfaxis');
        end
        
        drawnow;
        
    end
    
end

