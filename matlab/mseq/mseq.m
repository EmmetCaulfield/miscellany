function ms=mseq(base, pow, shift, alt)
% MSEQ  Returns a maximum length sequence for base 2, 3, or 5
%
% [ms]=MSEQ(base,pow[,shift,alt])
%
% OUTPUT:
%     ms = m-sequence of length base^pow-1
%
% INPUT:
%     base : base of sequence; 2, 3, or 5 supported
%     pow  : number of digits/power of sequence; length is base^pow-1
%     shift: cyclical shift of the sequence
%     alt  : alternative sequence (if available)
%
% Example:
%
%     b=3; p=3; ms=mseq(b, p)
%
% The output, ms, is a (b^p-1)x(p) matrix. Each row represents
% one element of the output sequence. Columns correspond to
% position-value digits in the given base. 
%
% Multiplication by a column vector of position values will yield an
% ordinary integer (continuing):
%
%     posval = b.^[p-1:-1:0]
%     ms * posval'
%
% The starting position is ALWAYS 1 as this is the only value
% guaranteed to exist for all m-sequences (e.g. mseq(2,1) is just
% 1). You can cyclically shift the output from this position with the
% optional shift argument.
%
% Some combinations of base and power have several alternative
% generating coefficients which you can choose with the optional
% alt argument.
%
% This version (C) Emmet Caulfield, 2015.
%
% Based on: http://www.mathworks.com/matlabcentral/fileexchange/3083-m-sequence-generation-program
%
% Buracas's original of this had some pretty funky specializations for
% what I thought was supposed to be a basic m-sequence generator. This
% version is intended to be less surprising.
% 
% Original (c) Giedrius T. Buracas, SNL-B, Salk Institute
% Register values are taken from: WDT Davies, System Identification
% for self-adaptive control. Wiley-Interscience, 1970
% When using mseq code for design of FMRI experiments, please, cite:
% G.T.Buracas & G.M.Boynton (2002) Efficient Design of Event-Related fMRI 
% Experiments Using M-sequences. NeuroImage, 16, 801-813.
 
if nargin<4,   alt=1; end
if nargin<3, shift=0; end;

% Total m-sequence length:
mSeqLen = base^pow-1;

register=zeros(pow,1);
register(end)=1;

if base==2,
switch pow,
case 1, tap(1).No=[1];
case 2, tap(1).No=[1,2];
case 3, tap(1).No=[1,3];
 		  tap(2).No=[2,3];
case 4, tap(1).No=[1,4];
 		  tap(2).No=[3,4];
case 5, tap(1).No=[2,5];
		  tap(2).No=[3,5];
		  tap(3).No=[1,2,3,5];
		  tap(4).No=[2,3,4,5];
		  tap(5).No=[1,2,4,5];
		  tap(6).No=[1,3,4,5];
case 6, tap(1).No=[1,6];
		  tap(2).No=[5,6];
		  tap(3).No=[1,2,5,6];
		  tap(4).No=[1,4,5,6];
		  tap(5).No=[1,3,4,6];
		  tap(6).No=[2,3,5,6];
case 7, tap(1).No=[1,7];
		  tap(2).No=[6,7];
		  tap(3).No=[3,7];
		  tap(4).No=[4,7];
		  tap(5).No=[1,2,3,7];
		  tap(6).No=[4,5,6,7];
		  tap(7).No=[1,2,5,7];
		  tap(8).No=[2,5,6,7];
		  tap(9).No=[2,3,4,7];
		  tap(10).No=[3,4,5,7];
		  tap(11).No=[1,3,5,7];
		  tap(12).No=[2,4,6,7];
		  tap(13).No=[1,3,6,7];
		  tap(14).No=[1,4,6,7];
		  tap(15).No=[2,3,4,5,6,7];
		  tap(16).No=[1,2,3,4,5,7];
		  tap(17).No=[1,2,4,5,6,7];
		  tap(18).No=[1,2,3,5,6,7];
