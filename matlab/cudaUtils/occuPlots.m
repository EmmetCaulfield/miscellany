% Wise to clear all or globals get fubared in Octave:
clear all

% Close all graphs:
close all

% These are ubiquitous:
global smVer;
global yTick;
global yAxis;

% Nominal parameters:
smVer =   20; % SM version/compute capability

tpb   =  192; % Number of threads per block
rpt   =   63; % Number of registers per thread
smpb  = 3500; % Bytes of shared memory per block


% Extents and ticks for y-axis:
yTick = 0:8:64;
yAxis = [min(yTick) max(yTick)];

% Plot parameters for a quantity we want to vary:
function [obj]=params(nom, range, xTick, label),
   global yAxis;
   obj.nom   = nom;	% Nominal value
   obj.range = range;   % Range of values
   obj.xTick = xTick;   % X-axis ticks
   obj.axis  = [0 max(range) yAxis];
   obj.label = label;   % X-axis label
end

% Commpute & plot a quantity we want to vary:
function varyPlot(all, number),
    global smVer;
    global yTick;

    param=all(number);
    switch(number)
        case 1
	  [pc atwb]=occuCalc(smVer, all(1).range,   all(2).nom,   all(3).nom);
	case 2
	  [pc atwb]=occuCalc(smVer,   all(1).nom, all(2).range,   all(3).nom);
	case 3
	  [pc atwb]=occuCalc(smVer,   all(1).nom,   all(2).nom, all(3).range);
    end

    figure()
    plot(param.range, atwb(2,:), 'o-');
    hold on; grid on;
    here=find(param.range>=param.nom);
    plot(param.nom, atwb(2,here(1)), 'r^'
	 , 'markerfacecolor', 'red'
	 , 'markersize', 10);
    xlabel(param.label);
    ylabel('Multiprocessor Warp Occupancy');
    set(gca, 'XTick', param.xTick);
    set(gca, 'YTick', yTick);
    axis(param.axis);
end

% Plot parameters for varying threads-per-block:
all(1) = params( tpb,  32:32:1024,    0:64:1024, 'Threads per Block'    );

% Plot parameters for varying registers-per-thread:
all(2) = params( rpt,        1:80,       0:8:80, 'Registers per Thread' );

% Plot parameters for varying shared memory-per-block:
all(3) = params(smpb, 0:128:49152, 0:4096:49152, 'Shared Mem per Block' );


% See tables:
occuCalc(smVer, tpb, rpt, smpb)


% Plot graphs:
for i=1:3,
    varyPlot(all, i);
end
