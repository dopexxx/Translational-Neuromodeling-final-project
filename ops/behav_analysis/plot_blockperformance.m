fol_name = 'data/behav_analyzed';
all = dir(strcat(fol_name,'/*.mat'));
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    subplot(length(all),2,k*2-1);
    bar(subject.stats.block_scores_neutral(2,:)./(subject.stats.block_scores_neutral(1,:)+subject.stats.block_scores_neutral(2,:)));
end
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    subplot(length(all),2,k*2);
   bar(subject.stats.block_scores_aversive(2,:)./(subject.stats.block_scores_aversive(1,:)+subject.stats.block_scores_aversive(2,:)));
end