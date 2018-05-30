function [outputArg1,outputArg2] = compute_plot_gsr_score(inputArg1,inputArg2)
%% Compute the scores based on the beliefs backtracked by PE theory

% 4 rows for 4 participants. Col 1+2 are have regular scores (blockwise),
% col 3 +4 have PE scores (blockwise). 
% third dim is for the same for the adjusted score
inds = [11,13,16,12];
s = zeros(4,4,2);
load('data/metadata.mat');

for k = 1:3
    load(['data/gsr_results/subject_',num2str(inds(k)),'.mat']);
    PEs = reshape(subject.gsr.responses.pe,2,150);

    disp('Scores of the participant are ')
    subject.scores
    
    s(k,1:2,1) = subject.scores(1:2,1);
    s(k,1:2,2) = subject.scores(1:2,2);
    
    % Compute the responses based on the PE idea
    resp_pe = zeros(size(subject.behav.raw.responses));
    for block = 1:2
        for t = 1:150
            if PEs(block,t) && subject.behav.raw.responses(block,t) ~= 2
                resp_pe(block,t) = ~subject.behav.raw.responses(block,t);
            elseif PEs(block,t) && subject.behav.raw.responses(block,t) == 2 
                resp_pe(block,t) = 2;
            else % no prediction error
                resp_pe(block,t) = subject.behav.raw.responses(block,t);
            end
        end
    end
    disp('Scores with the PE theory would be');
    score_pe = compute_score(subject,resp_pe)
    s(k,3:4,1) = score_pe(1:2,1);
    s(k,3:4,2) = score_pe(1:2,2);
    
    subject.gsr.actions = resp_pe;
    subject.gsr.perf_scores = score_pe;
    subject.gsr.csc_actions_neutral = resp_pe(1,:)'==metadata.cues;
    subject.gsr.csc_actions_aversive = resp_pe(2,:)'==metadata.cues;
    save(['data/gsr_results/subject_',num2str(inds(k)),'.mat'],'subject');
end

%
%  Compute the same individually for S12
load(['data/gsr_results/subject_12.mat']);
PEs = [[zeros(7,1);subject.gsr.responses.pe(1:143)],...
    subject.gsr.responses.pe(144:end)]';
disp('Scores of the participant are ')
subject.scores
s(4,1:2,1) = subject.scores(1:2,1);
s(4,1:2,2) = subject.scores(1:2,2);
%Compute the responses based on the PE idea
resp_pe = zeros(size(subject.behav.raw.responses));
for block = 1:2
    for t = 1:150
        if block == 1 && t<7
            resp_pe(block,t) = subject.behav.raw.responses(block,t);
        elseif PEs(block,t) && subject.behav.raw.responses(block,t) ~= 2
            resp_pe(block,t) = ~subject.behav.raw.responses(block,t);
        elseif PEs(block,t) && subject.behav.raw.responses(block,t) == 2
            resp_pe(block,t) = 2;
        else % no prediction error
            resp_pe(block,t) = subject.behav.raw.responses(block,t);
        end
    end
end
disp('Scores with the PE theory would be');
score_pe = compute_score(subject,resp_pe)
s(4,3:4,1) = score_pe(1:2,1);
s(4,3:4,2) = score_pe(1:2,2);

subject.gsr.actions = resp_pe;
subject.gsr.perf_scores = score_pe;
subject.gsr.csc_actions_neutral = resp_pe(1,:)'==metadata.cues;
subject.gsr.csc_actions_aversive = resp_pe(2,:)'==metadata.cues;
save('data/gsr_results/subject_12','subject');

%% Plot the change in score due to the PE theory

figure
stds = [std(s(:,1,1)),std(s(:,2,1)),std(s(:,3,1)),std(s(:,4,1))];
sems = stds ./ sqrt(4);
b = [[mean(s(:,1,1)),mean(s(:,3,1))]; [mean(s(:,2,1)),mean(s(:,4,1))]];

bar([1,2], b); hold on;
errorbar([0.85,1.85],[b(1,1), b(2,1),],[sems(1),sems(3)],...
    'linestyle','none','color',[0 114/255 189/255],'linewidth',2,'markersize',4);
errorbar([1.15,2.15],[ b(1,2), b(2,2)],[sems(2),sems(4)],...
    'linestyle','none','color',[217/255 83/255 35/255],'linewidth',2,'markersize',10);
legend('Behavioral responses','GSR responses')
title('Comparing performance score of behavioral and GSR data')
set(gcf,'color','w');
xlim([0.5,2.5]); xticks([1,2]);
ylim([0.5,0.85])
ylabel('Ratio of correct responses');
xticklabels({'Neutral sound','Aversive sound'});
%savefig('data/gsr_results/score_comp_with_invalid.fig')

%% Plot the change in score due to the PE theory

figure
b = [[mean(s(:,1,2)),mean(s(:,3,2))]; [mean(s(:,2,2)),mean(s(:,4,2))]];

bar([1,2], b); hold on;
errorbar([0.85,1.85],[b(1,1), b(2,1),],[sems(1),sems(3)],...
    'linestyle','none','color',[0 114/255 189/255],'linewidth',2,'markersize',4);
errorbar([1.15,2.15],[ b(1,2), b(2,2)],[sems(2),sems(4)],...
    'linestyle','none','color',[217/255 83/255 35/255],'linewidth',2,'markersize',10);
legend('Behavioral responses','GSR responses')
legend('Behavioral responses','GSR responses')
title('Comparing performance score of behavioral and GSR data')
set(gcf,'color','w');
xlim([0.5,2.5]); xticks([1,2]);
ylim([0.5,0.85])
ylabel('Adjusted performance score');
xticklabels({'Neutral sound','Aversive sound'});
%savefig('data/gsr_results/score_comp_adj_with_invalid.fig')


end

