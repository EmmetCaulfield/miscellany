clear;

imageSize=7;
numNeurons=10;
numClasses=3;
batchSize=8;

H=[imageSize numNeurons numClasses];
X=ones(batchSize, imageSize);
y=ones(batchSize, numClasses);
W0=ones(numNeurons, imageSize);
W1=ones(numClasses, numNeurons);
b0=ones(1, numNeurons);
b1=ones(1, numClasses);

% We're only interested in the matrix dimensions, so we don't bother
% with realistic functions, only ones that are dimensionally correct:
sigmoid = @(x) x;
softmax = @(x) x;
lambda  = 1;
rho     = 1;


% -mopal-start-ANN
% -mopal-group-feedForward
T    = X                      ;
R    = transpose(W0)          ;
T   *= R                      ;
R    = repmat(b0,batchSize,1) ;
T   += R                      ;
z0   = T                      ;
R    = sigmoid(z0)            ;
a0   = R                      ;

T    = a0                     ;
R    = transpose(W1)          ;
T   *= R                      ;
R    = repmat(b1,batchSize,1) ;
T   += R                      ;
z1   = T                      ;

T    = softmax(z1)            ;
a1   = T                      ;
yc   = T                      ;
% -mopal-end-feedForward

% -mopal-group-backPropagate
T      = yc              ;
T     -= y               ;
T     /= batchSize       ;

diff   = T               ;
T      = transpose(diff) ;
T     *= a0              ;
R      = W1              ;
R     *= lambda          ;
T     += R               ;
dW1    = T               ;

T      = sum(diff,1)     ;
db1    = T               ;

T      = diff            ;
T     *= W1              ;
da1    = T               ;

T      = da1             ;
T    .*= a0              ;
R      = 1               ;
R     -= a0              ;
T    .*= R               ;
dz1    = T               ;

T      = transpose(dz1)  ;
T     *= X               ;
R      = W0              ;
R     *= lambda          ;
T     += R               ;
dW0    = T               ;

T      = sum(dz1,1)      ;
db0    = T               ;

% -mopal-end-backPropagate
% -mopal-group-descend
% -mopal-group-W0
T    = W0  ;
R    = dW0 ;
R   *= rho ;
T   -= R   ;
W0   = T   ;
% -mopal-end-
% -mopal-group-b0
T    = b0  ;
R    = db0 ;
R   *= rho ;
T   -= R   ;
b0   = T   ;
% -mopal-end-
% -mopal-group-W1
T    = W1  ;
R    = dW1 ;
R   *= rho ;
T   -= R   ;
W1   = T   ;
% -mopal-end-
% -mopal-group-b1
T    = b1  ;
R    = db1 ;
R   *= rho ;
T   -= R   ;
b1   = T   ;
% -mopal-end-
% -mopal-end-descend
% -mopal-end-ANN
