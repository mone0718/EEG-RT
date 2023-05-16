% 2023/4/1
% α帯、β帯とその包絡線

fs = 1000;

% defaultanswer = {'Ichikawa'};
% subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
% subject_name = char(subject(1));

[fname, pname] = uigetfile('*.mat','解析するデータ');
FP = [fname pname];
if fname == 0
    return;
end

load([pname fname]);

% 地域周波数
filtered_data = data;
a = zeros(9,7);
b = zeros(9,7);
for i = 1:9
    [b(i,:),a(i,:)] = butter(3,[i*50-1 i*50+1]/500,'stop');
    filtered_data = filtfilt(b(i,:),a(i,:),filtered_data);
end

Force = filtered_data(:,1);
EMG = filtered_data(:,7);

% EEG α帯
EEG_alpha = datafilter(data,8,15,fs);
alpha = EEG_alpha(:,2) - (EEG_alpha(:,3) + EEG_alpha(:,4) + EEG_alpha(:,5) + EEG_alpha(:,6));

% β帯
EEG_beta = datafilter(data,15,35,fs);
beta = EEG_beta(:,2) - (EEG_beta(:,3) + EEG_beta(:,4) + EEG_beta(:,5) + EEG_beta(:,6));

t = 0:1/fs:(length(alpha)-1)/fs;

% figure;
% subplot(3,1,1);
% plot(t,Force,'linewidth',1.3);
% xlim([0 length(alpha)/fs]);
% title('Force');
% 
% subplot(3,1,2);
% plot(t,alpha*10,'linewidth',1.3);
% xlim([0 length(alpha)/fs]);
% title('alpha');
% 
% subplot(3,1,3);
% plot(t,beta*10,'linewidth',1.3);
% xlim([0 length(alpha)/fs]);
% title('beta');

%% EMG, alpha-band & beta-band EEG, Reaction onset 2023/4/30

% 生データ 1試行ごとにキー操作で見れるようにしたい

% EMGで判定(キューの直前3秒くらいの平均から+10SD(？))
move_onset = zeros(1,21);

aveEMG = (EMG-mean(EMG))*1000; % トレンド除去
rEMG = abs(aveEMG); % 全波整流

x_EMG = rEMG';

% キューの3秒前のrEMGの平均と標準偏差
for trial_num = 1:20
    j_start = cue_time(trial_num) * fs - 300 + 1;
    j_end = cue_time(trial_num) * fs;

    [SD,Mean] = std(rEMG(j_start:j_end));
end

% cnt = 1;
% 
% reac = 0;
% 
% for i = 1:length(t)
%     if x_Force(i) < -0.02
%         reac = reac + 1;
%         % disp(cnt);
%         if (cue_time(cnt)*fs <= i && i < cue_time(cnt)*fs + 2000) && reac == 1
%             
%             move_onset(cnt) = i;
%             cnt = cnt + 1;
%         end
%         reac = 0;
%     end
% 
%     if cnt >= 21
%         break
%     end
% end
% 
% move_onset = move_onset ./ fs;
% F = Force * (-1);

figure;
subplot(3,1,1);
plot(t,rEMG,'linewidth',1.3);
xlim([0 length(alpha)/fs]);
xline(cue_time);
% xline(move_onset,'-.');
title('rEMG');

subplot(3,1,2);
plot(t,alpha*10,'linewidth',1.3);
xlim([0 length(alpha)/fs]); 
xline(cue_time);
% xline(move_onset,'-.');
title('alpha');

subplot(3,1,3);
plot(t,beta*10,'linewidth',1.3);
xlim([0 length(alpha)/fs]);
xline(cue_time);
% xline(move_onset,'-.');
title('beta');

%% rest EEG


%% Force, alpha-band & beta-band EEG, Reaction onset 2023/4/11

% 目分量で調整
mod_cuestime = cuestime + 12.9;

% これとキューのタイミングの差がRT
move_onset = zeros(1,21);

x_Force = Force';
cnt = 1;
x = t(1:300);

reac = 0;

for i = 1:length(t)
    if x_Force(i) < -0.02
        reac = reac + 1;
        % disp(cnt);
        if (mod_cuestime(cnt)*fs <= i && i < mod_cuestime(cnt)*fs + 2000) && reac == 1
            
            move_onset(cnt) = i;
            cnt = cnt + 1;
        end
        reac = 0;
    end

    if cnt >= 21
        break
    end
end

move_onset = move_onset ./ fs;
F = Force * (-1);

figure;
subplot(3,1,1);
plot(t,F,'linewidth',1.3);
xlim([0 length(alpha)/fs]);
xline(mod_cuestime);
xline(move_onset,'-.');
title('Force');

