%% Compare LMEs of 2- and both 3layer HGFs

LMEs = nan(2,3,12); % block, model (3def,3new,2), subject

paths = {'data/behav_analyzed_hgf_2layer/','data/behav_analyzed_hgf_default/',...
            'data/behav_analyzed_hgf_newpriors/'};

for p = 1:length(paths)
for i = 1:18
    try
        load([paths{p},'subject_',num2str(i),'.mat'])
        LMEs(1,p,i) = subject.hgf.params_neutral.optim.LME;
        LMEs(2,p,i) = subject.hgf.params_aversive.optim.LME;
    catch 
        fprintf('\nSubject %d not found',i)
    end
    
end
end

out = [17,15,10,5,4,2,1]
for i = 1:length(out)
LMEs(:,:,out(i))=[]
end

%% Look at differences between models

% Default vs. newpriors
% -------------------------------------------------------------------------

def_vs_np = LMEs(:,1,:)-LMEs(:,2,:);

% Default vs. 2layer
% -------------------------------------------------------------------------

def_vs_2l = LMEs(:,1,:)-LMEs(:,3,:);

% Newpriors vs 2layer 
% -------------------------------------------------------------------------

np_vs_2l = LMEs(:,2,:)-LMEs(:,3,:);

% Get averages
% -------------------------------------------------------------------------
avg_def_vs_np = mean(def_vs_np,3);
avg_def_vs_2l = mean(def_vs_2l,3);
avg_np_vs_2l = mean(np_vs_2l,3);
all = [avg_def_vs_np,avg_def_vs_2l,avg_np_vs_2l];
% Plot
% -------------------------------------------------------------------------
figure
bar(all)

ylabel('\DeltaLME \approx log Bayes factor','fontsize',15,'interpreter','tex')
%xlabel('Block: 1: Neutral, 2: Aversive','interpreter','tex','fontsize',15)
%xticks('','')
xticklabels({'Neutral','Aversive'})
%xtickformat('fontsize',13)
set(gca,'fontsize', 15,'fontname','CMU Sans Serif');
legend('default 3layer - new priors','default 3layer - 2layer','new priors - 2layer')



