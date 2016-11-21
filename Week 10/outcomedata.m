% outcomedata.m
% J. Lucas McKay, Ph.D., M.S.C.R.
% 2016 11 03

clear all
close all

% read data into a table. this works great.
outcomedata = readtable('PDBalance_DATA_2016-11-03_0058.csv')

% it is often useful to note when the table was read into Matlab. if this
% was SAS or SPSS this data would be incorporated as metadata - Matlab
% offers a way to do this if you'd like
outcomedata.Properties.UserData.DateTime = datetime;

% a lot of exclusions, dates, etc. have been scrubbed from this data.
% therefore, cobble to gether a "visit number" from the participant code.

% participant codes with 'PRE', 'POST', and 'FLUP' are timepoints 1,2,3,
% respectively.
outcomedata.timepoint = ...
	1*contains(outcomedata.participant,'PRE') + ...
	2*contains(outcomedata.participant,'POST') + ...
	3*contains(outcomedata.participant,'FLUP');

% note that there are some odd ducks in here flagged as assess_group = nan
% or assess_group = 5; these can be excluded later. we will be interested
% in those in asses_group 1 or 2.

% look at all of the participants
outcomedata(:,{'participant' 'timepoint' 'assess_group'})

% isolate only the participants in groups 1 and 2
outcomedata(ismember(outcomedata.assess_group,[1 2]),{'participant' 'timepoint' 'assess_group'})

% create a unique participant identifier out of characters 1-6 of the
% participant code strings
tempstr = strvcat(outcomedata.participant);

% create a unique categorical code for each participant.
outcomedata.uniqueid = categorical(cellstr(tempstr(:,1:6)));

% look at the participants to include
outcomedata(ismember(outcomedata.assess_group,[1 2]),{'uniqueid' 'timepoint' 'assess_group'})

% summarize the scores of the fullerton advanced balance scale, a
% behavioral balance test. each item is named 'fab01', 'fab02', etc., with
% no trailing characters.
fabitems = {
	'fab01'
	'fab02'
	'fab03'
	'fab04'
	'fab05'
	'fab06'
	'fab07'
	'fab08'
	'fab09'
	'fab10'
	}

