disp(12)
fol_name = 'data/behav_raw';
all = dir(strcat(fol_name,'/*.mat'));
for k = 1:length(all)
  load(strcat(fol_name,'/',all(k).name));
  subject.behav.raw.responses = subject.responses;
  subject.behav.raw.train_responses = subject.train_responses;
  subject.behav.raw.stim_onsets = subject.stim_onsets;
  subject = rmfield(subject,{'aversive_sound','responses','train_responses','stim_onsets'});
  subject.stats = []; subject.hgf = []; subject.gsr = [];
  save(strcat('data/behav/',all(k).name), 'subject');
end