subplot(3,1,2);
plot(t,alpha*10,'linewidth',1.3);
xlim([0 length(alpha)/fs]); 
xline(mod_cuestime);
xline(move_onset,'-.');
title('alpha');

subplot(3,1,3);
plot(t,beta*10,'linewidth',1.3);
xlim([0 length(alpha)/fs]);
xline(mod_cuestime);
xline(move_onset,'-.');
title('beta');

%% plot調整

% ichikawa_1 99 ~ 104秒
time = t(1:5000);
alpha_plot = alpha(99001:104000);
% beta_plot = beta(99001:104000);
F_plot = F(99001:104000);

alpha_hil = abs(hilbert(alpha));
alpha_hil_plot = alpha_hil(99001:104000);

cue = mod_cuestime - 99;
move = move_onset - 99;

RT = move(10) - cue(10);
disp(RT);

figure('Position',[1 1 500 400]);

subplot(2,1,1);
plot(time,F_plot,'linewidth',1.3);

set(gca,'FontSize',16);

xline(cue(10),'linewidth',1);
xline(move(10),'-.','linewidth',1);
xlim([0,5]);
ylabel('トルク');
title('力の強さ');
% ylabel('Torque');
% title('Force');

subplot(2,1,2);
plot(time,alpha_plot*10,'linewidth',1.3);
hold on
plot(time,alpha_hil_plot*10,'linewidth',2);

xline(cue(10),'linewidth',1);
xline(move(10),'-.','linewidth',1);
set(gca,'FontSize',16);
xlim([0,5]);
ylim([-4,4]);
yticks([-4,0,4]);
xlabel('時間(秒)')
ylabel('振幅(\muV)');
title('脳波');

% ylabel('EEG(\muV)')
% title('alpha-band');

% subplot(3,1,3);
% plot(time,beta_plot*10,'linewidth',1.3);
% 
% xline(cue(10),'linewidth',1);
% xline(move(10),'-.','linewidth',1);
% set(gca,'FontSize',16);
% xlim([0,5]);
% ylim([-5,5]);
% yticks([-5,0,5]);
% xlabel('time(s)')
% ylabel('EEG(\muV)')
% title('beta-band');

%% ichikawa_1 43~48秒 & 99 ~ 104秒

time = t(1:5000);
alpha_plot = alpha(43001:48000);
% beta_plot = beta(43001:48000);
F_plot = F(43001:48000);

alpha_hil = abs(hilbert(alpha));
alpha_hil_plot = alpha_hil(43001:48000);

cue = mod_cuestime - 43;
move = move_onset - 43;

RT = move(4) - cue(4);
disp(RT);

figure('Position',[1 1 900 400]);
subplot(2,2,1);
plot(time,F_plot,'linewidth',1.3);

set(gca,'FontSize',16,'LineWidth', 1.1);

xline(cue(4),'linewidth',1.2);
xline(move(4),'-.','linewidth',1.2);
xlim([0,5]);
%ylim([-5,5]);
% yticks([-5,0,5]);
ylabel('トルク(V)')
title('力の強さ');

subplot(2,2,3);
plot(time,alpha_plot*10,'linewidth',1.3);
hold on
plot(time,alpha_hil_plot*10,'linewidth',2);

xline(cue(4),'linewidth',1.2);
xline(move(4),'-.','linewidth',1.2);
set(gca,'FontSize',16,'LineWidth', 1.1);
xlim([0,5]);
ylim([-8,8]);
yticks([-8,0,8]);
xlabel('時間(秒)')
ylabel('振幅(\muV)')
title('脳波');

% ichikawa_1 99 ~ 104秒
time = t(1:5000);
alpha_plot = alpha(99001:104000);
F_plot = F(99001:104000);

alpha_hil = abs(hilbert(alpha));
alpha_hil_plot = alpha_hil(99001:104000);

cue = mod_cuestime - 99;
move = move_onset - 99;

RT = move(10) - cue(10);
disp(RT);

subplot(2,2,2);
plot(time,F_plot,'linewidth',1.3);

set(gca,'FontSize',16,'LineWidth', 1.1);

xline(cue(10),'linewidth',1.2);
xline(move(10),'-.','linewidth',1.2);
xlim([0,5]);
%ylim([-5,5]);
% yticks([-5,0,5]);
% ylabel('トルク(V)')
title('力の強さ');

subplot(2,2,4);
plot(time,alpha_plot*10,'linewidth',1.3);
hold on
plot(time,alpha_hil_plot*10,'linewidth',2);

