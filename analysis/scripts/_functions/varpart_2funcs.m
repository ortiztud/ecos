function [fractions, prob, shared, residuals, rsq]=varpart_2funcs(predictand,predictors,n_permutations,ShowResultTable);
% VariationPartitionRDA: performs a variation partitioning on a distance
% (or similarity) matrix based on two or more data matrices.
%
% Tests of significance on fractions are performed by permutation and
% significance is declared with a 95% threshold. This can be adjusted in
% line 105.
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
%   n_permutations = Number of Permutations for the permutation test
%                        (e.g., 99, 999, 9999) - the observed statistic
%                        is included in the permuted distribution;
%                        if set to 0, the test is not performed
%   ShowResultTable = if set to 1, a formatted Table with all the results
%                     will be displayed
% output:
%   fractions = unique fraction of variation due to each predictor.
%   shared = common fraction of variation of all predictors (intersection).
%   residuals = unexplained fraction.
%   rsq = R squared of each regression model (ordinary and adjusted).
%   prob = probabilities associated to fractions of each predictor.

% References: Borcard, D., P. Legendre and P. Drapeau. 1992. Partialling out the spatial component of ecological variation. Ecology 73:1045-1055.
%             Legendre, P. and L. Legendre. 1998. Numerical ecology. 2nd English edition. Elsevier Science BV, Amsterdam.
%
% author: Javier Ortiz-Tudela, May 2021 (Goethe University)
% based on DistanceVariationPartition.m by Pedro Peres-Neto, May 2005

%% Read input arguments
% -----------------------------
% For easier handling
Y = predictand;

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

% Center distance vectors
YVector=YVector-ones(NumberRows,1)*mean(YVector);
for c_pred = 1:n_preds
    pred_vec{c_pred} = pred_vec{c_pred} - ones(NumberRows,1)*mean(pred_vec{c_pred});
end

%% Compute fractions
% -----------------------------
'Computing fractions'
[fractions, shared, residuals, rsq] = compute_fractions(pred_vec,YVector);

%% Permutation test
% -----------------------------
if n_permutations > 0
    'Running permutation test'
    fractions_perm = zeros(n_preds,n_permutations);
    
    for c_perm=1:n_permutations
        
        %% Permute predictand matrix
        PermutedColumns=randperm(NumberColumns);
        YPermuted=predictand(PermutedColumns,:);
        YPermuted=YPermuted(:,PermutedColumns);
        
        % Turn distance matrix into a vector
        YVector=YPermuted(~triu(ones(NumberColumns)));
        
        % Center vector
        YVector=YVector-ones(NumberRows,1)*mean(YVector);
        
        %% Compute fractions (permuted predictand)
        fractions_perm(:,c_perm) = compute_fractions(pred_vec,YVector);
        
    end
    
    %% Compute significance
    for c_pred = 1:n_preds
        
        % Sort permuted values
        sorted = sort(fractions_perm(c_pred,:), 'descend');
        
        % Count how many times true fractions are bigger than permuted
        % values
        temp = sum(fractions(c_pred)>fractions_perm(c_pred,:));
        
        % Get p values as 1 - percentage
        prob.p_val(c_pred) = 1- temp/n_permutations;
        
        % Get significance at 95 %
        threshold = prctile(fractions_perm(1,:),95);
        prob.signif(c_pred) = fractions(c_pred) > threshold;
    end
    
end

%% Print results to command window
% -----------------------------

if ShowResultTable == 1
    if n_permutations > 0
        fprintf('Partitioning:\n');
        fprintf('  Matrix    Percentg. Explanation   Probability   Signif. \n');
        for c_pred = 1:n_preds
            fprintf('  pred_%d     % -8.6f              %8.6f  %d \n',c_pred,fractions(c_pred),prob.p_val(c_pred),prob.signif(c_pred));
        end
    else
        fprintf('Partitioning:\n');
        fprintf('  Matrix    Percentg. Explanation  \n');
        for c_pred = 1:n_preds
            fprintf('  pred_%d     % -8.6f        \n',c_pred,fractions(c_pred));
        end
    end
end
end

%% Functions

function rsq = run_regresion(X,Y)

% Obtain betas
b = (X'*X) \ X'*Y;

% Get the fitted values
pred = X * b;

% Compute rsqrd
rsq.ordinary  = 1 - sum((Y - pred).^2) / sum((Y-mean(Y)).^2);

% Adjusted rsqrd
n = size(Y,1);d = size(X,2);
rsq.adjusted = 1 - (1-rsq.ordinary) * (n - 1) /(n -d -1);
end

function [fractions, shared, residuals, rsq] = compute_fractions(pred_vec,YVector)
%% Run regressions for each model
% -----------------------------
n_preds = size(pred_vec,2);

%% Full model
% (a.k.a., "abc" for two predictors, "abcd" for three predictors and so
% on).

% Create a matrix of predictors
for c_pred = 1:n_preds
    pred_mat(:,c_pred)= pred_vec{c_pred};
end

% Compute regression. Will try to use MATLAB's built-in function from the
% Statistics and Machine Learning Toolbox; in case it is not available,
% will use homebrew function.
try 
    mdl = fitlm(pred_mat,YVector);
    rsq.full = mdl.Rsquared.Adjusted;
catch
    temp = run_regresion(pred_mat,YVector);
    rsq.full = temp.adjusted;
end

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
    rsq.reduced(c_pred) = temp.adjusted;
    
end

%% Compute unique contribution of each predictor
% -----------------------------

% We need to subtract the (Adj)rsqrd of the Full - X model from the full
% model to obtain the contribution of X.
for c_pred = 1:n_preds
    fractions(c_pred) = rsq.full - rsq.reduced(c_pred);
end

%% Compute shared variation
% -----------------------------

% We can also easily compute the shared variance.
shared = rsq.full;
for c_pred = 1:n_preds
    shared = shared - fractions(c_pred);
end

%% Compute residuals
% -----------------------------

% And the residuals (unexplained variance)
residuals = 1 - rsq.full;

end
