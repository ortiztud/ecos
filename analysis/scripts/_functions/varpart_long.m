function [Rsq,RsqAdj,Fractions,FractionsAdj,Prob]=varpart_long(predictand,predictors,NumberPermutations,ShowResultTable);
% VariationPartitionRDA: performs a variation partitioning on a distance
% (or similarity) matrix based on two or more data matrices.
% ¿¿based on redundancy analysis (RDA). ??
% Tests of significance on fractions are performed by permutation.
%
% This implementation of the variation partitioning analysis is based on
% the original MATLAB function from Peres-Neto (2006). This new version
% extends the original version to allow for more than two predictors.
% Note however that in its current implementation it can only be used to
% compute unique fractions of each predictor and the shared variance among
% all the predictors but not joint contributions of some combination. This
% is mathematically possible and more tedious to automatize here than
% really complicated, so a future version of this function might include
% that functionality.
%
% input:
%   predictand = distance matrix (obs x obs) of response variables
%   predictors = cell array of matrices (obs X obs) of independent variables
%   NumberPermutations = Number of Permutations for the permutation test
%                        (e.g., 99, 999, 9999) - the observed statistic
%                        is included in the permuted distribution;
%                        if set to 0, the test is not performed
%   ShowResultTable = if set to 1, a formatted Table with all the results
%                     will be displayed
% output:
%   Rsq = fractions [abc], [ab] and [bc]
%   RsqAdj = adjusted fractions [abc], [ab] and [bc]
%   Fractions = fractions [a], [b], [c] and [d]
%   FractionsAdj = adjusted fractions [a], [b], [c] and [d]
%   [abc] = variation explained due to X1 and X2
%   [ab] = variation explained due to X1
%   [bc] = variation explained due to X2
%   a = unique fraction of variation due to matrix X
%   b = common fraction of variation between matrices X and W
%   c = unique fraction of variation due to matrix W
%   d = residual fraction
%   Prob [Probabc, Probab, Probbc, Proba and Probc] = probabilities associated to fractions [abc], [ab], [bc], [a] and [c], respectively
%   Note that fraction [b] cannot be tested
%   Probabc, Probab, Probbc, Proba and Probc = probabilities associated to fractions [abc], [ab], [bc], [a] and [c], respectively
%   Note that fraction [b] cannot be tested

% References: Borcard, D., P. Legendre and P. Drapeau. 1992. Partialling out the spatial component of ecological variation. Ecology 73:1045-1055.
%             Legendre, P. and L. Legendre. 1998. Numerical ecology. 2nd English edition. Elsevier Science BV, Amsterdam.
%
% author: Javier Ortiz-Tudela, May 2021 (Goethe University)
% based on DistanceVariationPartition.m by Pedro Peres-Neto, May 2005

% For easier handling
Y = predictand;
X1 = predictors{1};
X2 = predictors{2};
n = size(X1,1);

% First we need to know how many predictors were entered in the analysis.
n_preds = size(predictors,2);

% Get number of columns and rows
NumberColumns=size(Y,1);
NumberRows=NumberColumns*(NumberColumns-1)/2; % We only need half because distance matrices are usually simmetric.

% Turn distance matrices into vectors.
YVector = Y(~triu(ones(NumberColumns)));
for c_pred = 1:n_preds
    pred_vec{c_pred} = predictors{c_pred}(~triu(ones(NumberColumns)));
end
% XVector=X(find(~triu(ones(NumberColumns))));
% WVector=W(find(~triu(ones(NumberColumns))));

% Center distance vectors
YVector=YVector-ones(NumberRows,1)*mean(YVector);
for c_pred = 1:n_preds
    pred_vec{c_pred} = pred_vec{c_pred} - ones(NumberRows,1)*mean(pred_vec{c_pred});
end

