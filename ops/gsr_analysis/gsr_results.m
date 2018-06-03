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
        resp = [subject.hgf.params_neutral.traj.epsi(8:end,2);...
            subject.hgf.params_aversive.traj.epsi(:,2)];
        c = corrcoef(subject.gsr.responses.pe,resp);
    else
        c = corrcoef(subject.gsr.responses.pe,[subject.hgf.params_neutral.traj.epsi(:,2);...
            subject.hgf.params_aversive.traj.epsi(:,2)]);
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
%% For every participant, take the PE trajectory, assign each value to one 
% out of 3 bins and plot the mean response of all trials falling into that
% bin

% Try first with the normal HGF fits (not new prior)
figure
k=0;
for ID = inds
    k = k+1;
    %load(['data/behav_analyzed_hgf/subject_',int2str(ID),'.mat'])
    load(['data/gsr_results/subject_',num2str(ID),'.mat'])
    load(['data/gsr_ledalab/subject_',num2str(ID),'_post.mat']);

    pe_bins = zeros(2,150); % will contain strength of PE
    
    for trial = 1:150
        if abs(subject.hgf.params_neutral.traj.epsi(trial,2)) < 0.4
            pe_bins(1,trial) = 1;
        elseif abs(subject.hgf.params_neutral.traj.epsi(trial,2)) < 1
            pe_bins(1,trial) = 2;
        else
            pe_bins(1,trial) = 3;
        end
        
        if abs(subject.hgf.params_aversive.traj.epsi(trial,2)) < 0.4
            pe_bins(2,trial) = 1;
        elseif abs(subject.hgf.params_neutral.traj.epsi(trial,2)) < 1
            pe_bins(2,trial) = 2;
        else
            pe_bins(2,trial) = 3;
        end
    end
    
    pe_low_neut = zeros(length(find(pe_bins(1,:)==1)),176);
    pe_low_av = zeros(length(find(pe_bins(2,:)==1)),176);
    pe_mid_neut = zeros(length(find(pe_bins(1,:)==2)),176);
    pe_mid_av = zeros(length(find(pe_bins(2,:)==2)),176);
    pe_high_neut = zeros(length(find(pe_bins(1,:)==3)),176);
    pe_high_av = zeros(length(find(pe_bins(2,:)==3)),176);
    
    cln=0; cla=0; cmn=0; cma=0; chn=0; cha=0;
    
    for block = 1:2
        for trial = 1:150
            trial_onset = data.event(trial).time; % ms precise sound onset
            % index of the nearest SCR sample
            sample_ind_onset = find(round(data.time*sf)/sf==...
                round(trial_onset*sf)/sf);
            bin_on = sample_ind_onset + sf*resp_onset; 
            bin_off = sample_ind_onset + sf*resp_offset;

            trial_resp = analysis.phasicData(bin_on:bin_off);
            
            if pe_bins(block,trial) == 1 && block == 1
                cln = cln+1;
                pe_low_neut(cln,:) = trial_resp;
            elseif pe_bins(block,trial) == 1 && block == 2
                cla = cla+1;
                pe_low_av(cla,:) = trial_resp;
           elseif pe_bins(block,trial) == 2 && block == 1
                cmn = cmn+1;
                pe_mid_neut(cmn,:) = trial_resp;
           elseif pe_bins(block,trial) == 2 && block == 2
                cma = cma+1;
                pe_mid_av(cma,:) = trial_resp;
           elseif pe_bins(block,trial) == 3 && block == 1
                chn = chn+1;
                pe_high_neut(chn,:) = trial_resp;
            elseif pe_bins(block,trial) == 3 && block == 2
                cha = cha+1;
                pe_high_av(cha,:) = trial_resp;    
            end
        end
    end
    %
    subplot(2,2,k)
    low = mean([pe_low_neut;pe_low_av],1);
    mid = mean([pe_mid_neut;pe_mid_av],1);
    high = mean([pe_high_neut;pe_high_av],1);

    plot(resp_onset:1/sf:resp_offset,low); hold on;
    plot(resp_onset:1/sf:resp_offset,mid); 
    plot(resp_onset:1/sf:resp_offset,high);  
    title(['Mean stimulus specific response if ID ',num2str(ID),' had...'])
    xlabel('Seconds')
    ylabel('relative signal strength')
    legend('... low PE', '...medium PE','...high PE');
    savefig('data/gsr_results/resp_as_fct_of_pe.fig')
end

%% Mean response of all participants ifor no sound in both blocks
figure
nn = mean([responses{1}.nos1;responses{2}.nos1/4;responses{3}.nos1;responses{4}.nos1]);
na = mean([responses{1}.nos2;responses{2}.nos2/4;responses{3}.nos2;responses{4}.nos2]);
plot(resp_onset:1/sf:resp_offset,nn); hold on;
plot(resp_onset:1/sf:resp_offset,na);  
title(['Average across all participants']);
xlabel('Seconds')
ylabel('relative signal strength')
legend('Reponse for no sound in block 1','Response for no sound in block 2');
savefig('data/gsr_results/Average prediction related response.fig')


