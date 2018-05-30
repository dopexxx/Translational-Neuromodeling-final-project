resp_onset = 1;  % 1000ms after stimulus onset
resp_offset = 4.5; % to 4500ms after stimulus onset 
sf = 50; % sampling frequency is 50 Hz

% for plotting
niceBlue = [0 114/255 189/255];
niceRed = [217/255 83/255 25/255];
niceGreen =  [116/255 166/255 95/255];

inds = [11,13,16,12];
responses = cell(4,1);
k = 0;
for ID = inds
    k=k+1;
    load(['data/behav_analyzed_hgf_newpriors/subject_',num2str(ID),'.mat']);
    subject.gsr.responses = struct();
    [subject.gsr.responses.neut, subject.gsr.responses.av] = mean_comp(ID,'sound');
    [subject.gsr.responses.b1, subject.gsr.responses.b2] = mean_comp(ID,'block');
    [subject.gsr.responses.nos1, subject.gsr.responses.nos2] = mean_comp(ID,'nosound');
    [subject.gsr.responses.pe, dummy] = mean_comp(ID,'PE');
    [subject.gsr.responses.true, subject.gsr.responses.false] = mean_comp(ID,'correct');
    save(['data/gsr_results/subject_',num2str(ID),'.mat'],'subject');
    
    responses{k} = subject.gsr.responses;
    
    disp('Correlate PE trace with responses is ');
    if ID == 12
        resp = [subject.behav.raw.responses(1,8:end),subject.behav.raw.responses(2,:)];
        c = corrcoef(subject.gsr.responses.pe,resp);
    else
        c = corrcoef(subject.gsr.responses.pe,reshape(...
            subject.behav.raw.responses,300,1));
    end
    c(1,2)
    
end
%% Plot results 
figure
for k = 1:4
    subplot(2,2,k);
    %nn = responses{k}.neut./max(responses{k}.neut);
    %na = responses{k}.av./max(responses{k}.av);
    nn = responses{k}.neut;
    na = responses{k}.av;
    plot(resp_onset:1/sf:resp_offset,nn); hold on;
    plot(resp_onset:1/sf:resp_offset,na);  
    title(['Subject ',num2str(inds(k))]);
    xlabel('Seconds')
    legend('Reponse to neutral sound','Response to aversive sound');
    savefig
end


figure
for k = 1:4
    subplot(2,2,k);
    %nn = responses{k}.nos1./max(responses{k}.nos1);
    %na = responses{k}.nos2./max(responses{k}.nos2);
    nn = responses{k}.nos1;
    na = responses{k}.nos2;
    plot(resp_onset:1/sf:resp_offset,nn); hold on;
    plot(resp_onset:1/sf:resp_offset,na);  
    title(['Subject ',num2str(inds(k))]);
    xlabel('Seconds')
    legend('Reponse to no sound in block 1','Response to no sound in block 2');
end

figure
for k = 1:4
    subplot(2,2,k);
    %nn = responses{k}.b1./max(responses{k}.b1);
    %na = responses{k}.b2./max(responses{k}.b2);
    nn = responses{k}.b1;
    na = responses{k}.b2;
    plot(resp_onset:1/sf:resp_offset,nn); hold on;
    plot(resp_onset:1/sf:resp_offset,na);  
    title(['Subject ',num2str(inds(k))]);
    xlabel('Seconds')
    legend('Reponse in first block','Response in second block');
end


figure
for k = 1:4
    subplot(2,2,k);
    %nn = responses{k}.b1./max(responses{k}.b1);
    %na = responses{k}.b2./max(responses{k}.b2);
    nn = responses{k}.true;
    na = responses{k}.false;
    plot(resp_onset:1/sf:resp_offset,nn); hold on;
    plot(resp_onset:1/sf:resp_offset,na);  
    title(['Subject ',num2str(inds(k))]);
    xlabel('Seconds')
    legend('Reponse for correct trials','Response in wrong trials');
end
%% Mean response of all participants in correct and wrong trials
figure
nn = mean([responses{1}.true;responses{2}.true/4;responses{3}.true;responses{4}.true]);
na = mean([responses{1}.false;responses{2}.false/4;responses{3}.false;responses{4}.false]);
plot(resp_onset:1/sf:resp_offset,nn); hold on;
plot(resp_onset:1/sf:resp_offset,na);  
title(['Average across all participants']);
xlabel('Seconds')
ylabel('relative signal strength')
legend('Reponse for correct trials','Response in wrong trials');
savefig('data/gsr_results/Average prediction related response.fig')

%% Mean response of all participants in correct and wrong trials
figure
nn = mean([responses{1}.true;responses{2}.true/4;responses{3}.true;responses{4}.true]);
na = mean([responses{1}.false;responses{2}.false/4;responses{3}.false;responses{4}.false]);
plot(resp_onset:1/sf:resp_offset,nn); hold on;
plot(resp_onset:1/sf:resp_offset,na);  
title(['Average across all participants']);
xlabel('Seconds')
ylabel('relative signal strength')
legend('Reponse for correct trials','Response in wrong trials');
savefig('data/gsr_results/Average prediction related response.fig')
%% Mean response of all participants in blocks 1 and 2 
figure
nn = mean([responses{1}.true;responses{2}.true/4;responses{3}.true;responses{4}.true]);
na = mean([responses{1}.false;responses{2}.false/4;responses{3}.false;responses{4}.false]);
plot(resp_onset:1/sf:resp_offset,nn); hold on;
plot(resp_onset:1/sf:resp_offset,na);  
title(['Average across all participants']);
xlabel('Seconds')
ylabel('relative signal strength')
legend('Reponse for correct trials','Response in wrong trials');
savefig('data/gsr_results/Average prediction related response.fig')
%% Mean response of all participants in neutral and aversive sound
figure
nn = mean([responses{1}.true;responses{2}.true/4;responses{3}.true;responses{4}.true]);
na = mean([responses{1}.false;responses{2}.false/4;responses{3}.false;responses{4}.false]);
plot(resp_onset:1/sf:resp_offset,nn); hold on;
plot(resp_onset:1/sf:resp_offset,na);  
title(['Average across all participants']);
xlabel('Seconds')
ylabel('relative signal strength')
legend('Reponse for correct trials','Response in wrong trials');
savefig('data/gsr_results/Average prediction related response.fig')