case 8, tap(1).No=[1,2,7,8];
		  tap(2).No=[1,6,7,8];
		  tap(3).No=[1,3,5,8];
		  tap(4).No=[3,5,7,8];
		  tap(5).No=[2,3,4,8];
		  tap(6).No=[4,5,6,8];
		  tap(7).No=[2,3,5,8];
		  tap(8).No=[3,5,6,8];
		  tap(9).No=[2,3,6,8];
		  tap(10).No=[2,5,6,8];
		  tap(11).No=[2,3,7,8];
		  tap(12).No=[1,5,6,8];
		  tap(13).No=[1,2,3,4,6,8];
		  tap(14).No=[2,4,5,6,7,8];
		  tap(15).No=[1,2,3,6,7,8];
		  tap(16).No=[1,2,5,6,7,8];
case 9, tap(1).No=[4,9];
		  tap(2).No=[5,9];
		  tap(3).No=[3,4,6,9];
		  tap(4).No=[3,5,6,9];
		  tap(5).No=[4,5,8,9];
		  tap(6).No=[1,4,5,9];
		  tap(7).No=[1,4,8,9];
		  tap(8).No=[1,5,8,9];
		  tap(9).No=[2,3,5,9];
		  tap(10).No=[4,6,7,9];
		  tap(11).No=[5,6,8,9];
		  tap(12).No=[1,3,4,9];
		  tap(13).No=[2,7,8,9];
		  tap(14).No=[1,2,7,9];
		  tap(15).No=[2,4,7,9];
		  tap(16).No=[2,5,7,9];
		  tap(17).No=[2,4,8,9];
		  tap(18).No=[1,5,7,9];
		  tap(19).No=[1,2,4,5,6,9];
		  tap(20).No=[3,4,5,7,8,9];
		  tap(21).No=[1,3,4,6,7,9];
		  tap(22).No=[2,3,5,6,8,9];
		  tap(23).No=[3,5,6,7,8,9];
		  tap(24).No=[1,2,3,4,6,9];
		  tap(25).No=[1,5,6,7,8,9];
		  tap(26).No=[1,2,3,4,8,9];
		  tap(27).No=[1,2,3,7,8,9];
		  tap(28).No=[1,2,6,7,8,9];
		  tap(29).No=[1,3,5,6,8,9];
		  tap(30).No=[1,3,4,6,8,9];
		  tap(31).No=[1,2,3,5,6,9];
		  tap(32).No=[3,4,6,7,8,9];
		  tap(33).No=[2,3,6,7,8,9];
		  tap(34).No=[1,2,3,6,7,9];
		  tap(35).No=[1,4,5,6,8,9];
		  tap(36).No=[1,3,4,5,8,9];
		  tap(37).No=[1,3,6,7,8,9];
		  tap(38).No=[1,2,3,6,8,9];
		  tap(39).No=[2,3,4,5,6,9];
		  tap(40).No=[3,4,5,6,7,9];
		  tap(41).No=[2,4,6,7,8,9];
		  tap(42).No=[1,2,3,5,7,9];
		  tap(43).No=[2,3,4,5,7,9];
		  tap(44).No=[2,4,5,6,7,9];
		  tap(45).No=[1,2,4,5,7,9];
		  tap(46).No=[2,4,5,6,7,9];
		  tap(47).No=[1,3,4,5,6,7,8,9];
		  tap(48).No=[1,2,3,4,5,6,8,9];
