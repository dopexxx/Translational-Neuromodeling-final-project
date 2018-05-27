% Count irregular trials as rejection criterion and discard the 
% corresponding subjects

fol_name = 'data/behav_w_css';
all = dir(strcat(fol_name,'/*.mat'));
irrs = zeros(4,length(all));
criterion = 0.1;

for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    irrs(1,k) = subject.ID;
    irrs(2,k) = sum(isnan(subject.behav.css.response_neutral));
    irrs(3,k) = sum(isnan(subject.behav.css.response_aversive));
    irrs(4,k) = sum(irrs(2:3,k))/300;
    if irrs(4,k) > criterion
        save(strcat(fol_name,'/',all(k).name,'.discarded'),'subject')
        delete(strcat(fol_name,'/',all(k).name))
        fprintf('\nSubject # %d removed.',subject.ID);
    end
end