%% Compute canonical WRONG and canonical CORRECT resp
fs = 75; % strength of mean filter
can_corr = medfilt1(nn,fs);
can_corr(1) = can_corr(2); can_corr(end) = can_corr(end-1);
can_wrong = medfilt1(na,fs);
can_wrong(1) = can_wrong(2); can_wrong(end)=can_wrong(end-1);
figure
plot(resp_onset:1/sf:resp_offset,can_corr); hold on;
plot(resp_onset:1/sf:resp_offset,can_wrong); 
title('Canonical response if answer was ...')
legend('... correct', '... wrong')

%% Generate the GSR response based on the dot product of each trials' signal 
% with the canonical responses. Take the signal based on 

for ID = inds
    load(['data/gsr_results/subject_',num2str(ID),'.mat'])
    ID
    gsr_resp = infer_gsr_resp(ID,can_corr,can_wrong);
    
    disp('Behavioral scores of the participant are ')
    subject.scores
    
    gsr_scores = compute_score(subject,gsr_resp);
    disp('GSR based scores of the participant are ')
    gsr_scores

    
end


%% Compute and plot the performances of the PE actions

compute_plot_gsr_score();

%% Correlate PE traces with HGF PE traces
corrs = zeros(4,2); % rows are subjects, cols 1-2 for block 1 and 2
for k = 1:4
    load(['data/behav_analyzed_hgf/subject_',num2str(inds(k)),'.mat']);
    load('data/metadata.mat');
    
    
    if k<4
        PEs = reshape(responses{k}.pe,2,150);
        c = corrcoef(PEs(1,:), abs(subject.hgf.params_neutral.traj.epsi(:,2)));
        corrs(k,1) = c(1,2);
        c = corrcoef(PEs(2,:), abs(subject.hgf.params_aversive.traj.epsi(:,2)));
        corrs(k,2) = c(1,2);
    else
        % Subject ID 12 has missing trials...
        PEs = [zeros(7,1);responses{k}.pe(1:143);responses{k}.pe(144:end)];
        PEs = reshape(PEs,2,150);
        c = corrcoef(PEs(1,8:end), abs(subject.hgf.params_neutral.traj.epsi(8:end,2)));
        corrs(k,1) = c(1,2);
        c = corrcoef(PEs(2,:), abs(subject.hgf.params_aversive.traj.epsi(:,2)));
        corrs(k,2) = c(1,2);
    end
 
end
% Results are not meaningful (never over r=0.12)

%% Fit the responses backtracked from the PE signal in GSR in the HGF
% and compare with the behavior based HGF

gsr_hgf = cell(3,2);
for k = 1:3
    
    load(['data/gsr_results/subject_',num2str(inds(k)),'.mat']);
    
    HGF_input_seq =  subject.behav.css.input;
    HGF_output_seq_neutral = subject.gsr.csc_actions_neutral;
    subject.gsr.params_gsr_neutral = tapas_fitModel(HGF_output_seq_neutral,... % observations; here: empty.
                             HGF_input_seq,... % input
                             'tapas_hgf_binary_config',... % perceptual model
                             'tapas_unitsq_sgm_config',... % response model
                             'tapas_quasinewton_optim_config'); % opt. algo  

    HGF_input_seq =  subject.behav.css.input;
    HGF_output_seq_aversive = subject.gsr.csc_actions_aversive;
    subject.gsr.params_gsr_aversive = tapas_fitModel(HGF_output_seq_aversive,... % observations; here: empty.
                             HGF_input_seq,... % input
                             'tapas_hgf_binary_config',... % perceptual model
                             'tapas_unitsq_sgm_config',... % response model
                             'tapas_quasinewton_optim_config'); % opt. algo  
                         
                         
    subject.gsr.params_gsr_neutral = tapas_simModel(HGF_input_seq,... % data
                         'tapas_hgf_binary',... % perceptual model
                         subject.gsr.params_gsr_neutral.p_prc.p,... % NaN, -2.5, -6 = omegas
                         'tapas_unitsq_sgm',... % response model: unit square sigmoid
                         5) % zeta parameter  
    
    subject.gsr.params_gsr_aversive = tapas_simModel(HGF_input_seq,... % data
                         'tapas_hgf_binary',... % perceptual model
                         subject.gsr.params_gsr_aversive.p_prc.p,... % NaN, -2.5, -6 = omegas
                         'tapas_unitsq_sgm',... % response model: unit square sigmoid
                         5) % zeta parameter
                     
    save(['data/gsr_results/subject_',num2str(inds(k)),'.mat'],'subject');

end

