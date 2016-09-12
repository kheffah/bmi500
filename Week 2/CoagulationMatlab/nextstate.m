function newstate = nextstate(action,indx_patient)
global env

% Simulates the environment: (s_t,a_t) -> s_t+1

aPTT = env.state(1);
heparin_infusion = env.state(2);


new_heparin_infusion = heparin_infusion +  (action-2) * 1;

if new_heparin_infusion < 0
  new_heparin_infusion = 0;
elseif new_heparin_infusion>10
    new_heparin_infusion=10;
end

if      indx_patient==1, newstate = Patient_1(...); % fill in the blank
elseif  indx_patient==2, newstate = Patient_2(...); % fill in the blank
elseif  indx_patient==3, newstate = Patient_3(...); % fill in the blank
else warning('unknown patient ...'), newstate=[NaN NaN];
end


  
