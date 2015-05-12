function [smOccupancy_ activeTWB_ limitBlocks_ limitFlags_]=occuCalc(SMVersion, MyThreadCount, MyRegCount, MySharedMemory)
% OCCUCALC  Calculates GPU occupancy like Nvidia CUDA Occupancy Calculator
%
% occuCalc(SMVersion, MyThreadCount, MyRegCount, MySharedMemory)
%
% With no output arguments, essentially reproduces the blue "3.) GPU
% Occupancy Data" table and the two yellow tables "Allocated
% Resources" and "Maximum Threads Per Multiprocessor".
%
% Only the default shared memory size configurations and warp 
% register allocation granularities are supported.
%
% The aim is to mirror Nvidia's spreadsheet closely, not do things
% the way I would normally choose.
%
% INPUTS:
%     SMVersion     : SM version compute capability (B6) without
%                         the dot
%     MyThreadCount : Threads per block (B10)
%     MyRegCount    : Registers per thread (B11)
%     MySharedMemory: Shared memory per block (B12) 
%
% OUTPUTS:
%
%     smOccupancy_ : Occupancy percentage (B20)
%     activeTWB_   : Active threads, warps, and blocks per
%                        multiprocessor (B17-B19)
%     limitBlocks_ : Block limits due to thread, register, and
%                         shared memory use (D38-D40, B44-B46).
%     limitFlags_  : Boolean indication of which in limitBlocks_
%                         were limiting factors (~D44-D46).
%
% This is a Matlab/Octave rendition of the CUDA GPU Occupancy
% Calculator (a Microsoft Excel Workbook), Version 5.1. For the
% benefit of the user/reader, variables here have the exact same
% names as in the NVidia spreadsheet (however one might feel about
% them; names that do not appear in the spreadsheet have an
% underscore at the end. Cell references to the "Calculator" sheet
% are given where possible.

% We don't allow SM/CC to be a vector:
%validateattributes(SMVersion, {'uint8'}, {'scalar'});

% All the others are non-negative integers
%validateattributes(MyThreadCount,  {'uint16'}, {'vector'}); 
%validateattributes(MyRegCount,     {'uint16'}, {'vector'});
%validateattributes(MySharedMemory, {'uint16'}, {'vector'});

% But we only allow one of these to be a vector
lengths_=[length(MyThreadCount) length(MyRegCount) length(MySharedMemory)];
if sum(lengths_~=1)>1,
   error('Only one input can be a vector');
end
justOnes_=ones(1, max(lengths_));

% Round x up to a multiple of n
function [y]=roundUp(x, n),
    y=n.*ceil(x./n);
end

% Round x down to a multiple of n
function [y]=roundDown(x, n),
    y=n.*floor(x./n);
end

% Chosen to avoid handling strings:
BLOCK=1;
WARP=2;

% From "GPU Data" sheet:
gpuData_ = [
  1.0,   1.1,   1.2,   1.3,   2.0,   2.1,   3.0,   3.5 ; %  1: Compute Capability
   10,    11,    12,    13,    20,    21,    30,    35 ; %  2: SM Version
   32,    32,    32,    32,    32,    32,    32,    32 ; %  3: Threads/Warp
   24,    24,    32,    32,    48,    48,    64,    64 ; %  4: Warps/Multiprocessor
  768,   768,  1024,  1024,  1536,  1536,  2048,  2048 ; %  5: Threads/Multiprocessor
    8,     8,     8,     8,     8,     8,    16,    16 ; %  6: Thread Blocks/Multiprocessor
16384, 16384, 16384, 16384, 49152, 49152, 49152, 49152 ; %  7: Max Shared Memory/Multiprocessor (bytes)
 8192,  8192, 16384, 16384, 32768, 32768, 65536, 65536 ; %  8: Register FileSize
  256,   256,   512,   512,    64,    64,   256,   256 ; %  9: Register Allocation Unit Size
BLOCK, BLOCK, BLOCK, BLOCK,  WARP,  WARP,  WARP,  WARP ; % 10: Allocation Granularity
  124,   124,   124,   124,    63,    63,    63,   255 ; % 11: Max Registers / Thread
  512,   512,   512,   512,   128,   128,   256,   256 ; % 12: Shared Memory Allocation Unit Size
    2,     2,     2,     2,     2,     2,     4,     4 ; % 13: Warp allocation granularity
  512,   512,   512,   512,  1024,  1024,  1024,  1024 ; % 14: Max Thread Block Size
%
16384, 16384, 16384, 16384, 49152, 49152, 49152, 49152 ; % Shared Memory Size Configurations (bytes)
% [note: default at top of list],,,,,,16384,16384,16384,16384
% ,,,,,,,,32768,32768
%
%0,0,0,0,64,64,256,256 % Warp register allocation granularities
%[note: default at top of list],"21,22,29,30,37,38,45,46,",,,,,128,128,,
];

switch(SMVersion)
    case 10
      gpuSpec_ = gpuData_(:,1);
    case 11
      gpuSpec_ = gpuData_(:,2);
    case 12
      gpuSpec_ = gpuData_(:,3);
    case 13
      gpuSpec_ = gpuData_(:,4);
    case 20
      gpuSpec_ = gpuData_(:,5);
    case 21
      gpuSpec_ = gpuData_(:,6);
    case 30
      gpuSpec_ = gpuData_(:,7);
    case 35
      gpuSpec_ = gpuData_(:,8);
end


% These are the variable names used in the spreadsheet:
limitThreadsPerWarp          = gpuSpec_( 3) * justOnes_;
limitWarpsPerMultiprocessor  = gpuSpec_( 4) * justOnes_;
limitTotalSharedMemory       = gpuSpec_( 7) * justOnes_;
limitBlocksPerMultiprocessor = gpuSpec_( 6) * justOnes_;
limitRegsPerThread           = gpuSpec_(11) * justOnes_;
limitTotalRegisters          = gpuSpec_( 8) * justOnes_;

myAllocationSize             = gpuSpec_( 9) * justOnes_;
myAllocationGranularity      = gpuSpec_(10) * justOnes_;
myWarpAllocationGranularity  = gpuSpec_(13) * justOnes_;
mySharedMemAllocationSize    = gpuSpec_(12) * justOnes_;

% B38
MyWarpsPerBlock = ceil(MyThreadCount./limitThreadsPerWarp);

% B39
if myAllocationGranularity == WARP,
    MyRegsPerBlock = MyWarpsPerBlock;
elseif myAllocationGranularity == BLOCK,
    wpb = roundUp(MyWarpsPerBlock, myWarpAllocationGranularity);
    rpw = MyRegCount.*limitThreadsPerWarp;
    rpb = wpb.*rpw;
    MyRegsPerBlock = roundUp(rpb, myAllocationSize);
else
    error('Unrecognized register allocation granularity')
end

% B40
MySharedMemPerBlock = roundUp(MySharedMemory, mySharedMemAllocationSize);

% C38 = limitWarpsPerMultiprocessor;

% C39
if myAllocationGranularity == WARP,
    rpw = MyRegCount.*limitThreadsPerWarp;
    rpw = roundUp(rpw, myAllocationSize);
    rpm = roundDown(limitTotalRegisters./rpw, myWarpAllocationGranularity);
    MyRegsPerSm_ = rpm;
elseif myAllocationGranularity == BLOCK,
    MyRegsPerSm_ = limitTotalRegisters;
else
    error('Unrecognized register allocation granularity')
end

% C40 = limitTotalSharedMemory

% D38, B44
%size(limitBlocksPerMultiprocessor)
%size(limitWarpsPerMultiprocessor)
%size(MyWarpsPerBlock)
limitBlocksDueToWarps = min(limitBlocksPerMultiprocessor, floor(limitWarpsPerMultiprocessor./MyWarpsPerBlock));

% D39, B45
limitBlocksDueToRegs = limitBlocksPerMultiprocessor;
mask = MyRegCount > 0;
limitBlocksDueToRegs(mask) = floor(MyRegsPerSm_(mask)./MyRegsPerBlock(mask));
mask   = MyRegCount > limitRegsPerThread;
mzeros = zeros(size(mask));
limitBlocksDueToRegs(mask) = mzeros(mask);

% D40, B46
limitBlocksDueToSMem = limitBlocksPerMultiprocessor;
mask=MySharedMemPerBlock>0;
limitBlocksDueToSMem(mask) = floor(limitTotalSharedMemory(mask) ./ MySharedMemPerBlock(mask));

%size(limitBlocksDueToWarps)
%size(limitBlocksDueToRegs)
%size(limitBlocksDueToSMem)


limitBlocks_ = [limitBlocksDueToWarps; limitBlocksDueToRegs; limitBlocksDueToSMem];
limitFlags_  = bsxfun(@eq, limitBlocks_, min(limitBlocks_));

activeBlocks_  = min(limitBlocks_);                     % B19
activeWarps_   = activeBlocks_ .* MyWarpsPerBlock;      % B18
ActiveThreads  = activeWarps_  .* limitThreadsPerWarp;  % B17
% B20:
smOccupancy_   = round(100*activeWarps_./limitWarpsPerMultiprocessor);
% B17:B19
activeTWB_     = [ActiveThreads; activeWarps_; activeBlocks_];

% This is the yellow "Allocated Resources" box, B38:D40
if nargout==0,
    GPUOccupancyData = [
        activeTWB_;
        smOccupancy_
    ]

    AllocatedResources = [
        MyWarpsPerBlock      limitWarpsPerMultiprocessor  limitBlocksDueToWarps ;
        MyRegsPerBlock       MyRegsPerSm_                 limitBlocksDueToRegs  ;
        MySharedMemPerBlock  limitTotalSharedMemory       limitBlocksDueToSMem
    ]

    % D44:D46 (C44:C46 is just 3x MyWarpsPerBlock)
    limitWarps_ = limitFlags_ .* limitBlocks_ .* MyWarpsPerBlock;

    MaximumThreadBlocksPerMultiprocessor = [
        limitBlocks_ MyWarpsPerBlock.*limitFlags_ limitWarps_
    ]

end

end
