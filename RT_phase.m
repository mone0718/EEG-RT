%% envelope phase-RT α,β

% RT 外れ値(0.7以上)を除外
RT_all = reshape(RT,[],1);
RT_filter_index = (0.2 <= RT_all & RT_all <= 0.7);
RT_plot = RT_all(RT_filter_index);

% キューのタイミングの位相
alphahil_all = reshape(alphahil_cue,1,[]);
alphahil_plot = alphahil_all(RT_filter_index);

betahil_all = reshape(betahil_cue,1,[]);
betahil_plot = betahil_all(RT_filter_index);

figure(1)

subplot(1,2,1)
plot(alphahil_plot,RT_plot,'o','MarkerSize',13,'MarkerFaceColor','r','MarkerEdgeColor','w','LineWidth',2)
xlabel('ebvelope phase(rad)')
xlim([-180,180])
xticks([-180,-90,0,90,180])
ylabel('RT(s)')
title('alpha','FontWeight','bold')
set(gca,'fontsize',20,'LineWidth', 0.7,'FontWeight','bold')

subplot(1,2,2)
plot(betahil_plot,RT_plot,'o','MarkerSize',13,'MarkerFaceColor','b','MarkerEdgeColor','w','LineWidth',2)
xlabel('ebvelope phase(rad)')
xticks([-180,-90,0,90,180])
xlim([-180,180])
ylabel('RT(s)')
title('beta','FontWeight','bold')
set(gca,'fontsize',20,'LineWidth', 0.7,'FontWeight','bold')

%% phase-RT α,β,θ

alpha_all = reshape(alpha_cue,1,[]);
alpha_plot = alpha_all(RT_filter_index);

beta_all = reshape(beta_cue,1,[]);
beta_plot = beta_all(RT_filter_index);

theta_all = reshape(theta_cue,1,[]);
theta_plot = theta_all(RT_filter_index);

figure(2)

subplot(3,1,1)
plot(alpha_plot,RT_plot,'r.')
xlabel('phase(rad)')
ylabel('RT(s)')
xlim([-180,180])
title('alpha')
% ylim([0.25,0.65])

subplot(3,1,2)
plot(beta_plot,RT_plot,'b.')
xlabel('phase(rad)')
ylabel('RT(s)')
xlim([-180,180])
title('beta')
% ylim([0.25,0.65])

subplot(3,1,3)
plot(theta_plot,RT_plot,'g.')
xlabel('phase(rad)')
ylabel('RT(s)')
xlim([-180,180])
title('theta')
% ylim([0.25,0.65])

