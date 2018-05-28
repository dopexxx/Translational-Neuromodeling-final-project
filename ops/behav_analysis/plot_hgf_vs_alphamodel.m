function plot_hgf_vs_alphamodel(default_config, k, prior, prior_mean, l)
    if default_config
        fol_name = 'data/behav_analyzed_hgf';
    else
        fol_name = 'data/behav_analyzed_hgf_newpriors';
    end
    all = dir(strcat(fol_name,'/*.mat'));
    load(strcat(fol_name,'/',all(k).name));
    plot(sigm(subject.hgf.sim_neutral.traj.mu(:,2)));
    hold on;
    a = simulate_learning( subject.behav.css.input, prior, prior_mean, l);
    plot(a(2:end))
    title('A comparison')
end