case 10, tap(1).No=[3,10];
		   tap(2).No=[7,10];
		   tap(3).No=[2,3,8,10];
		   tap(4).No=[2,7,8,10];
		   tap(5).No=[1,3,4,10];
		   tap(6).No=[6,7,9,10];
		   tap(7).No=[1,5,8,10];
		   tap(8).No=[2,5,9,10];
		   tap(9).No=[4,5,8,10];
		   tap(10).No=[2,5,6,10];
		   tap(11).No=[1,4,9,10];
		   tap(12).No=[1,6,9,10];
		   tap(13).No=[3,4,8,10];
		   tap(14).No=[2,6,7,10];
		   tap(15).No=[2,3,5,10];
		   tap(16).No=[5,7,8,10];
		   tap(17).No=[1,2,5,10];
		   tap(18).No=[5,8,9,10];
		   tap(19).No=[2,4,9,10];
		   tap(20).No=[1,6,8,10];
		   tap(21).No=[3,7,9,10];
		   tap(22).No=[1,3,7,10];
		   tap(23).No=[1,2,3,5,6,10];
		   tap(24).No=[4,5,7,8,9,10];
		   tap(25).No=[2,3,6,8,9,10];
		   tap(26).No=[1,2,4,7,8,10];
		   tap(27).No=[1,5,6,8,9,10];
		   tap(28).No=[1,2,4,5,9,10];
		   tap(29).No=[2,5,6,7,8,10];
		   tap(30).No=[2,3,4,5,8,10];
		   tap(31).No=[2,4,6,8,9,10];
		   tap(32).No=[1,2,4,6,8,10];
		   tap(33).No=[1,2,3,7,8,10];
		   tap(34).No=[2,3,7,8,9,10];
		   tap(35).No=[3,4,5,8,9,10];
		   tap(36).No=[1,2,5,6,7,10];
		   tap(37).No=[1,4,6,7,9,10];
		   tap(38).No=[1,3,4,6,9,10];
		   tap(39).No=[1,2,6,8,9,10];
		   tap(40).No=[1,2,4,8,9,10];
		   tap(41).No=[1,4,7,8,9,10];
		   tap(42).No=[1,2,3,6,9,10];
		   tap(43).No=[1,2,6,7,8,10];
		   tap(44).No=[2,3,4,8,9,10];
		   tap(45).No=[1,2,4,6,7,10];
		   tap(46).No=[3,4,6,8,9,10];
		   tap(47).No=[2,4,5,7,9,10];
		   tap(48).No=[1,3,5,6,8,10];
		   tap(49).No=[3,4,5,6,9,10];
		   tap(50).No=[1,4,5,6,7,10];
		   tap(51).No=[1,3,4,5,6,7,8,10];
		   tap(52).No=[2,3,4,5,6,7,9,10];
		   tap(53).No=[3,4,5,6,7,8,9,10];
		   tap(54).No=[1,2,3,4,5,6,7,10];
		   tap(55).No=[1,2,3,4,5,6,9,10];
		   tap(56).No=[1,4,5,6,7,8,9,10];
		   tap(57).No=[2,3,4,5,6,8,9,10];
		   tap(58).No=[1,2,4,5,6,7,8,10];
		   tap(59).No=[1,2,3,4,6,7,9,10];
		   tap(60).No=[1,3,4,6,7,8,9,10];
case 11, tap(1).No=[9,11];
case 12, tap(1).No=[6,8,11,12];
case 13, tap(1).No=[9,10,12,13];
case 14, tap(1).No=[4,8,13,14];
case 15, tap(1).No=[14,15];
case 16, tap(1).No=[4,13,15,16];
case 17, tap(1).No=[14,17];
case 18, tap(1).No=[11,18];
case 19, tap(1).No=[14,17,18,19];
case 20, tap(1).No=[17,20];
case 21, tap(1).No=[19,21];
case 22, tap(1).No=[21,22];
case 23, tap(1).No=[18,23];
case 24, tap(1).No=[17,22,23,24];
case 25, tap(1).No=[22,25];
case 26, tap(1).No=[20,24,25,26];
case 27, tap(1).No=[22,25,26,27];
case 28, tap(1).No=[25,28];
case 29, tap(1).No=[27,29];
case 30, tap(1).No=[7,28,29,30];
otherwise error(sprintf('M-sequence %d^%d is not defined',base, pow))
end;   
elseif base==3,
switch pow,
case 2, tap(1).No=[2,1];
		   tap(2).No=[1,1];
case 3, tap(1).No=[0,1,2];
		   tap(2).No=[1,0,2];
		   tap(3).No=[1,2,2];
		   tap(4).No=[2,1,2];
case 4, tap(1).No=[0,0,2,1];
		   tap(2).No=[0,0,1,1];
		   tap(3).No=[2,0,0,1];
		   tap(4).No=[2,2,1,1];
		   tap(5).No=[2,1,1,1];
		   tap(6).No=[1,0,0,1];
		   tap(7).No=[1,2,2,1];
		   tap(8).No=[1,1,2,1];
