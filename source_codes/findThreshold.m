clear all

% Load files

load("Final_Scores/all_intra_scores.mat");
load("Final_Scores/inter_scores_5_samples.mat");


% Sort both scores
% scores = sort(scores);
% t = sort(t);

inter_len = length(scores);
intra_len = length(t);

threshold = min(scores);
FAR = length(find(scores < threshold))/inter_len;
FRR = length(find(t > threshold))/intra_len;


while FAR < 0.009
    threshold = threshold + 0.0005;
    FAR = length(find(scores < threshold))/inter_len;
    FRR = length(find(t > threshold))/intra_len;
end

[threshold FAR FRR]
