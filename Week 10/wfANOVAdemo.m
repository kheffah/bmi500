function [] = wfANOVAdemo()
% wfANOVAdemo.m
% 
% sample code that recreates the primary analysis figure of 
% "Statistically-significant contrasts between EMG waveforms revealed using wavelet-based functional ANOVA"
% McKay, Welch, Vidakovic, and Ting
% in review, Journal of Neurophysiology
% 
% usage: type "wfANOVAdemo"
% 
% modifications or playing around with the statistics or wavelet transform
% (in the "wfANOVA" subfunction) should not generally affect the plotting
% of contrasts, but may affect the big plot that gets generated - so both
% are provided.
% 
% please contact me (j.lucas.mckay@emory.edu) if you have any questions or
% difficulties running the code!
% 
% J. Lucas McKay, 19 August 2012

% load data for tibialis anterior
load wfANOVAdata
data = TA;
factors = [V A S];

% the data are as follows:
%  Tibialis anterior EMG, replicates x time samples:
%   TA        439x512            1798144  double
%  Time vector:
%   time        1x512               4096  double  
%  Factor vectors, coding for peak velocity, peak acceleration, and
%  subject:
%   V         439x1                 3512  double              
%   A         439x1                 3512  double              
%   S         439x1                 3512  double              
  
% perform post-hoc tests on factors V and A:
performposthoc = [1 1 0];

% calculate contrasts using wavelet-based functional ANOVA.
[vcontrasts,acontrasts] = wfANOVA(data,factors,performposthoc);

% plot contrasts for velocity factors (compare traces to red traces in main
% figure in paper)
plotcontrasts(vcontrasts,time)

% plot contrasts for acceleration factors (compare traces to red traces in main
% figure in paper)
plotcontrasts(acontrasts,time)

% plot a large figure to match the primary analysis figure in the paper.
plotbigfigure(data,time,factors,vcontrasts,acontrasts)

end

function varargout = wfANOVA(data,factors,performposthoc)

% wavelet transform the data
[wavedata, waveparams] = wavelettransform(data);

% to test for perfect reconstruction, you can use the following:
% recondata = inversewavelettransform(wavedata,waveparams);
alpha = 0.05;
display = 'off'; % display ANOVA tables? on/off
% Set up number of tests and length of records.
[ntrls,npnts] = size(data);
% change the grouping variable to a cell array.
group = {};
for j = 1:size(factors,2)
    group{1,j} = factors(:,j);
end
% perform pointwise ANOVA
t_p = [];
stats = {};
han = waitbar(0,'performing pointwise ANOVA','toolbar','none');
for j = 1:npnts
    [t_p(:,j),~,stats{j}] = anovan(wavedata(:,j),group,'display',display,'alpha',alpha);
    waitbar(j/npnts,han);
end
close(han)
contrasts = {};
for j = 1:length(performposthoc)
    % perform post-hoc tests for each flagged factor.
    if performposthoc(j)
        tempwavecontrast = posthocsub(t_p(j,:),alpha,stats,j);
        temptimecontrast = inversewavelettransform(tempwavecontrast,waveparams);
        contrasts{j} = temptimecontrast;
    end
end
varargout = contrasts(logical(performposthoc));
end

function contrasts = posthocsub(pvals,alpha,stats,dim)
% type of critical value used for post hoc tests
ctype = 'scheffe';
% don't display detailed results
display = 'off';
% calculate p-values for post-hoc tests
posthocalpha = alpha/sum(pvals<alpha);
% figure out the maximum levels for post-hoc tests from the stats
% structure
maxcontrast = stats{1}.nlevels(dim)-1;
% assemble the contrast structure
contrasts = zeros(maxcontrast,length(pvals));
% loop through and do the comparison
for j = 1:length(stats)
    if pvals(j)<alpha
        clear temp
        [temp.contrasts, temp.means] = multcompare(stats{j},'dimension',dim,'display',display,'ctype',ctype,'alpha',posthocalpha);
        for k = 1:maxcontrast
            if (sign(temp.contrasts(k,3)) == sign(temp.contrasts(k,5)))
                % Include the contrast in the contrast waveform. Note the
                % negative sign is because Matlab outputs level 1 - level
                % 2, and we want level 2 - level 1.
                contrasts(k,j) = -temp.contrasts(k,4);
            end
        end
    end
end
end

function [wavedata, waveparams] = wavelettransform(data)
% Get the length of the data records
[ntrls,npnts] = size(data);
% Wavelet to use: 3-rd order Coiflet.
wavestr = 'coif3';
% Extension mode: periodic, so that what is returned is the same length as
% the data.
wavemode = 'per';
dwtmode(wavemode);
% Find the maximum possible level of the wavelet decomposition:
lev = wmaxlev([1 npnts],wavestr);
% Loop through and transform
wavedata = zeros(size(data));
for i = 1:ntrls
    x = data(i,:);
    [wx,wL] = wavedec(x,lev,wavestr);
    wavedata(i,:) = wx;
