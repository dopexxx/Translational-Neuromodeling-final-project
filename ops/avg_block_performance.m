fol_name = 'data/behav_analyzed';
all = dir(strcat(fol_name,'/*.mat'));
block_ratio_neutral = zeros(1,5); block_ratio_aversive = zeros(1,5);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    block_ratio_neutral = block_ratio_neutral + subject.stats.block_scores_neutral(2,:)./(subject.stats.block_scores_neutral(1,:)+subject.stats.block_scores_neutral(2,:));
end
block_ratio_neutral = block_ratio_neutral / length(all);
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    block_ratio_aversive = block_ratio_aversive + subject.stats.block_scores_aversive(2,:)./(subject.stats.block_scores_aversive(1,:)+subject.stats.block_scores_aversive(2,:));
end
block_ratio_aversive = block_ratio_aversive / length(all);
subplot(1,2,1); bar(block_ratio_neutral);
subplot(1,2,2); bar(block_ratio_aversive);