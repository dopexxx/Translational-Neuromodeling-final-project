function [block_scores_neutral, block_scores_aversive] = performance_analysis(fol_name, name)
% Load data
load(strcat(fol_name,'/',name));
metadata = load('metadata.mat');

% Generate cue-stimulus contingency corrected input/output sequences
input_seq = subject.behav.css.input;
response_seq_neutral = subject.behav.css.response_neutral;
response_seq_aversive = subject.behav.css.response_aversive;

block_scores_neutral = zeros(3,5);
block_scores_aversive = zeros(3,5);

for l = 1:5
    block_scores_neutral(1,l) = sum(response_seq_neutral((l-1)*30+1:l*30)==0);
    block_scores_neutral(2,l) = sum(response_seq_neutral((l-1)*30+1:l*30)==1);
    block_scores_neutral(3,l) = 30- block_scores_neutral(1,l)- block_scores_neutral(2,l);
end

for l = 1:5
    block_scores_aversive(1,l) = sum(response_seq_aversive((l-1)*30+1:l*30)==0);
    block_scores_aversive(2,l) = sum(response_seq_aversive((l-1)*30+1:l*30)==1);
    block_scores_aversive(3,l) = 30- block_scores_aversive(1,l)- block_scores_aversive(2,l);
end
subject.stats.block_scores_aversive = block_scores_aversive;
subject.stats.block_scores_neutral = block_scores_neutral;
total_score_aversive = (sum(response_seq_aversive(1:30)==1)+sum(response_seq_aversive(31:60)==0)+sum(response_seq_aversive(91:120)==1)+sum(response_seq_aversive(121:150)==0))/120; 
total_score_neutral = (sum(response_seq_neutral(1:30)==1)+sum(response_seq_neutral(31:60)==0)+sum(response_seq_neutral(91:120)==1)+sum(response_seq_neutral(121:150)==0))/120; 
subject.stats.total_score_neutral = total_score_neutral;
subject.stats.total_score_aversive = total_score_aversive;


save(strcat('data/behav_analyzed_perf/',name), 'subject');
