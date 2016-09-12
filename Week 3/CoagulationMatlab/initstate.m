function initstate()
global env
flg=1;
while flg
    env.state = Patient_1(10*rand());
    if env.state(1)<60 || env.state(1)>100, flg=0;end
end


