fol_name = 'data/behav_raw';
all = dir(strcat(fol_name,'/*.mat'));
for k = 1:length(all)
  load(strcat(fol_name,'/',all(k).name));
  subject.behav.raw.responses = subject.responses;
  subject.behav.raw.train_responses = subject.train_responses;
  subject.behav.raw.stim_onsets = subject.stim_onsets;
  try
    subject = rmfield(subject,{'aversive_sound','responses','train_responses','stim_onsets'});
  catch
  end
  subject.stats = []; subject.hgf = []; subject.gsr = [];
  save(strcat('data/behav_w_css/',all(k).name), 'subject');
end
disp('Done reorganizing.');