function ScorePlot(feature_file, partition_file, loglk_file)
clc
% close all
% PlotStyles = {'*-r','o-g','x-m','+-k'};
% for no = 1:4,
    feature_file = 'tree.txt';

    % for BIC
    d = 3;
    loglk_file = 'loglk.txt';
    loglikelihood = load(loglk_file);
    BIC_VALUE = [];
    for j = 2:60,
        partition_file = ['tree_' num2str(j) '.txt'];
        BICvalue = SegBIC(partition_file, loglikelihood(j-1), d);
        BIC_VALUE = [BIC_VALUE, BICvalue];
    end
%     plot(2:60, BIC_VALUE, '*-g');
    % grid on;
    % end BIC
    BIC_min = min(BIC_VALUE);
    BIC_max = max(BIC_VALUE);
    Norm_BIC = (BIC_VALUE-BIC_min)/(BIC_max-BIC_min); 
    plot(2:60, Norm_BIC, '*-g');
    hold on; grid on;
    % wb-index
    Score_Matrix = [];
    for i = 2: 60,
        partition_file = ['tree_' num2str(i) '.txt'];
        Score = SegEvaluate(feature_file, partition_file);
        Score_Matrix = [Score_Matrix, Score];
    end
    [value,num] = min(Score_Matrix);
%     disp(num);
    % figure;
%     plot(2:60, Score_Matrix, '*-b');
    % grid on;

    % end wb-index
    wb_min = min(Score_Matrix);
    wb_max= max(Score_Matrix);
    norm_wb = (Score_Matrix-wb_min)/(wb_max-wb_min);
    plot(2:60, norm_wb, 'o-r');
    plot(2:60, Norm_BIC+ norm_wb, '*-r');
    [a,b] = min(Norm_BIC+ norm_wb);
    disp(b);
    hold on;

% end
% this function is used to evaluate the image segmentation results.
% input: feature file;
%        label file with partitions
% output: value indicate the evaluation
% by Qinpei zhao 10.Mar.2009
% N - the number of data points (pixel number)
% d - dimension of feature space
% M - number of components
% Nj- number of pixels in each component
% NB: not applicable for M = 1; 1 component doesn't need to evaluate!!!!
function Score = SegEvaluate(feature_file, partition_file)
Score = 0;
Label = load(partition_file);
M = max(Label) + 1;
Feature = load(feature_file);
[N,d] = size(Feature);
%  assume each dimension of features is independent
for dim = 1:d,
    ssw = 0;
    ssb = 0;
    % mean of the whole image on each feature
    Xmean = sum(Feature(:, dim));
    for m = 0: M-1,
        Index = find(Label == m);
        Nm = length(Index);
        Cmean = sum(Feature(Index, dim));
        temp = Feature(Index, dim)-Cmean;
        ssw = ssw + sum(sqrt(temp.*temp)); 
        ssb = ssb + Nm* sqrt((Cmean - Xmean)*(Cmean - Xmean));
    end
    Score = Score + ssw / ssb;
    
end
Score =  M*Score;


% evaluate by BIC = -loglikelihood + 0.5*k*sum(log(Ni))
% input: partition_file
%        loglikelihood
% output: BIC value

function BICvalue = SegBIC(partition_file, loglikelihood, dim)
Label = load(partition_file);
N = length(Label);
M = max(Label) + 1;
temp = 0;
for m = 0:M-1,
    Index = find(Label == m);
    % number of points for each component
    Nm = length(Index); 
    temp = temp + log(Nm);
end

BICvalue = -N*loglikelihood + 0.5*M*(dim+1)*temp;




