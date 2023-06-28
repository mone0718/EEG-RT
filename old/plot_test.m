%% zaitsu_5 185~190
time = t(1:5000);
alpha_plot = alpha(185001:190000);
beta_plot = beta(185001:190000);
F_plot = F(185001:190000);

cue = mod_cuestime - 185;
move = move_onset - 185;

RT = move(19) - cue(19);
disp(RT);

figure('Position',[1 1 500 600]);

subplot(3,1,1);
plot(time,F_plot,'linewidth',1.3);

set(gca,'FontSize',16);

xline(cue(19),'linewidth',1);
xline(move(19),'-.','linewidth',1);
xlim([0,5]);
% ylim([-2,2]);
% yticks([-5,0,5]);
ylabel('Torque')
title('Force');

subplot(3,1,2);
plot(time,alpha_plot*10,'linewidth',1.3);

xline(cue(19),'linewidth',1);
xline(move(19),'-.','linewidth',1);
set(gca,'FontSize',16);
xlim([0,5]);
ylim([-3,3]);
yticks([-3,0,3]);
ylabel('EEG(\muV)')
title('alpha-band');

subplot(3,1,3);
plot(time,beta_plot*10,'linewidth',1.3);

xline(cue(19),'linewidth',1);
xline(move(19),'-.','linewidth',1);
set(gca,'FontSize',16);
xlim([0,5]);
% ylim([-2,2]);
% yticks([-5,0,5]);
xlabel('time(s)')
ylabel('EEG(\muV)')
title('beta-band');


% zaitsu_5 99~104
time = t(1:5000);
alpha_plot = alpha(99001:104000);
beta_plot = beta(99001:104000);
F_plot = F(99001:104000);

cue = mod_cuestime - 99;
move = move_onset - 99;

RT = move(10) - cue(10);
disp(RT);

figure('Position',[1 1 500 600]);
subplot(3,1,1);
plot(time,F_plot,'linewidth',1.3);

set(gca,'FontSize',16);

xline(cue(10),'linewidth',1);
xline(move(10),'-.','linewidth',1);
xlim([0,5]);
% ylim([-2,2]);
% yticks([-5,0,5]);
ylabel('Torque')
title('Force');

subplot(3,1,2);
plot(time,alpha_plot*10,'linewidth',1.3);

xline(cue(10),'linewidth',1);
xline(move(10),'-.','linewidth',1);
set(gca,'FontSize',16);
xlim([0,5]);
ylim([-3,3]);
yticks([-3,0,3]);
ylabel('EEG(\muV)')
title('alpha-band');

subplot(3,1,3);
plot(time,beta_plot*10,'linewidth',1.3);

xline(cue(10),'linewidth',1);
xline(move(10),'-.','linewidth',1);
set(gca,'FontSize',16);
xlim([0,5]);
ylim([-2,2]);
% yticks([-5,0,5]);
xlabel('time(s)')
ylabel('EEG(\muV)')
title('beta-band');


%% mone_5 186~191
time = t(1:5000);
alpha_plot = alpha(186001:191000);
beta_plot = beta(186001:191000);
F_plot = F(186001:191000);

cue = mod_cuestime - 186;
move = move_onset - 186;

RT = move(19) - cue(19);
disp(RT);

figure('Position',[1 1 500 600]);
subplot(3,1,1);
plot(time,F_plot,'linewidth',1.3);

set(gca,'FontSize',16);

xline(cue(19),'linewidth',1);
xline(move(19),'-.','linewidth',1);
xlim([0,5]);
% ylim([-2,2]);
% yticks([-5,0,5]);
ylabel('Torque')
title('Force');

subplot(3,1,2);
plot(time,alpha_plot*10,'linewidth',1.3);

xline(cue(19),'linewidth',1);
xline(move(19),'-.','linewidth',1);
set(gca,'FontSize',16);
xlim([0,5]);
ylim([-3,3]);
yticks([-3,0,3]);
ylabel('EEG(\muV)')
title('alpha-band');

subplot(3,1,3);
plot(time,beta_plot*10,'linewidth',1.3);

xline(cue(19),'linewidth',1);
xline(move(19),'-.','linewidth',1);
set(gca,'FontSize',16);
xlim([0,5]);
% ylim([-2,2]);
% yticks([-5,0,5]);
xlabel('time(s)')
ylabel('EEG(\muV)')
title('beta-band');



% mone_5 43~48
time = t(1:5000);
alpha_plot = alpha(43001:48000);
beta_plot = beta(43001:48000);
F_plot = F(43001:48000);

cue = mod_cuestime - 43;
move = move_onset - 43;

RT = move(4) - cue(4);
disp(RT);

figure('Position',[1 1 500 600]);
subplot(3,1,1);
plot(time,F_plot,'linewidth',1.3);

set(gca,'FontSize',16);

xline(cue(4),'linewidth',1);
xline(move(4),'-.','linewidth',1);
xlim([0,5]);
% ylim([-3,3]);
% yticks([-3,0,3]);
ylabel('Torque')
title('Force');

subplot(3,1,2);
plot(time,alpha_plot*10,'linewidth',1.3);

xline(cue(4),'linewidth',1);
xline(move(4),'-.','linewidth',1);
set(gca,'FontSize',16);
xlim([0,5]);
ylim([-3,3]);
yticks([-3,0,3]);
ylabel('EEG(\muV)')
title('alpha-band');

subplot(3,1,3);
plot(time,beta_plot*10,'linewidth',1.3);

xline(cue(4),'linewidth',1);
xline(move(4),'-.','linewidth',1);
set(gca,'FontSize',16);
xlim([0,5]);
% ylim([-3,3]);
% yticks([-5,0,5]);
xlabel('time(s)')
ylabel('EEG(\muV)')
title('beta-band');
