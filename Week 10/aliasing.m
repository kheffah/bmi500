% aliasing.m
% J. Lucas McKay, Ph.D., M.S.C.R.
% 2016 10 12

clear all
close all

% flag to print rendered images to file
printflag = false;

% flag to play sounds of original and aliased waveforms
soundflag = false;

% demostrate an aliased waveform
sinusoid = @(x,f,phi) cos(2*pi*f*x-phi);

figure(1)
hold on
x_orig = 0:(1/100):10;
x_resamp = 0:1.5:10;

handles.original = plot(x_orig,sinusoid(x_orig,1,0));
handles.original.LineWidth = 2;

% note that the "eval" syntax lets you run strings as literal commands,
% useful but potentially dangerous. these commands work on OS X - if you
% are running other OS compatibility issues will ensue.
if printflag, eval(['print -depsc2 -tiff -r300 -f1 original.eps']), end

handles.samples = plot(x_resamp,sinusoid(x_resamp,1,0));
handles.samples.Marker = 'o';
handles.samples.MarkerSize = 16;
handles.samples.LineStyle = 'none';

if printflag, eval(['print -depsc2 -tiff -r300 -f1 sampled.eps']), end

handles.alias = plot(x_orig,sinusoid(x_orig,1/3,0));
handles.alias.LineWidth = 2;

if printflag, eval(['print -depsc2 -tiff -r300 -f1 aliased.eps']), end

% the ! character escapes to the system environment. on os x, this gives
% you a fresh shell. on os x, the command "open" sends whatever file
% you'd like to the default application.
if printflag
	!ls
	!which git
	!open aliased.eps
end

% create a source signal that we will resample inappropriately (and
% inappropriately) to create (and avoid) aliasing.

% create a signal over the range 0 to 5 seconds.
trange_s = [0 5];

% create a signal varying from 0 to 2000 Hz.
frange_hz = [1 2000];

% sample the signal at 5000 Hz.
fs_hz = 5000;

% create a time vector.
time_s = trange_s(1):(1/fs_hz):(trange_s(2)-(1/fs_hz));

% create a "chirp" signal. note that we will cast this as a cell using {}
% so that we can alter the number of columns later.
chirpsig = {chirp(time_s,frange_hz(1),trange_s(2),frange_hz(2),'logarithmic')};

% we will create several versions of the signal, so instantiate a matlab
% "table" object. this is a really useful data structure with flexible
% indexing methods and that can contain arbitrary data types (vectors,
% matrices, cell, categorical, etc.
signaltable = repmat(table(fs_hz,chirpsig),5,1);

% the table object can be indexed with text flags or numerical indices in
% both variables and rows.
signaltable.Properties.RowNames = {'original','dumb upsampled','smart upsampled','dumb downsampled','smart downsampled'}

% the second two rows will be upsampled 2x, and the last two rows will be
% downsampled 10x. you can alter that with one statement.
signaltable.fs_hz = signaltable.fs_hz.*[1 2 2 0.2 0.2]'

% "dumb upsample" row 2.

% note that using parentheses returns a table
signaltable(2,'chirpsig')

% note that using curly brackets returns the data itself as a double -
% request only the first 50. I encourage you to interact with the cell
% syntax some.
signaltable{2,'chirpsig'}{1}(1:50)

% one of the advantages of casting as cell is that we can create entries
% that are non-conformable.
signaltable{2,'chirpsig'}{1} = 3

% replace the vector of values with one that has each entry repeated once.
signaltable{2,'chirpsig'}{1} = nan(1,2*length(signaltable{1,'chirpsig'}{1}));
signaltable{2,'chirpsig'}{1}(1:2:end) = signaltable{1,'chirpsig'}{1};
signaltable{2,'chirpsig'}{1}(2:2:end) = signaltable{1,'chirpsig'}{1}

% plot the original and dumb-upsampled.
figure(2)
subplot(5,1,1)
plot(signaltable.chirpsig{1})
subplot(5,1,2)
plot(signaltable.chirpsig{2})

% do they look ok? zoom in.

% properly upsample row 3. one way to do this is through interpolation with
% zeroes, low-pass antialias filtering, and then simple sampling.
signaltable{3,'chirpsig'}{1} = resample(signaltable{1,'chirpsig'}{1},2,1)

% plot.
figure(2)
subplot(5,1,3)
plot(signaltable.chirpsig{3})

% do they look ok? zoom in.

% dumb downsample row 4. 
signaltable{4,'chirpsig'}{1} = signaltable{1,'chirpsig'}{1}(1:5:end)

% smart downsample row 5. 
signaltable{5,'chirpsig'}{1} = resample(signaltable{1,'chirpsig'}{1},1,5)

% plot.
figure(2)
subplot(5,1,4)
plot(signaltable.chirpsig{4})
subplot(5,1,5)
plot(signaltable.chirpsig{5})

% what is going on here? one way to get some insight into this is to listen
% to these signals.

for i = 1:5	
	sound(signaltable.chirpsig{i},signaltable.fs_hz(i))
	pause(3)
	figure
end


