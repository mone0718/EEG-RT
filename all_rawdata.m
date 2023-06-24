% 2023/06/19
% セットごと 生波形見る用

clear

[directory,files,subject_name] = selectdir;

%% EMG,theta,alpha,beta セット

close all

FS = 1000;

NON_VALID = 0.7;

move_onset = zeros(20,numel(files));
RT = zeros(20,numel(files));

SD = zeros(20,numel(files));
Mean = zeros(20,numel(files));

cue_all = zeros(20,numel(files));

alphahil_cue = zeros(20,numel(files));
betahil_cue = zeros(20,numel(files));

alpha_cue = zeros(20,numel(files));
beta_cue = zeros(20,numel(files));
theta_cue = zeros(20,numel(files));


for i = 1:numel(files)

    filePath = fullfile(directory,files(i).name);
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

    % EEG バンドパス
    % θ帯
    EEG_theta = datafilter(data,4,8,FS)*100;
    theta = EEG_theta(:,2) - (EEG_theta(:,3) + EEG_theta(:,4) + EEG_theta(:,5) + EEG_theta(:,6))/4;
    
    % α帯
    EEG_alpha = datafilter(data,8,12,FS)*100;
    alpha = EEG_alpha(:,2) - (EEG_alpha(:,3) + EEG_alpha(:,4) + EEG_alpha(:,5) + EEG_alpha(:,6))/4;
    
    % β帯
    EEG_beta = datafilter(data,13,35,FS)*100;
    beta = EEG_beta(:,2) - (EEG_beta(:,3) + EEG_beta(:,4) + EEG_beta(:,5) + EEG_beta(:,6))/4;

    % ヒルベルト変換
    alpha_hil = abs(hilbert(alpha));
    beta_hil = abs(hilbert(beta));

    % 基線ずれ
    alphahil_base = alpha_hil - mean(alpha_hil);
    betahil_base = beta_hil - mean(beta_hil);

    % 包絡線の位相 α,β
    alphahil_phase = rad2deg(angle(hilbert(alphahil_base)));
    betahil_phase = rad2deg(angle(hilbert(betahil_base)));

    % 波形そのものの位相
    alpha_phase = rad2deg(angle(hilbert(alpha)));
    beta_phase = rad2deg(angle(hilbert(beta)));
    theta_phase = rad2deg(angle(hilbert(theta)));


    % EMGで判定(キューの直前3秒くらいの平均から+10SD)
    aveEMG = (EMG-mean(EMG))*1000; % 基線ずれ直す
    rEMG = abs(aveEMG); % 全波整流

    for trial_num = 1:20
        cue_cnt = round(cue_time(trial_num) * FS); %キューのタイミング

        alphahil_cue(trial_num,i) = alphahil_phase(cue_cnt);
        betahil_cue(trial_num,i) = betahil_phase(cue_cnt);

        alpha_cue(trial_num,i) = alpha_phase(cue_cnt);
        beta_cue(trial_num,i) = beta_phase(cue_cnt);
        theta_cue(trial_num,i) = theta_phase(cue_cnt);

        judge_start = cue_cnt - 500; %そこから0.5秒前
        
        % 標準偏差と平均
        [SD(trial_num,i),Mean(trial_num,i)] = std(rEMG(judge_start:cue_cnt));
    
        cnt = cue_cnt; %キューのタイミング(使い回し)
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
    end

%% figure描画

    t = 0:1/FS:(length(alpha)-1)/FS;

    figure
    ax1 = subplot(4,1,1);
    plot(t,rEMG)
    xlim([0 length(alpha)/FS])
    xline(cue_time)

    xline(move_onset(:,i)/FS,'-.')
    
%     title_RT = sprintf('RT = %.3f',RT(:,i));
    title('rEMG')
    
    ax2 = subplot(4,1,2);
    plot(t,alpha)
    hold on
    plot(t,alpha_hil)
    xlim([0 length(alpha)/FS])
    xline(cue_time)
    xline(move_onset(:,i)/FS,'-.')
    ylim([-ceil(max(abs(alpha))),ceil(max(abs(alpha)))])
    title('alpha')
    
    ax3 = subplot(4,1,3);
    plot(t,beta)
    hold on
    plot(t,beta_hil)    
    xlim([0 length(alpha)/FS])
    xline(cue_time)
    xline(move_onset(:,i)/FS,'-.')
    ylim([-ceil(max(abs(beta))),ceil(max(abs(beta)))])
    title('beta')
    
    ax4 = subplot(4,1,4);
    plot(t,theta)
    xlim([0 length(alpha)/FS])
    xline(cue_time)
    xline(move_onset(:,i)/FS,'-.')
    xlabel('time(s)')
%     title('theta')

    linkaxes([ax1,ax2,ax3,ax4],'x')

end

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

figure(1);
clf(gcf)

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

figure(2);

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

