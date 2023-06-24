% 2023/05/16
% 3rd presentation
% rEMG,theta,alpha,beta 波形 RT短い/長い 5トライアル分

clear
close all

%被験者名
defaultanswer = {'mone'};
subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
subject_name = char(subject(1));

fs = 1000;

% ディレクトリを選択
select_dir = uigetdir();

disp(select_dir);

% 選択したディレクトリ内のファイル一覧を取得
files = dir(fullfile(select_dir, 'random*.mat'));

%% RT計算、plot

close all

move_onset = zeros(20,numel(files));
RT = zeros(20,numel(files));

SD = zeros(20,numel(files));
Mean = zeros(20,numel(files));

cue_all = zeros(20,numel(files));

rEMG_all = [];

alpha_all = [];
beta_all = [];


for i = 1:numel(files)

    % ファイルのフルパスを作成
    filePath = fullfile(select_dir, files(i).name);
    
    % ファイルを読み込む
    load(filePath)

    disp(files(i).name)

    cue_all(:,i) = cue_time';

    % 地域周波数
    filtered_data = data;
    a = zeros(9,7);
    b = zeros(9,7);
    for j = 1:9
        [b(j,:),a(j,:)] = butter(3,[j*50-1 j*50+1]/500,'stop');
        filtered_data = filtfilt(b(j,:),a(j,:),filtered_data);
    end
    
    Force = filtered_data(:,1);
    EMG = filtered_data(:,7);

    % EEG θ帯
    EEG_theta = datafilter(data,4,8,fs)*100;
    theta = EEG_theta(:,2) - (EEG_theta(:,3) + EEG_theta(:,4) + EEG_theta(:,5) + EEG_theta(:,6))/4;
    
    % α帯
    EEG_alpha = datafilter(data,8,12,fs)*100;
    alpha = EEG_alpha(:,2) - (EEG_alpha(:,3) + EEG_alpha(:,4) + EEG_alpha(:,5) + EEG_alpha(:,6))/4;

%     alpha_all = vertcat(alpha_all,alpha);
    
    % β帯
    EEG_beta = datafilter(data,13,35,fs)*100;
    beta = EEG_beta(:,2) - (EEG_beta(:,3) + EEG_beta(:,4) + EEG_beta(:,5) + EEG_beta(:,6))/4;

%     beta_all(:,i) = beta;
    
    t = 0:1/fs:(length(alpha)-1)/fs;

    % EMGで判定(キューの直前3秒くらいの平均から+10SD(？))
    
    aveEMG = (EMG-mean(EMG))*1000; % 基線ずれ直す
    rEMG = abs(aveEMG); % 全波整流
    
%     rEMG_all(:,i) = rEMG;
    
    % キューの3秒前のrEMGの平均と標準偏差
    for trial_num = 1:20
        judge_end = round(cue_time(trial_num) * fs); %キューのタイミング
        judge_start = judge_end - 3000; %そこから3秒前
        
        % 標準偏差と平均
        [SD(trial_num,i),Mean(trial_num,i)] = std(rEMG(judge_start:judge_end));
    
        cnt = judge_end; %キューのタイミング(使い回し)
        reac_flag = false; 
    
        % キューの時点から判定
        % rEMGの値が平均+10SD超えた時点をonsetに保存
        while ~reac_flag
    
            cnt = cnt + 1;
            
            if rEMG(cnt) > Mean(trial_num,i) + SD(trial_num,i)*10
                move_onset(trial_num,i) = cnt/fs; %秒単位
                RT(trial_num,i) = move_onset(trial_num,i) - cue_time(trial_num); %onsetとcueの差
                reac_flag = true; 
            end
            
        end
    end

    % そのセットの中で1番RT長い試行
    [RTmax,RTmax_index] = max(RT(:,i));

%     % そのセットの中で1番RT短い試行
%     [RTmax,RTmax_index] = min(RT(:,i));

    disp(RTmax)
    
%------------------ figure描画(rEMG,theta,alpha,beta) --------------------
    cue_plot = round(cue_time(RTmax_index)*fs);
    start = cue_plot - 3000; 
    fin = start + 5000 - 1;

