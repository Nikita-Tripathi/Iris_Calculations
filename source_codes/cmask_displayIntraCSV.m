clear all

a = dir('./cmask_Intra_Results/*.csv');
num = size(a,1);
% 
% t = readmatrix(strcat("./All_Intra_Results/", a(1).name ));
% 
%  
% figure;
% histogram(t, 'Normalization', 'probability');
% hold on;
% for i=1:num
%      t = readmatrix(strcat("./All_Intra_Results/", a(i).name ));
%      histogram(t, 'Normalization', 'probability');
% end


t = [];
for i=1:num
     t = [t readmatrix(strcat("./cmask_Intra_Results/", a(i).name ))];
%      histogram(t, 'Normalization', 'probability');
end

figure;
hold on;
histogram(t, 'Normalization','probability');
% load('./Final_Scores/inter_scores_5_samples.mat');
scores = readmatrix("/Users/nikitatripathi/Desktop/domain-specific-BSIF-for-iris-recognition/source_codes/cmask_Inter_Results/5_sample_results.csv");
histogram(scores, 'Normalization','probability');
% histogram(t, 'Normalization', 'probability');