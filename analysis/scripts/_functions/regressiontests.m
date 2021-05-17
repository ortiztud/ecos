clear
%% Function
load carsmall
Y = MPG;
a = find(isnan(Horsepower));
Horsepower(a)=[];Weight(a)=[];Acceleration(a)=[];Y(a)=[];
a = find(isnan(Y));
Horsepower(a)=[];Weight(a)=[];Acceleration(a)=[];Y(a)=[];
X = [Weight,Horsepower,Acceleration];

mdl = fitlm(X,Y);

%% Manual


% Centering is equivalent to adding a constant to the predictor matrix
% (intercept), but we need to also center the data!X = [ones(length(X),1) X];
Weight=Weight-ones(93,1)*mean(Weight);
Horsepower=Horsepower-ones(93,1)*mean(Horsepower);
Acceleration=Acceleration-ones(93,1)*mean(Acceleration);
X = [Weight,Horsepower,Acceleration];
Y=Y-ones(93,1)*mean(Y);

% Obtain betas
b = (X'*X) \ X'*Y;

% Get the fitted values
pred = X * b;

% Compute Rsqrd
Rsq  = 1 - sum((Y - pred).^2) / sum((Y-mean(Y)).^2);

% Adjusted Rsqrd
n = size(Y,1);d = size(X,2);
RsqAdj = 1 - (1-Rsq) * (n - 1) /(n -d -1);


% Sum of squares
SSM=sum(pred - mean(Y).^2);

% Mean of Squares of Mode
MSM = SSM / (d-1);

% Sum of squares error
SSE = sum((Y-pred).^2);

% Mean of Squares error
MSE = SSE / (n-d-1);

F = MSM/MSE

regressionMS=SSE/n;
residualMS=sum((Y-pred)'*(Y-pred))/ (n-d-1);
FabcObs=regressionMS/residualMS;

n = size(X,1);
NumberRows=size(Y,1);

TotalSS=trace(Y'*Y);
TotalMS=TotalSS/(n-1);
SSE=trace(pred'*pred);
Variation=SSE/TotalSS;
VariationAdj= 1-residualMS/TotalMS;
residualMS=sum((Y-pred)'*(Y-pred))/(NumberRows-2-1);
regressionMS=SSE/NumberRows;
FabcObs=regressionMS/residualMS;
b=abs(b);