% Fractions observed
k=size(YVector,1); % number of observations
TotalSS=trace(YVector'*YVector);
TotalMS=TotalSS/(n-1);

%% Run regressions for each model
% -----------------------------
%% Full model
% (a.k.a., "abc" for two predictors, "abcd" for three predictors and so
% on).

% Create a matrix of predictors
for c_pred = 1:n_preds
    pred_mat(:,c_pred)= pred_vec{c_pred};
end

% Compute regression
temp = run_regresion(pred_mat,YVector);
Rsq.full = temp.adjusted;

%% Rest of the models (Full model - 1 predictor)
% (a.k.a., "ab" and "bc" for two predictors, "abc", "abd" and "bcd" for
% three predictors and so on).
full_mat = pred_mat;

% Create matrix of predictors (full - 1)
for c_pred = 1:n_preds
    
    % Create a copy of the full mat and remove the current predictor
    temp = full_mat;
    temp(:,c_pred)=[];
    pred_mat = temp;
    
    % Compute regression
    temp = run_regresion(pred_mat,YVector);
    Rsq.fraction(c_pred) = temp.adjusted;
    
end

%% Compute unique contribution of each predictor
% -----------------------------

% We need to subtract the (Adj)Rsqrd of the Full - X model from the full
% model to obtain the contribution of X.
c = n_preds+1;
for c_pred = 1:n_preds
    Fractions(c_pred) = Rsq.full - Rsq.fraction(c_pred);
end

%% Compute shared variation
% -----------------------------

% We can also easily compute the shared variance.
shared = Rsq.full;
for c_pred = 1:n_preds
    shared = shared - Fractions(c_pred);
end

%% Compute residuals
% -----------------------------

% And the residuals (unexplained variance)
residuals = 1 - Rsq.full;

%% Permutation test
'Running permutation test'

%   FaObs=(a/NumberPredictorsX1)/(d/(n-NumberPredictorsX1-NumberPredictorsX2-1));
%   FcObs=(c/NumberPredictorsX2)/(d/(n-NumberPredictorsX1-NumberPredictorsX2-1));

Prob.abc=[]; Prob.ab=[]; Prob.bc=[]; Prob.a=[]; Prob.c=[];
if NumberPermutations > 0
    Probabc=1; Probab=1; Probbc=1; Proba=1; Probc=1;
    for i=1:NumberPermutations
        %$ =============== Permute predictand matrix
        PermutedColumns=randperm(NumberColumns);
        YPermuted=predictand(PermutedColumns,:);
        YPermuted=YPermuted(:,PermutedColumns);
        % Place distance matrices into a vector
        YVector=YPermuted(~triu(ones(NumberColumns)));
        % Center vector
        YVector=YVector-ones(NumberRows,1)*mean(YVector);
        
        %% =============== Testing for fractions [abc], [ab] and [bc] - permutation of raw data
        % Create a matrix of predictors
        for c_pred = 1:n_preds
            pred_mat(:,c_pred)= pred_vec{c_pred};
        end
        
        % Compute regression
        SlopesRnd = (pred_mat'*pred_mat) \ pred_mat'*YVector;
        pred = pred_mat * SlopesRnd;
        RegressionSS=trace(pred'*pred);
        abc=RegressionSS/TotalSS;
        residualMS=sum((YVector-pred)'*(YVector-pred))/(NumberRows-2-1);
        regressionMS=RegressionSS/NumberRows;
        FabcRnd=regressionMS/residualMS;
        SlopesRnd=abs(SlopesRnd);
        
        %% =============== Testing for fractions - permutation of raw data
        full_mat = pred_mat;
        
        % Create matrix of predictors (full - 1)
        for c_pred = 1:n_preds
            
            % Create a copy of the full mat and remove the current predictor
            temp = full_mat;
            temp(:,c_pred)=[];
            pred_mat = temp;
            
            % Compute regression
            slopes = (pred_mat'*pred_mat) \ pred_mat'*YVector;
            pred = pred_mat * slopes;
            RegressionSS=trace(pred'*pred);
            fract=RegressionSS/TotalSS;
            residualMS=sum((YVector-pred)'*(YVector-pred))/(NumberRows-2-1);
            regressionMS=RegressionSS/NumberRows;
            F_frac_Rnd(c_pred)=regressionMS/residualMS;
            
        end
        
        %% =============== Stats on permuted data
        if FabcRnd >= FabcObs; Probabc=Probabc+1; end
        for c_pred = 1:n_preds
            % Check Fs
            if F_frac_Rnd(c_pred) >= F_frac_Obs(c_pred)
                Prob_variation(c_pred)=Probab+1;
            end
            
            % Check slopes
            if SlopesRnd(c_pred) >= SlopesObs(c_pred)
                Prob_fraction(c_pred)=Proba(c_pred)+1;
            end
        end
        
        % P values
        Prob.abc=Probabc/(NumberPermutations+1);
        
        for c_pred = 1:n_preds
            Prob.variation(c_pred)=Prob_variation/(NumberPermutations+1);
            Prob.fraction(c_pred)=Prob_fraction(c_pred)/(NumberPermutations+1);
        end
        
    end
end

if ShowResultTable == 1
    if NumberPermutations > 0
        fprintf('Total Contribution:\n');
        fprintf('  Matrix    Percentg. Explanation  Percentg. Exp - Adjusted   Probability \n');
        fprintf('  X1X2     % -8.6f              % -8.6f                   %8.6f \n',Rsq.X12,RsqAdj.X12,Prob.abc);
        fprintf('  X1       % -8.6f              % -8.6f                   %8.6f \n',Rsq.X1,RsqAdj.X1,Prob.ab);
        fprintf('  X2       % -8.6f              % -8.6f                   %8.6f \n',Rsq.X2,RsqAdj.X2,Prob.bc);
        fprintf('\n');
        fprintf('Partitioning:\n');
        fprintf('  Fraction  Percentg. Explanation  Percentg. Exp - Adjusted   Probability \n');
        fprintf('  a        % -8.6f              % -8.6f                   %8.6f \n',Fractions.a,FractionsAdj.a,Prob.a);
        fprintf('  b        % -8.6f              % -8.6f                   \n',Fractions.b,FractionsAdj.b);
        fprintf('  c        % -8.6f              % -8.6f                   %8.6f \n',Fractions.c,FractionsAdj.c,Prob.c);
        fprintf('  residual % -8.6f              % -8.6f                   \n',Fractions.d,FractionsAdj.d);
    else
        fprintf('Total Contribution:\n');
        fprintf('  Matrix    Percentg. Explanation  Percentg. Exp - Adjusted   \n');
        fprintf('  X1X2     % -8.6f              % -8.6f                   \n',Rsq.X12,RsqAdj.X12);
        fprintf('  X1       % -8.6f              % -8.6f                   \n',Rsq.X1,RsqAdj.X1);
        fprintf('  X2       % -8.6f              % -8.6f                   \n',Rsq.X2,RsqAdj.X2);
        fprintf(' \n');
        fprintf('Partitioning:\n');
        fprintf('  Fraction  Percentg. Explanation  Percentg. Exp - Adjusted   \n');
        fprintf('  a        % -8.6f              % -8.6f                   \n',Fractions.a,FractionsAdj.a);
        fprintf('  b        % -8.6f              % -8.6f                   \n',Fractions.b,FractionsAdj.b);
        fprintf('  c        % -8.6f              % -8.6f                   \n',Fractions.c,FractionsAdj.c);
        fprintf('  residual % -8.6f              % -8.6f                   \n',Fractions.d,FractionsAdj.d);
    end;
end;
end

function Rsq = run_regresion(X,Y)

% Obtain betas
b = (X'*X) \ X'*Y;

% Get the fitted values
pred = X * b;

% Compute Rsqrd
Rsq.ordinary  = 1 - sum((Y - pred).^2) / sum((Y-mean(Y)).^2);

% Adjusted Rsqrd
n = size(Y,1);d = size(X,2);
Rsq.adjusted = 1 - (1-Rsq.ordinary) * (n - 1) /(n -d -1);
end
