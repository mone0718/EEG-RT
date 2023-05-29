% 2023/05/18

%% rest mana_close 60秒付近

time = t(1:7000);

alpha_plot = alpha(50001:57000);
beta_plot = beta(50001:57000);

% alpha_hil_plot = alpha_hil(50001:57000);
% beta_hil_plot = beta_hil(50001:57000);

alpha_env = envelope(alpha,100,'peak');
beta_env = envelope(beta,50,'peak');

alpha_env_plot = alpha_env(50001:57000);
beta_env_plot = beta_env(50001:57000);

figure

subplot(2,1,1)
plot(time,alpha_plot,'linewidth',1.3)
hold on
plot(time,alpha_env_plot,'linewidth',2)
xlim([0,7])
xlabel('time(s)')
ylabel('Amplitude(\muV)')
title('Rest alpha-band EEG')

set(gca,'fontsize',14,'LineWidth', 0.7)

subplot(2,1,2)
plot(time,beta_plot,'linewidth',1.3)
hold on
plot(time,beta_env_plot,'linewidth',2)
xlim([0,7])
% ylim([-5,5])
xlabel('time(s)')
ylabel('Amplitude(\muV)')
title('Rest beta-band EEG')

set(gca,'fontsize',14,'LineWidth', 0.7)

%% mana top3
% set3,12trial

%% EMG




