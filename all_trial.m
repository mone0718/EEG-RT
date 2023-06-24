% 2023/06/08
% トライアルごと
% 

clear

[directory,files,subject_name] = selectdir;

%% EMG,theta,alpha,beta トライアルごと

close all

FS = 1000;

P_START = -3;
P_END = 2;
RANGE = P_END - P_START;

WIDTH = 400;
HEIGHT = 500;
% FONTSIZE = 16;


move_onset = zeros(20,numel(files));
RT = zeros(20,numel(files));

SD = zeros(20,numel(files));
Mean = zeros(20,numel(files));

cue_all = zeros(20,numel(files));


for i = 1

    filePath = fullfile(directory,files(i).name);
    load(filePath)

    disp(files(i).name)

    cue_all(:,i) = cue_time';

    % 地域周波数
    filtered_data = data;
    filt_a = zeros(9,7);
    filt_b = zeros(9,7);
    for j = 1:9
        [filt_b(j,:),filt_a(j,:)] = butter(3,[j*50-1 j*50+1]/500,'stop');
        filtered_data = filtfilt(filt_b(j,:),filt_a(j,:),filtered_data);
    end
    
    Force = filtered_data(:,1);
    EMG = filtered_data(:,7);

    % EEG θ帯
    EEG_theta = datafilter(data,4,8,FS)*100;
    theta = EEG_theta(:,2) - (EEG_theta(:,3) + EEG_theta(:,4) + EEG_theta(:,5) + EEG_theta(:,6))/4;
    
    % α帯
    EEG_alpha = datafilter(data,8,12,FS)*100;
    alpha = EEG_alpha(:,2) - (EEG_alpha(:,3) + EEG_alpha(:,4) + EEG_alpha(:,5) + EEG_alpha(:,6))/4;
    
    % β帯
    EEG_beta = datafilter(data,13,35,FS)*100;
    beta = EEG_beta(:,2) - (EEG_beta(:,3) + EEG_beta(:,4) + EEG_beta(:,5) + EEG_beta(:,6))/4;

    alpha_hil = abs(hilbert(alpha));
    beta_hil = abs(hilbert(beta));

    t = 0:1/FS:(length(alpha)-1)/FS;

    % EMGで判定(キューの直前3秒くらいの平均から+10SD(？))
    
    aveEMG = (EMG-mean(EMG))*1000; % 基線ずれ直す
    rEMG = abs(aveEMG); % 全波整流
    
    
    % キューの3秒前のrEMGの平均と標準偏差
    for trial_num = 1:20
        judge_end = round(cue_time(trial_num) * FS); %キューのタイミング
        judge_start = judge_end - 500; %そこから0.5秒前
        
        % 標準偏差と平均
        [SD(trial_num,i),Mean(trial_num,i)] = std(rEMG(judge_start:judge_end));
    
        cnt = judge_end; %キューのタイミング(使い回し)
        reac_flag = false; 
    
        % キューの時点から判定
        % rEMGの値が平均+10SD超えた時点をonsetに保存
        while ~reac_flag
    
            cnt = cnt + 1;
            
            if rEMG(cnt) > Mean(trial_num,i) + SD(trial_num,i)*10
                move_onset(trial_num,i) = cnt; 
                RT(trial_num,i) = move_onset(trial_num,i)/FS - cue_time(trial_num); %onsetとcueの差
                reac_flag = true; 
            end
            
        end
        
        %------------------ figure描画(rEMG,theta,alpha,beta) --------------------
        cue_plot = round(cue_time(trial_num)*FS);
        start = cue_plot + P_START*FS; 
        fin = start + RANGE*FS - 1;
    
%         time = t(1:5000);
        time = P_START:1/FS:P_END-1/FS;
    
        rEMG_plot = rEMG(start:fin);
    
        alpha_plot = alpha(start:fin);
        beta_plot = beta(start:fin);
        theta_plot = theta(start:fin);
        
        alpha_hil_plot = alpha_hil(start:fin);
        beta_hil_plot = beta_hil(start:fin);
    
        figure('Position',[1,1,WIDTH,HEIGHT])
    
        % rEMG
        subplot(4,1,1)
    
        plot(time,rEMG_plot,'linewidth',1.5)
        xlim([P_START,P_END])
        xline(0,'LineWidth',1.2)
        xline((move_onset(trial_num,i)-start)/FS + P_START,'-.','LineWidth',1.2)
    %     xlabel('time(s)')
%         ylabel('Amplitude(\muV)')

        title_RT = sprintf('rEMG (RT = %.3f)',RT(trial_num,i));

        title(title_RT,'FontWeight','bold')
    
        set(gca,'fontsize',10,'LineWidth', 0.7,'FontWeight','bold')
        
        % alpha
        subplot(4,1,2)
        plot(time,alpha_plot,'linewidth',1)
        hold on
        plot(time,alpha_hil_plot,'linewidth',1.5)
        xlim([P_START,P_END])
        ylim([-ceil(max(abs(alpha_plot))),ceil(max(abs(alpha_plot)))])
        xline(0,'LineWidth',1)
        xline((move_onset(trial_num,i)-start)/FS + P_START,'-.','LineWidth',1)
    %     xlabel('time(s)')
        ylabel('Amplitude(\muV)                         ','fontsize',15)
        title('alpha-band EEG','FontWeight','bold','fontsize',10)
    
        set(gca,'LineWidth', 0.7,'FontWeight','bold')
    
        % beta
        subplot(4,1,3)
        plot(time,beta_plot,'linewidth',1)
        hold on
        plot(time,beta_hil_plot,'linewidth',1.5)
        xlim([P_START,P_END])
        ylim([-ceil(max(abs(beta_plot))),ceil(max(abs(beta_plot)))])
        xline(0,'LineWidth',1)
        xline((move_onset(trial_num,i)-start)/FS + P_START,'-.','LineWidth',1)
%         xlabel('time(s)')
%         ylabel('Amplitude(\muV)')
        title('beta-band EEG','FontWeight','bold')
    
        set(gca,'fontsize',10,'LineWidth', 0.7,'FontWeight','bold')

                % theta
        subplot(4,1,4)
    
        plot(time,theta_plot,'linewidth',1.5)
        xlim([P_START,P_END])
        ylim([-ceil(max(abs(theta_plot))),ceil(max(abs(theta_plot)))])
        xline(0,'LineWidth',1)
        xline((move_onset(trial_num,i)-start)/FS + P_START,'-.','LineWidth',1)
        xlabel('time(s)')
%         ylabel('Amplitude(\muV)','fontsize',10)
        title('theta-band EEG','FontWeight','bold')
    
        set(gca,'fontsize',10,'LineWidth', 0.7,'FontWeight','bold')


    end
end