% examine the fab items for just the included participants
outcomedata(ismember(outcomedata.assess_group,[1 2]),[{'uniqueid'} fabitems'])

% total the fab items. what does the "2" do here:
sum(outcomedata{:,fabitems})

sum(outcomedata{:,fabitems},1)

sum(outcomedata{:,fabitems},2)

outcomedata.fab = sum(outcomedata{:,fabitems},2);




% create a new, sorted table with only the participants who will be included in the analysis.
outcomedata2 = sortrows(outcomedata(ismember(outcomedata.assess_group,[1 2]),:),{'uniqueid' 'timepoint'});

% sort the table and display the varibles of interest
varlist = {'uniqueid' 'assess_group' 'timepoint' 'fab'};
outcomedata2(:,varlist)

% note that there is an error in the table - in a few cases the data
% entry students have coded posttest and follow-up visits as assess_group 2
% when they are actually group 1. (this was confirmed with the ph.d.
% student managing the data entry students)

% correct this by recoding all timepoints for participants in assess_group
% 1 at timepoint 1 to assess_group 1.
g1 = outcomedata2.uniqueid(outcomedata2.assess_group==1 & outcomedata2.timepoint==1);
g2 = outcomedata2.uniqueid(outcomedata2.assess_group==2 & outcomedata2.timepoint==1);
outcomedata2.assess_group(ismember(outcomedata2.uniqueid,g1)) = 1;
outcomedata2.assess_group(ismember(outcomedata2.uniqueid,g2)) = 2;
clear g1 g2


% matlab can summarize frequency data for the table using the "varfun"
% syntax. how many timepoints do we have for each participant?
existobs = @(in) ismember([1 2 3],in).*[1 2 3]
obssummary = varfun(existobs, outcomedata2(:,{'uniqueid' 'timepoint'}), 'GroupingVariables','uniqueid');
obssummary.Properties.VariableNames{end} = 'ExistingTimepoints'

% summarize the existing patterns of data. in SAS, you would do this with
% "PROC FREQ."
[ExistingTimepoints, ~, patternnum] = unique(obssummary.ExistingTimepoints,'rows','sorted');
Frequency = histc(patternnum,1:max(patternnum));
flipud(table(ExistingTimepoints,Frequency))




% due to the missing timepoints, some imputation may be useful for
% visualization. therefore, create a new data table with three timepoints
% per participant.

% identify unique participants
u = unique(outcomedata2.uniqueid);

% create a duplicate table with empty records for missing timepoints.
vec = @(in) in(:);
uniqueid = u(vec(repmat(1:length(u),3,1)));
timepoint = repmat([1 2 3]',length(u),1);
fab = nan(size(timepoint));
assess_group = nan(size(timepoint));
outcomedata_locf = table(uniqueid,assess_group,timepoint,fab);
clear uniqueid assess_group timepoint fab

% copy fields as necessary
for i = 1:length(u)
	outcomedata_locf{outcomedata_locf.uniqueid==u(i),'assess_group'} = outcomedata2{outcomedata2.uniqueid==u(i)&outcomedata2.timepoint==1,'assess_group'}*ones(3,1);
end

% it would be nice if you could index as
% outcomedata_locf(uniqueid=='BAT001'&timepoint==3,fab), but that is not
% yet implemented (I think it may be soon)
for i = 1:height(outcomedata_locf)
	try
		outcomedata_locf.fab(i) = outcomedata2.fab((outcomedata2.uniqueid == outcomedata_locf.uniqueid(i)) & (outcomedata2.timepoint == outcomedata_locf.timepoint(i)));		
	catch
	end
end

% note that the most frequent value is 29 (an ok score) and that there are
% 25 missing values.
[FABValues, ~, patternnum] = unique(outcomedata_locf.fab(~isnan(outcomedata_locf.fab)),'rows','sorted');
Frequency = histc(patternnum,1:max(patternnum));
FABValues = [FABValues; nan];
Frequency = [Frequency; sum(isnan(outcomedata_locf.fab))];
flipud(table(FABValues,Frequency))


% create a score with observations carried forward.
outcomedata_locf.fab_locf = outcomedata_locf.fab

m2 = outcomedata_locf.uniqueid(isnan(outcomedata_locf.fab_locf)&outcomedata_locf.timepoint==2)
m3 = outcomedata_locf.uniqueid(isnan(outcomedata_locf.fab_locf)&outcomedata_locf.timepoint==3)

outcomedata_locf.fab_locf(ismember(outcomedata_locf.uniqueid,m2)&outcomedata_locf.timepoint==2) = ...
	outcomedata_locf.fab_locf(ismember(outcomedata_locf.uniqueid,m2)&outcomedata_locf.timepoint==1);

outcomedata_locf.fab_locf(ismember(outcomedata_locf.uniqueid,m3)&outcomedata_locf.timepoint==3) = ...
	outcomedata_locf.fab_locf(ismember(outcomedata_locf.uniqueid,m3)&outcomedata_locf.timepoint==2);



% plot the outcomes for those participants with complete data. in a
% statistical analysis, you can consider the other participants - but for
% visualization it can be misleading.
h = figure;
h.PaperSize = [11 17];
h.PaperOrientation = 'landscape';
h.Position = [400 800 800 400]
set(h,'DefaultAxesFontSize',8);
set(h,'DefaultTextFontSize',8);
h.ToolBar = 'none';
h.MenuBar = 'none';

ax.group1raw = subplot(1,4,1);
ax.group1change = subplot(1,4,2);
ax.group2raw = subplot(1,4,3);
ax.group2change = subplot(1,4,4);

% ensure that subsequent plots will add to the figures
ax.group1raw.NextPlot = 'add';
ax.group2raw.NextPlot = 'add';
ax.group1change.NextPlot = 'add';
ax.group2change.NextPlot = 'add';

% set axis limits, etc.
yl.raw = [0 40];
yl.change = [-20 20];

ax.group1raw.YLim = yl.raw;
ax.group2raw.YLim = yl.raw;

ax.group1change.YLim = yl.change;
ax.group2change.YLim = yl.change;

ax.group1raw.Title.String = {'FAB Scores';'Group 1'};
ax.group2raw.Title.String = {'FAB Scores';'Group 2'};
ax.group1change.Title.String = {'FAB Change Scores';'Group 1'};
ax.group2change.Title.String = {'FAB Change Scores';'Group 2'};

% note syntax to loop over a row
u'
for participant = u'
	participantscores = outcomedata_locf(outcomedata_locf.uniqueid==participant,{'uniqueid' 'assess_group' 'timepoint' 'fab' 'fab_locf'});
	
	% calculate change wrt baseline
	participantscores.fab_change = participantscores.fab - participantscores.fab(1);
	participantscores.fab_locf_change = participantscores.fab_locf - participantscores.fab_locf(1);
		
	switch participantscores.assess_group(1)
		case 1
			destax = [ax.group1raw ax.group1change];
		case 2
			destax = [ax.group2raw ax.group2change];
	end
	
	axes(destax(1))
	p = plot(participantscores.timepoint,participantscores.fab);
	p.UserData.Tag = char(participant);
	p.UserData.SrcData = participantscores.fab;
	p.UserData.LOCFData = participantscores.fab_locf;

	% enable toggle of LOCF
	p.UserData.LOCF = false;
	p.ButtonDownFcn = @switchLOCF;
	
	axes(destax(2))
	p = plot(participantscores.timepoint,participantscores.fab_change);
	p.UserData.Tag = char(participant);
	p.UserData.SrcData = participantscores.fab_change;
	p.UserData.LOCFData = participantscores.fab_locf_change;

	% enable display of Tag
	p.UserData.DisplayTag = false;
	p.ButtonDownFcn = @displayTag;
	
end

% hard to see axes - add jitter

% jitter all of the plot elements a bit in the vertical direction so they
% do not overlap
vertJitter([...
	ax.group1raw.Children;
	ax.group1change.Children;
	ax.group2raw.Children;
	ax.group2change.Children]...
	,0.6);

% bring figure to front
figure(h)


% summarize raw scores across groups and timepoints. this includes all of
% the existing data.
summary = @(in) [sum(~isnan(in(:))) nanmean(in(:)) nanstd(in(:))];
t = varfun(summary,outcomedata_locf,'InputVariables','fab','GroupingVariables',{'assess_group','timepoint'});
t.Properties.VariableNames{end} = 'FAB_N_Mean_SD';
t.Properties.RowNames = {...
	'Group_1_Pre'
	'Group_1_Post'
	'Group_1_Follow-up'
	'Group_2_Pre'
	'Group_2_Post'
	'Group_2_Follow-up'}


h = figure;
h.PaperSize = [11 17];
h.PaperOrientation = 'landscape';
h.Position = [400 800 800 400]
set(h,'DefaultAxesFontSize',8);
set(h,'DefaultTextFontSize',8);
h.ToolBar = 'none';
h.MenuBar = 'none';

ax = gca;
XS = 0.05;
ax.NextPlot = 'add';
p = plot((1:3)-XS,t.FAB_N_Mean_SD(1:3,2));
p.Tag = 'Group 1 Mean';
p = plot((1:3)+XS,t.FAB_N_Mean_SD(4:6,2));
p.Tag = 'Group 2 Mean';

for i = 1:3
	p = plot((i-XS)*[1 1],t.FAB_N_Mean_SD(i,2)+t.FAB_N_Mean_SD(i,3)*[-1 1]);
	p.Tag = 'Group 1 SD';
	p = plot((i+XS)*[1 1],t.FAB_N_Mean_SD(i+3,2)+t.FAB_N_Mean_SD(i+3,3)*[-1 1]);
	p.Tag = 'Group 2 SD';
end

lines = ax.Children;
lineTags = {lines.Tag}';

g1 = contains(lineTags,'1')
g2 = contains(lineTags,'2')
m = contains(lineTags,'Mean')
s = contains(lineTags,'SD')

for l = lines(g1)'
l.Color = 'k';
l.LineWidth = 2;
end

for l = lines(g2)'
l.Color = 0.5*[1 1 1];
l.LineWidth = 2;
end

ax.XLim = [0.5 3.5];
ax.XTick = [1:3];
ax.XTickLabel = {'Pretest' 'Posttest' 'Follow-up'};

ax.YLim = [0 40]
ax.YLabel.String = 'Fullerton Advanced Balance Scale';

figure(h)

% there is obviously some imbalance at pretest - this is unfortunate and
% should be dealt with in the analysis phase if possible by allowing each
% participant to have a unique intercept in the overall model.

% because that's beyond what we'd like to do today, let's just note that
% the baseline groups differed. isolate the fab scores for each group:

g1fab = outcomedata_locf.fab(outcomedata_locf.timepoint==1&outcomedata_locf.assess_group==1);
g2fab = outcomedata_locf.fab(outcomedata_locf.timepoint==1&outcomedata_locf.assess_group==2);

% there may be a missing value - get rid of it
g1fab = g1fab(~isnan(g1fab));
g2fab = g2fab(~isnan(g2fab));

fab = {g1fab'; g2fab'};
n = cellfun(@numel,fab);
edges = 0:40;
counts = cellfun(@(in) histcounts(in,edges),fab,'UniformOutput',false);
sample_mean = cellfun(@mean,fab);
sample_sd = cellfun(@std,fab);

% group the summary statistics into a table
baseline = table(fab,n,counts,sample_mean,sample_sd,'RowNames',{'Group1';'Group2'});

% calculate standard error of the mean
baseline.sample_sem = baseline.sample_sd./baseline.n

% calculate the test statistic under the null hypothesis that the groups
% are equal
df = sum(baseline.n)-height(baseline);
diff_means = diff(baseline.sample_mean);
pooled_sd = sqrt((baseline.sample_sd').^2 * (baseline.n-1)  / df );
pooled_sem = pooled_sd * sqrt(sum(1./baseline.n)); 
T = diff_means / pooled_sem;
p = 2*tcdf(T,df);

% compare with canned method
[h,p,ci,stats] = ttest2(g1fab,g2fab);

table(diff_means,df,pooled_sd,T,p)
p
stats











