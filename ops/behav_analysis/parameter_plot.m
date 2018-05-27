function parameter_plot(default_config)
if default_config
    fol_name = 'data/behav_analyzed_hgf';
else
    fol_name = 'data/behav_analyzed_hgf_newpriors';
end
all = dir(strcat(fol_name,'/*.mat'));
om2 = zeros(2,length(all)); om3 = zeros(2,length(all)); zeta = zeros(2,length(all));

for k = 1:length(all)
    load(strcat(fol_name,'/',all(k).name));
    om2(1,k) = subject.hgf.params_neutral.p_prc.om(2);
    om2(2,k) = subject.hgf.params_aversive.p_prc.om(2);
    om3(1,k) = subject.hgf.params_neutral.p_prc.om(3);
    om3(2,k) = subject.hgf.params_aversive.p_prc.om(3);
    zeta(1,k) = subject.hgf.params_neutral.p_obs.ze;
    zeta(2,k) = subject.hgf.params_aversive.p_obs.ze;
end

figure;
subplot(1,3,1);
plot(1,om2(1,:),'o','Linewidth',1);
hold on;
plot(2,om2(2,:),'o','Linewidth',1);
xlim([.5 2.5])
ax = gca;
%ax.XTickLabels={'Neutral','Aversive'};
title('\omega_2');

subplot(1,3,2);
plot(1,om3(1,:),'o','Linewidth',1);
hold on;
plot(2,om3(2,:),'o','Linewidth',1);
xlim([.5 2.5])
ax = gca;
%ax.XTickLabels={'Neutral','Aversive'};
title('\omega_3');


subplot(1,3,3);
plot(1,zeta(2,:),'o','Linewidth',1);
hold on;
plot(2,zeta(2,:),'o','Linewidth',1);
xlim([.5 2.5])
ax = gca;
%ax.XTickLabels={'Neutral','Aversive'};
title('\zeta');
end