%     time = t(1:5000);
    time = -3:1/fs:2-1/fs;

    rEMG_plot = rEMG(start:fin);

    alpha_plot = alpha(start:fin);
    beta_plot = beta(start:fin);
    theta_plot = theta(start:fin);

    alpha_hil = abs(hilbert(alpha));
    beta_hil = abs(hilbert(beta));
    
    alpha_hil_plot = alpha_hil(start:fin);
    beta_hil_plot = beta_hil(start:fin);

    figure('Position',[1,500,500,600])

    % rEMG
    subplot(4,1,1)

    plot(time,rEMG_plot,'linewidth',1.5)
    xlim([0 length(alpha_plot)/fs])
    xline((cue_plot - start)/fs,'LineWidth',1.2)
    xline(move_onset(RTmax_index,i)-start/fs,'-.','LineWidth',1.2)
%     xlabel('time(s)')
%     ylabel('Amplitude(\muV)')
    title('rEMG','FontWeight','bold')

    set(gca,'fontsize',17,'LineWidth', 0.7,'FontWeight','bold')

    % theta
    subplot(4,1,2)

    plot(time,theta_plot,'linewidth',1.5)
    xlim([0 length(alpha_plot)/fs])
    ylim([-5,5])
    xline((cue_plot - start)/fs,'LineWidth',1)
    xline(move_onset(RTmax_index,i)-start/fs,'-.','LineWidth',1)
%     xlabel('time(s)')
    ylabel('Amplitude(\muV)','fontsize',25)
    title('theta-band EEG','FontWeight','bold')

    set(gca,'fontsize',17,'LineWidth', 0.7,'FontWeight','bold')

    % alpha
    subplot(4,1,3)
    plot(time,alpha_plot,'linewidth',1.5)
    hold on
    plot(time,alpha_hil_plot,'linewidth',2)
    xlim([0 length(alpha_plot)/fs])
    ylim([-5,5])
    xline((cue_plot - start)/fs,'LineWidth',1)
    xline(move_onset(RTmax_index,i)-start/fs,'-.','LineWidth',1)
%     xlabel('time(s)')
    ylabel('Amplitude(\muV)','fontsize',25)
    title('alpha-band EEG','FontWeight','bold')

    set(gca,'fontsize',17,'LineWidth', 0.7,'FontWeight','bold')

    % beta
    subplot(4,1,4)
    plot(time,beta_plot,'linewidth',1.3)
    hold on
    plot(time,beta_hil_plot,'linewidth',2)
    xlim([0 length(alpha_plot)/fs])
    ylim([-5,5])
    xline((cue_plot - start)/fs,'LineWidth',1)
    xline(move_onset(RTmax_index,i)-start/fs,'-.','LineWidth',1)
    xlabel('time(s)')
%     ylabel('Amplitude(\muV)')
    title('beta-band EEG','FontWeight','bold')

    set(gca,'fontsize',17,'LineWidth', 0.7,'FontWeight','bold')

    folder = '/Users/mone/Documents/MATLAB/EEG-RT/figure_sub';
    figname = sprintf('%s_short_%d.png',subject_name,i);
    saveas(gcf, fullfile(folder, figname))

%     figure('Position',[1,1,400,500])
%     subplot(311)
%     plot(t,rEMG,'linewidth',1.3)
%     xlim([0 length(alpha)/fs])
%     xline(cue_time)
%     xline(move_onset(:,i),'-.')
%     title('EMG')
% 
%     subplot(312)
%     plot(t,alpha,'linewidth',1.3)
%     xlim([0 length(alpha)/fs])
%     xline(cue_time)
%     xline(move_onset(:,i),'-.')
%     title('alpha')
% 
%     subplot(313)
%     plot(t,beta,'linewidth',1.3)
%     xlim([0 length(alpha)/fs])
%     xline(cue_time)
%     xline(move_onset(:,i),'-.')
%     title('beta')

end

% output_data = horzcat(rEMG,alpha,beta);
%     
% figure
% stackedplot(t,output_data)

%% 脳波のバンドパス

function output1 = datafilter(DATA,cutoff,cutout,fs)
    aa = 1;
    Wn1(aa,:) = (aa * cutoff - 1) / (fs/2);
    Wn2(aa,:) = (aa * cutout + 1) / (fs/2);
    [a,b] = butter(2,[Wn1(aa,:) Wn2(aa,:)]);
    DATA = filtfilt(a,b,DATA);
    output1 = DATA;
end