xline(cue(10),'linewidth',1.2);
xline(move(10),'-.','linewidth',1.2);
set(gca,'FontSize',16);
xlim([0,5]);
ylim([-5,5]);
yticks([-5,0,5]);
% ylabel('振幅(\muV)')
title('脳波');
xlabel('時間(秒)')

set(gca,'FontSize',16,'LineWidth', 1.1)

% subplot(3,1,3);
% plot(time,beta_plot*10,'linewidth',1.3);
% 
% xline(cue(4),'linewidth',1);
% xline(move(4),'-.','linewidth',1);
% set(gca,'FontSize',16);
% xlim([0,5]);
% % ylim([-3,3]);
% % yticks([-5,0,5]);
% xlabel('time(s)')
% ylabel('振幅(\muV)')
% title('beta-band');


%% 包絡線
alpha_hil = hilbert(alpha);
beta_hil = hilbert(beta);
alpha_hil2 = hilbert(abs(alpha_hil));
beta_hil2 = hilbert(abs(beta_hil));
alpha_hil3 = angle(alpha_hil2);
beta_hil3 = angle(beta_hil2);

figure;
clf(gcf);

subplot(3,1,1);
plot(t,alpha,'linewidth',1.5); 
hold on;
plot(t,abs(alpha_hil),'linewidth',3);
title("Rest Alpha");

subplot(3,1,2);
plot(t,abs(alpha_hil2));
title("abs");

subplot(3,1,3)
plot(t,alpha_hil3);
title("angle");

figure;
clf(gcf);

subplot(3,1,1);
plot(t,beta);
hold on;
plot(t,abs(beta_hil),'linewidth',3);
title("Rest Beta");

subplot(3,1,2);
plot(t,abs(beta_hil2));
title("abs");

subplot(3,1,3);
plot(t,beta_hil3);
title("angle");


%% 申請書類用plot

figure('Position',[1 1 500 300]);

time = t(1:5000);
alpha_plot = alpha(70501:75500);

alpha_plot_hil = alpha_hil(70501:75500);

% subplot(2,1,1);
plot(time,alpha_plot,'linewidth',1.2); 
hold on;
plot(time,abs(alpha_plot_hil),'linewidth',3);

set(gca,'FontSize',20);

xlim([0 5]);
ylim([-1 1]);

xlabel('時間(秒)');
ylabel('振幅(\muV)');

% subplot(2,1,2);
% beta_plot = beta(70001:75000);
% 
% beta_plot_hil = beta_hil(70001:75000);
% 
% subplot(2,1,2);
% plot(time,beta_plot,'linewidth',1.2); 
% hold on;
% plot(time,abs(beta_plot_hil),'linewidth',3);
% 
% set(gca,'FontSize',20);

% xlim([0 5]);
% ylim([-0.3 0.3]);

% xlabel('時間(秒)');
% ylabel('脳波(\muV)');

title('安静時の脳波');

%% スライド用plot ERD(30Yokota:4秒付近)

figure('Position',[1 1 500 350]);
time = t(1:8000);
alpha_plot = alpha(1501:9500);
beta_plot = beta(1501:9500);

%alpha_plot_hil = alpha_hil(1501:9500);

subplot(2,1,1);
plot(time,alpha_plot,'linewidth',1.2); 

set(gca,'FontSize',16);

xlim([0 5]);
ylim([-0.3 0.3]);
yticks([-0.3 0 0.3]);

ylabel('EEG(\muV)');
title('alpha-band');

box off;

subplot(2,1,2);
plot(time,beta_plot,'linewidth',1.2); 

set(gca,'FontSize',16);

xlim([0 5]);
ylim([-0.5 0.5]);

xlabel('time(s)');
ylabel('EEG(\muV)');
title('beta-band');

box off;

%% 包絡線(mone_3:72秒付近)

figure('Position',[1 1 500 300]);

time = t(1:8000);
alpha_plot = alpha(70001:78000);

alpha_plot_hil = alpha_hil(70001:78000);

plot(time,alpha_plot,'linewidth',1.2); 
hold on;
plot(time,abs(alpha_plot_hil),'linewidth',3);

set(gca,'FontSize',20);

xlim([0,6]);
ylim([-0.5 0.5]);

xlabel('time(s)');
ylabel('EEG(\muV)');


%% フィルタリング
function output1 = datafilter(DATA,cutoff,cutout,fs)
    aa = 1;
    Wn1(aa,:) = (aa * cutoff - 1) / (fs/2);
    Wn2(aa,:) = (aa * cutout + 1) / (fs/2);
    [a,b] = butter(2,[Wn1(aa,:) Wn2(aa,:)]);
    DATA = filtfilt(a,b,DATA);
    output1 = DATA;
end