case 5, tap(1).No=[0,0,0,1,2]; 
		   tap(2).No=[0,0,0,1,2];
		   tap(3).No=[0,0,1,2,2];
		   tap(4).No=[0,2,1,0,2];
		   tap(5).No=[0,2,1,1,2];
		   tap(6).No=[0,1,2,0,2];
		   tap(7).No=[0,1,1,2,2];
		   tap(8).No=[2,0,0,1,2];
		   tap(9).No=[2,0,2,0,2];
		   tap(10).No=[2,0,2,2,2];
		   tap(11).No=[2,2,0,2,2];
		   tap(12).No=[2,2,2,1,2];
		   tap(13).No=[2,2,1,2,2];
		   tap(14).No=[2,1,2,2,2];
		   tap(15).No=[2,1,1,0,2];
		   tap(16).No=[1,0,0,0,2];
		   tap(17).No=[1,0,0,2,2];
		   tap(18).No=[1,0,1,1,2];
		   tap(19).No=[1,2,2,2,2];
		   tap(20).No=[1,1,0,1,2];
		   tap(21).No=[1,1,2,0,2];
case 6, tap(1).No=[0,0,0,0,2,1];
		   tap(2).No=[0,0,0,0,1,1];
		   tap(3).No=[0,0,2,0,2,1];
		   tap(4).No=[0,0,1,0,1,1];
		   tap(5).No=[0,2,0,1,2,1];
		   tap(6).No=[0,2,0,1,1,1];
		   tap(7).No=[0,2,2,0,1,1];
		   tap(8).No=[0,2,2,2,1,1];
		   tap(9).No=[2,1,1,1,0,1];
		   tap(10).No=[1,0,0,0,0,1];
		   tap(11).No=[1,0,2,1,0,1];
		   tap(12).No=[1,0,1,0,0,1];
		   tap(13).No=[1,0,1,2,1,1];
		   tap(14).No=[1,0,1,1,1,1];
		   tap(15).No=[1,2,0,2,2,1];
		   tap(16).No=[1,2,0,1,0,1];
		   tap(17).No=[1,2,2,1,2,1];
		   tap(18).No=[1,2,1,0,1,1];
		   tap(19).No=[1,2,1,2,1,1];
		   tap(20).No=[1,2,1,1,2,1];
		   tap(21).No=[1,1,2,1,0,1];
		   tap(22).No=[1,1,1,0,1,1];
		   tap(23).No=[1,1,1,2,0,1];
		   tap(24).No=[1,1,1,1,1,1];
case 7, tap(1).No=[0,0,0,0,2,1,2];
		   tap(2).No=[0,0,0,0,1,0,2];
		   tap(3).No=[0,0,0,2,0,2,2];
		   tap(4).No=[0,0,0,2,2,2,2];
		   tap(5).No=[0,0,0,2,1,0,2];
		   tap(6).No=[0,0,0,1,1,2,2];
		   tap(7).No=[0,0,0,1,1,1,2];
		   tap(8).No=[0,0,2,2,2,0,2];
		   tap(9).No=[0,0,2,2,1,2,2];
		   tap(10).No=[0,0,2,1,0,0,2];
		   tap(11).No=[0,0,2,1,2,2,2];
		   tap(12).No=[0,0,1,0,2,1,2];
		   tap(13).No=[0,0,1,0,1,1,2];
		   tap(14).No=[0,0,1,1,0,1,2];
		   tap(15).No=[0,0,1,1,2,0,2];
		   tap(16).No=[0,2,0,0,0,2,2];
		   tap(17).No=[0,2,0,0,1,0,2];
		   tap(18).No=[0,2,0,0,1,1,2];
		   tap(19).No=[0,2,0,2,2,0,2];
		   tap(20).No=[0,2,0,2,1,2,2];
		   tap(21).No=[0,2,0,1,1,0,2];
		   tap(22).No=[0,2,2,0,2,0,2];
		   tap(23).No=[0,2,2,0,1,2,2];
		   tap(24).No=[0,2,2,2,2,1,2];
		   tap(25).No=[0,2,2,2,1,0,2];
		   tap(26).No=[0,2,2,1,0,1,2];
		   tap(27).No=[0,2,2,1,2,2,2];
