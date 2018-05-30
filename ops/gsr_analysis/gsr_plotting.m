%function a = gsr_plotting()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function plots all results from the GSR preprocessing and analysis
% pipeline.
% This includes:
%   - raw data
%   - median filtered data
%   - mean sound specific response for both blocks 
%   - PSTH for boths blocks (based on binarization of GSR signal)
%   - SCR prediction signal (to be compared with behavioral prediction
%        signal)
%   - MORE FEATURES

% TODO
niceBlue = [0 114/255 189/255];
niceRed = [217/255 83/255 25/255];
niceGreen =  [116/255 166/255 95/255];


ids = [11,12,13,16];
raw = cell(4,1);
post = cell(4,1);
figure 
for ind = 1:length(ids)
    id = ids(ind);
    load(['data/gsr_ledalab/subject_',num2str(id),'_post.mat']);
    raw{ind} = data.conductance;
    post{ind} = analysis.phasicData;
    subplot(4,2,ind*2-1);
    plot(data.conductance);
    title(['Raw data subject ',num2str(id)]);
    subplot(4,2,ind*2);
    plot(analysis.phasicData);
    title(['Phasic component subject ',num2str(id)]);
end
savefig('data/gsr_results/raw_post.fig');


figure
subplot(1,2,1);
for ind = 1:4
    plot(raw{ind}); hold on;
    title('Raw data')
end
subplot(1,2,2);

for ind = 1:4
    plot(post{ind}); hold on;
    title('Phasic component')
end

% resp_onset = 1;  % 1000ms before stimulus
% resp_offset = 3.5; % to 3500ms after stimulus
% subject.gsr.psth.borders = [-1*resp_onset, resp_offset];
%%
figure
plot(subject.gsr.raw.rel_times, subject.gsr.raw.values,'-o','color',niceGreen);
ylim([0 1000]);xlabel("secounds"); title("Raw data")

%%
figure
plot(1:length(subject.gsr.values),subject.gsr.values,'-o','color',niceGreen);
ylim([0 1000]);xlabel("secounds");

%%
figure
sample_dist = (1000/subject.gsr.frequency)/1000;
plot(subject.gsr.psth.borders(1):sample_dist:subject.gsr.psth.borders(2),...
    subject.gsr.neutral_sound_resp,'-o','color',niceBlue);
xlabel("secounds"); title("Mean response to neutral sound")

figure
sample_dist = (1000/subject.gsr.frequency)/1000;
plot(subject.gsr.psth.borders(1):sample_dist:subject.gsr.psth.borders(2),...
    subject.gsr.aversive_sound_resp,'-o','color',niceBlue);
xlabel("secounds"); title("Mean response to aversive sound")
%%
figure
sample_dist = (1000/subject.gsr.frequency)/1000;
plot(subject.gsr.psth.borders(1):sample_dist:subject.gsr.psth.borders(2),...
    subject.gsr.neutral_sound_resp,'-o','color',niceBlue); hold on;
plot(subject.gsr.psth.borders(1):sample_dist:subject.gsr.psth.borders(2),...
    subject.gsr.neutral_no_sound_resp,'-o','color',niceRed)
xlabel("secounds"); title("Mean response to neutral sound")

figure
sample_dist = (1000/subject.gsr.frequency)/1000;
plot(subject.gsr.psth.borders(1):sample_dist:subject.gsr.psth.borders(2),...
    subject.gsr.aversive_sound_resp,'-o','color',niceBlue);hold on;
plot(subject.gsr.psth.borders(1):sample_dist:subject.gsr.psth.borders(2),...
    subject.gsr.aversive_no_sound_resp,'-o','color',niceRed)
xlabel("secounds"); title("Mean response to aversive sound")