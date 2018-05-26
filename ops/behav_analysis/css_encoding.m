fol_name = 'data/behav';
all = dir(strcat(fol_name,'/*.mat'));
load('data/metadata.mat');
for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    css_input = metadata.stimuli==metadata.cues;
    css_response_neutral = ((subject.behav.raw.responses(1,:))'==metadata.cues)*1;
    css_response_aversive = ((subject.behav.raw.responses(2,:))'==metadata.cues)*1;
    css_response_neutral(subject.behav.raw.responses(1,:)'==2)= NaN;
    css_response_aversive(subject.behav.raw.responses(2,:)'==2) = NaN;
    subject.behav.css.input = css_input;
    subject.behav.css.response_neutral = css_response_neutral*1;
    subject.behav.css.response_aversive = css_response_aversive*1;
    save(strcat('data/behav/',all(k).name), 'subject');
end