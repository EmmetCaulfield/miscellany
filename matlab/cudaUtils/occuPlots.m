% Close all graphs:
close all

% Nominal parameters:
SMver =   20; % SM version/compute capability
nTpB  =  192; % Number of threads per block
nRpT  =   63; % Number of registers per thread
bSMpB = 3500; % Bytes of shared memory per block

% See tables:
occuCalc(SMver, nTpB, nRpT, bSMpB)

% Extents and ticks for y-axis:
yTick=[8 16 24 32 40 48 56 64];
yAxis =[0 64];

% Threads-per-block range:
tpb=32:32:1024;
tpbTick=0:64:1024;
tpbAxis=[0 1024 yAxis];

% Registers-per-block range:
rpt=1:1:80;
rptTick=0:8:80;
rptAxis=[0 80 yAxis];

% Shared memory-per-block range:
spb=0:128:49152;
spbTick=0:4096:49152;
spbAxis=[0 49152 yAxis];

disp('-- tpb ------------');
%size(tpb)
[pc atwb blks flgs]=occuCalc(SMver, tpb, nRpT, bSMpB);
figure(1)
plot(tpb, atwb(2,:), 'o-');
hold on; grid on;
here=find(tpb==nTpB);
plot(nTpB, atwb(2,here), 'r^', 'markerfacecolor', 'red', 'markersize', 10);
xlabel('Threads per Block');
ylabel('SM Warp Occupancy');
set(gca, 'XTick', tpbTick);
set(gca, 'YTick', yTick);
axis(tpbAxis);

disp('-- rpt ------------');
%size(rpt)
[pc atwb blks flgs]=occuCalc(SMver, nTpB, rpt, bSMpB);
figure(2)
plot(rpt, atwb(2,:), 'o-');
hold on; grid on;
here=find(rpt==nRpT);
plot(nRpT, atwb(2,here), 'r^', 'markerfacecolor', 'red', 'markersize', 10);
xlabel('Registers per Thread');
ylabel('SM Warp Occupancy');
set(gca, 'XTick', rptTick);
set(gca, 'YTick', yTick);
axis(rptAxis);


disp('-- spb ------------');
%size(spb)
[pc atwb blks flgs]=occuCalc(SMver, nTpB, nRpT, spb);
figure(3)
plot(spb, atwb(2,:), 'o-');
hold on; grid on;
here=find(spb>=bSMpB)(1);
plot(bSMpB, atwb(2,here), 'r^', 'markerfacecolor', 'red', 'markersize', 10);
xlabel('Shared Memory per Block');
ylabel('SM Warp Occupancy');
set(gca, 'XTick', spbTick);
set(gca, 'YTick', yTick);
axis(spbAxis);


%size(pc)
%size(atwb)
%size(blks)
%size(flgs)
