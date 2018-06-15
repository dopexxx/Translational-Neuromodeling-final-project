%% For every participant, take the PE trajectory, assign each value to one 
% out of 3 bins and plot the mean response of all trials falling into that
% bin

% Try first with the normal HGF fits (not new prior)
figure
r=0;
res = cell(4,3);
for ID = inds
    
    r = r+1;
    load(['data/behav_analyzed_hgf/subject_',int2str(ID),'.mat'])
    load(['data/gsr_ledalab/subject_',num2str(ID),'_post.mat'])

    trials = [150,150]; % trials per block
    % Some trials removed in subject 12
    if ID == 12
        trials(1) = trials(1) - 7;
    end
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
    
    for k = 1:sum(trials)
        trial_onset = data.event(trial).time; % ms precise sound onset
        if ID == 12
            block = (k > 143) + 1;
            if k>143
                trial = k - 143;
            else
                trial = k;
            end
        else
            block = ceil(k/150);
            if k > 150
                trial = k - 150;
            else
                trial = k;
            end
        end
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
    %
    subplot(2,2,r)
    low = mean([pe_low_neut;pe_low_av],1);
    mid = mean([pe_mid_neut;pe_mid_av],1);
    high = mean([pe_high_neut;pe_high_av],1);
    if ID == 13
        low = low/4;
        mid = mid/4;
        high = high/4;
    end
    res{r,1}=low; res{r,2}=mid; res{r,3}=high;
    

    plot(resp_onset:1/sf:resp_offset,low); hold on;
    plot(resp_onset:1/sf:resp_offset,mid); 
    plot(resp_onset:1/sf:resp_offset,high);  
    title(['Mean stimulus specific response if ID ',num2str(ID),' had...'])
    xlabel('Seconds')
    ylabel('relative signal strength')
    legend('... low PE', '...medium PE','...high PE');
    legend('... low PE', '...high PE');
    savefig('data/gsr_results/resp_as_fct_of_pe2.fig')
end
%%

low = mean([res{1,1};res{2,1};res{3,1};res{4,1}],1);
med = mean([res{1,2};res{2,2};res{3,2};res{4,2}],1);
high = mean([res{1,3};res{2,3};res{3,3};res{4,3}],1);
figure
plot(resp_onset:1/sf:resp_offset,low); hold on;
plot(resp_onset:1/sf:resp_offset,med); 
plot(resp_onset:1/sf:resp_offset,high);  
title(['Mean stimulus specific response in trials with...'])
xlabel('Seconds')
ylabel('relative signal strength')
legend('... low PE', '...medium PE','...high PE');
savefig('data/gsr_results/resp_as_fct_of_pe_mean2.fig')