otherwise error(sprintf('M-sequence %d^%d is not defined',base,pow))
end;   
elseif base==5,
switch pow,
case 2, tap(1).No=[4,3];
		   tap(2).No=[3,2];
		   tap(3).No=[2,2];
		   tap(4).No=[1,3];
case 3, tap(1).No=[0,2,3];
		   tap(2).No=[4,1,2];
		   tap(3).No=[3,0,2];
		   tap(4).No=[3,4,2];
		   tap(5).No=[3,3,3];
		   tap(6).No=[3,3,2];
		   tap(7).No=[3,1,3];
		   tap(8).No=[2,0,3];
		   tap(9).No=[2,4,3];
		   tap(10).No=[2,3,3];
		   tap(11).No=[2,3,2];
		   tap(12).No=[2,1,2];
		   tap(13).No=[1,0,2];
		   tap(14).No=[1,4,3];
		   tap(15).No=[1,1,3];
case 4, tap(1).No=[0,4,3,3];
		   tap(2).No=[0,4,3,2];
		   tap(3).No=[0,4,2,3];
		   tap(4).No=[0,4,2,2];
		   tap(5).No=[0,1,4,3];
		   tap(6).No=[0,1,4,2];
		   tap(7).No=[0,1,1,3];
		   tap(8).No=[0,1,1,2];
		   tap(9).No=[4,0,4,2];
		   tap(10).No=[4,0,3,2];
		   tap(11).No=[4,0,2,3];
		   tap(12).No=[4,0,1,3];
		   tap(13).No=[4,4,4,2];
		   tap(14).No=[4,3,0,3];
		   tap(15).No=[4,3,4,3];
		   tap(16).No=[4,2,0,2];
		   tap(17).No=[4,2,1,3];
		   tap(18).No=[4,1,1,2];
		   tap(19).No=[3,0,4,2];
		   tap(20).No=[3,0,3,3];
		   tap(21).No=[3,0,2,2];
		   tap(22).No=[3,0,1,3];
		   tap(23).No=[3,4,3,2];
		   tap(24).No=[3,3,0,2];
		   tap(25).No=[3,3,3,3];
		   tap(26).No=[3,2,0,3];
		   tap(27).No=[3,2,2,3];
		   tap(28).No=[3,1,2,2];
		   tap(29).No=[2,0,4,3];
		   tap(30).No=[2,0,3,2];
		   tap(31).No=[2,0,2,3];
		   tap(32).No=[2,0,1,2];
		   tap(33).No=[2,4,2,2];
		   tap(34).No=[2,3,0,2];
		   tap(35).No=[2,3,2,3];
		   tap(36).No=[2,2,0,3];
		   tap(37).No=[2,2,3,3];
		   tap(38).No=[2,1,3,2];
		   tap(39).No=[1,0,4,3];
		   tap(40).No=[1,0,3,3];
		   tap(41).No=[1,0,2,2];
		   tap(42).No=[1,0,1,2];
		   tap(43).No=[1,4,1,2];
		   tap(44).No=[1,3,0,3];
		   tap(45).No=[1,3,1,3];
		   tap(46).No=[1,2,0,2];
		   tap(47).No=[1,2,4,3];
		   tap(48).No=[1,1,4,2];
otherwise error(sprintf('M-sequence %d^%d is not defined',base,pow))
end;
end;

% Preallocate output matrix:
ms=zeros(mSeqLen, pow);

if alt>length(tap) || alt<=0,
    error(sprintf('No such alternative weight set (%d) for m-sequence %d^%d', alt, base, pow));
end;

weights=zeros(1,pow);
if base==2,
    weights(tap(alt).No)=1;
elseif base>2,
    weights=tap(alt).No;
end;

ms(1,:)=register;
for i=2:mSeqLen,
    newDigit = rem(weights*register+base,base);

    % Update the register  
    register=[newDigit; register(1:pow-1)];

    % Store the new value 
    ms(i,:)=register;
end

if shift ~= 0,
    shift=rem(shift, length(ms));
    ms=[ms(shift+1:end,:); ms(1:shift,:)];
end;