end
waveparams.wL = wL;
waveparams.wavestr = wavestr;
waveparams.wavemode = wavemode;
end

function data = inversewavelettransform(wavedata,waveparams)
dwtmode(waveparams.wavemode);
% Get the length of the data records
[ntrls,npnts] = size(wavedata);
data = zeros(size(wavedata));
for i = 1:ntrls
    data(i,:) = waverec(wavedata(i,:),waveparams.wL,waveparams.wavestr);
end
end

function h = plotcontrasts(contrasts,time)
maxcontrast = size(contrasts,1);
figure
for j = 1:maxcontrast
    subplot(maxcontrast,1,maxcontrast-(j-1))
    plot(time,contrasts(j,:))
    hold on
    title(['contrast ' num2str(j)])
    xlabel('time (s)')
    xlim([0 1])
    plotibr()
end
end

function [] = plotibr()
% plot vertical lines for initial burst and plateau region windows
yl = get(gca,'ylim');
ylim('manual');
ylim(yl);
hold on
l = line(0.1*[1 1],yl,'clipping','off');
set(l,'color','k');
l = line(0.25*[1 1],yl,'clipping','off');
set(l,'color','k');
l = line(0.4*[1 1],yl,'clipping','off');
set(l,'color','k');
t = text(mean([0.1 0.25]),yl(2),'IB');
set(t,'horizontalalignment','center','verticalalignment','top')
t = text(mean([0.25 0.4]),yl(2),'PR');
set(t,'horizontalalignment','center','verticalalignment','top')
end

function h = plotbigfigure(data,time,factors,vcontrasts,acontrasts)

% plot the original data:
nrows = 5;
ncols = 4;

figure
set(gcf,'color',[1 1 1])

xl = [0 1];
yl = [-0.5 0.5];

% plot acceleration contrasts
subplot(nrows,ncols,3)
hold on
p = plot(time,acontrasts(1,:),'r');
xlim(xl)
ylim(yl)
plotibr
title('contrast A1')

subplot(nrows,ncols,4)
hold on
p = plot(time,acontrasts(2,:),'r');
xlim(xl)
ylim(yl)
plotibr
title('contrast A2')

% plot velocity contrasts
subplot(nrows,ncols,13)
hold on
p = plot(time,vcontrasts(1,:),'r');
xlim(xl)
ylim(yl)
plotibr
title('contrast V1')

subplot(nrows,ncols,9)
hold on
p = plot(time,vcontrasts(2,:),'r');
xlim(xl)
ylim(yl)
plotibr
title('contrast V2')

subplot(nrows,ncols,5)
hold on
p = plot(time,vcontrasts(3,:),'r');
xlim(xl)
ylim(yl)
plotibr
title('contrast V3')

% plot original data.
V = factors(:,1);
A = factors(:,2);
alevs = unique(A);
vlevs = unique(V);

subplot(nrows,ncols,6)
plotrawdata(time,data((V==4)&(A==2),:));
title(['40 cm/s; 0.2 g'])

subplot(nrows,ncols,10)
plotrawdata(time,data((V==3)&(A==2),:));
title(['35 cm/s; 0.2 g'])

subplot(nrows,ncols,14)
plotrawdata(time,data((V==2)&(A==2),:));
title(['30 cm/s; 0.2 g'])

subplot(nrows,ncols,18)
plotrawdata(time,data((V==1)&(A==2),:));
title(['25 cm/s; 0.2 g'])

subplot(nrows,ncols,7)
plotrawdata(time,data((V==4)&(A==3),:));
title(['40 cm/s; 0.3 g'])

subplot(nrows,ncols,11)
plotrawdata(time,data((V==3)&(A==3),:));
title(['35 cm/s; 0.3 g'])

subplot(nrows,ncols,15)
plotrawdata(time,data((V==2)&(A==3),:));
title(['30 cm/s; 0.3 g'])

subplot(nrows,ncols,19)
plotrawdata(time,data((V==1)&(A==3),:));
title(['25 cm/s; 0.3 g'])

subplot(nrows,ncols,8)
plotrawdata(time,data((V==4)&(A==4),:));
title(['40 cm/s; 0.4 g'])

subplot(nrows,ncols,12)
plotrawdata(time,data((V==3)&(A==4),:));
title(['35 cm/s; 0.4 g'])

subplot(nrows,ncols,16)
plotrawdata(time,data((V==2)&(A==4),:));
title(['30 cm/s; 0.4 g'])

subplot(nrows,ncols,20)
plotrawdata(time,data((V==1)&(A==4),:));
title(['25 cm/s; 0.4 g'])

end

function [] = plotrawdata(time,data)
xl = [0 1];
yl = [0 1];

hold on
p = plot(time,data,'color',0.75*[1 1 1]);
p = plot(time,nanmean(data,1),'color',0*[1 1 1]);
xlim(xl)
ylim(yl)
plotibr

end