%% Mean response of all participants ifor no sound in both blocks
figure
nn = mean([responses{1}.nos1;responses{2}.nos1/4;responses{3}.nos1;responses{4}.nos1]);
na = mean([responses{1}.nos2;responses{2}.nos2/4;responses{3}.nos2;responses{4}.nos2]);
plot(resp_onset:1/sf:resp_offset,nn); hold on;
plot(resp_onset:1/sf:resp_offset,na);  
title(['Average across all participants']);
xlabel('Seconds')
ylabel('relative signal strength')
legend('Reponse for no sound in block 1','Response for no sound in block 2');
savefig('data/gsr_results/Average prediction related response.fig')
%% Mean response of all participants in blocks 1 and 2 
figure
nn = mean([responses{1}.b1;responses{2}.b1/4;responses{3}.b1;responses{4}.b1]);
na = mean([responses{1}.b2;responses{2}.b2/4;responses{3}.b2;responses{4}.b2]);
plot(resp_onset:1/sf:resp_offset,nn); hold on;
plot(resp_onset:1/sf:resp_offset,na);  
title(['Average across all participants']);
xlabel('Seconds')
ylabel('relative signal strength')
legend('Reponse for block 1','Response in block 2');
savefig('data/gsr_results/Average prediction related response.fig')
%% Mean response of all participants in neutral and aversive sound
figure
nn = mean([responses{1}.av;responses{2}.av/4;responses{3}.av;responses{4}.av]);
na = mean([responses{1}.neut;responses{2}.neut/4;responses{3}.neut;responses{4}.neut]);
plot(resp_onset:1/sf:resp_offset,na); hold on;
plot(resp_onset:1/sf:resp_offset,nn);  
title(['Average across all participants']);
xlabel('Seconds')
ylabel('relative signal strength')
legend('Reponse for neutral sound','Response for aversive sound');
savefig('data/gsr_results/Average prediction related response.fig')
%% Mean response of all participants in correct and wrong trials
figure
%nn = mean([responses{1}.true;responses{2}.true/4;responses{3}.true;responses{4}.true]);
%na = mean([responses{1}.false;responses{2}.false/4;responses{3}.false;responses{4}.false]);
nn = mean([responses{1}.true;responses{2}.true/4;responses{3}.true;responses{4}.true]);
na = mean([responses{1}.false;responses{2}.false/4;responses{3}.false;responses{4}.false]);

plot(resp_onset:1/sf:resp_offset,nn,'linewidth',3,'color',niceGreen); hold on;
plot(resp_onset:1/sf:resp_offset,na,'linewidth',3,'color',niceRed);  
%set(gca,
title(['Average across remaining participants (N=4)']);
set(gcf,'color','white');
set(gca, 'FontSize', 16)
xlabel('Seconds')
ylabel('relative signal strength')
legend('Reponse for correct trials','Response in wrong trials');
savefig('data/gsr_results/Average prediction related response.fig')


%% Compute canonical WRONG and canonical CORRECT resp
fs = 60; % strength of mean filter
can_corr = medfilt1(nn,fs);
can_corr(1) = can_corr(2); can_corr(end) = can_corr(end-1);
can_wrong = medfilt1(na,fs);
can_wrong(1) = can_wrong(2); can_wrong(end)=can_wrong(end-1);
figure
plot(resp_onset:1/sf:resp_offset,can_corr,'linewidth',5,'color',niceGreen); hold on;
plot(resp_onset:1/sf:resp_offset,can_wrong,'linewidth',5,'color',niceRed); 
set(gcf,'color','w');
set(gca, 'FontSize', 16)
set(gca, 'FontSize', 16)
xlabel('Seconds')
ylabel('relative signal strength')
title('Canonical response if answer was ...')
legend('... correct', '... wrong')

%% Generate the GSR response based on the euclidean dist of each trials' signal 
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
        corrs(k,1) = c(1,2)
        c = corrcoef(PEs(2,:), abs(subject.hgf.params_aversive.traj.epsi(:,2)));
        corrs(k,2) = c(1,2)
    else
        % Subject ID 12 has missing trials...
        PEs = [zeros(7,1);responses{k}.pe(1:143);responses{k}.pe(144:end)];
        PEs = reshape(PEs,2,150);
        c = corrcoef(PEs(1,8:end), abs(subject.hgf.params_neutral.traj.epsi(8:end,2)));
        corrs(k,1) = c(1,2)
        c = corrcoef(PEs(2,:), abs(subject.hgf.params_aversive.traj.epsi(:,2)));
        corrs(k,2) = c(1,2)
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

