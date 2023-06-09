% 2023/05/16

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

%% RT計算

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
    
    % EEG α帯
    EEG_alpha = datafilter(data,8,15,fs)*100;
    alpha = EEG_alpha(:,2) - (EEG_alpha(:,3) + EEG_alpha(:,4) + EEG_alpha(:,5) + EEG_alpha(:,6))/4;

%     alpha_all = vertcat(alpha_all,alpha);
    
    % β帯
    EEG_beta = datafilter(data,15,35,fs)*100;
    beta = EEG_beta(:,2) - (EEG_beta(:,3) + EEG_beta(:,4) + EEG_beta(:,5) + EEG_beta(:,6))/4;

%     beta_all(:,i) = beta;
    
    t = 0:1/fs:(length(alpha)-1)/fs;

    % EMGで判定(キューの直前3秒くらいの平均から+10SD(？))
    
    aveEMG = (EMG-mean(EMG))*1000; % 基線ずれ直す
    rEMG = abs(aveEMG); % 全波整流
    
%     rEMG_all(:,i) = rEMG;
    
    % キューの3秒前のrEMGの平均と標準偏差
    for trial_num = 1:20
        judge_start = round(cue_time(trial_num) * fs - 3000 + 1);
        judge_end = judge_start + 3000;
    
        [SD(trial_num,i),Mean(trial_num,i)] = std(rEMG(judge_start:judge_end));
    
        cnt = judge_end;
        reac_flag = false;
    
        while ~reac_flag
    
            cnt = cnt + 1;
            
            if rEMG(cnt) > Mean(trial_num,i) + SD(trial_num,i)*10
                move_onset(trial_num,i) = cnt/fs;
                RT(trial_num,i) = move_onset(trial_num,i) - cue_time(trial_num);
                reac_flag = true; 
            end
            
        end
    end

    % そのセットの中で1番RT長い試行
    [RTmax,RTmax_index] = min(RT(:,i));

    disp(RTmax)

    cue_plot = round(cue_time(RTmax_index)*fs);
    start = cue_plot - 3000;
    fin = start + 5000 - 1;

    time = t(1:5000);

    rEMG_plot = rEMG(start:fin);

    alpha_plot = alpha(start:fin);
    beta_plot = beta(start:fin);

    alpha_env = envelope(alpha,100,'peak');
    beta_env = envelope(beta,50,'peak');
    
    alpha_env_plot = alpha_env(start:fin);
    beta_env_plot = beta_env(start:fin);

    figure('Position',[1,400,400,400])

    subplot(211)

    plot(time,rEMG_plot,'linewidth',1.3)
    xlim([0 length(alpha_plot)/fs])
    xline((cue_plot - start)/fs,'LineWidth',1)
    xline(move_onset(RTmax_index,i)-start/fs,'-.','LineWidth',1)
%     xlabel('time(s)')
    ylabel('Amplitude(\muV)')
    title('rEMG','FontWeight','bold')

    set(gca,'fontsize',17,'LineWidth', 0.7,'FontWeight','bold')

    subplot(212)
    plot(time,alpha_plot,'linewidth',1.3)
    hold on
    plot(time,alpha_env_plot,'linewidth',2)
    xlim([0 length(alpha_plot)/fs])
    ylim([-5,5])
    xline((cue_plot - start)/fs,'LineWidth',1)
    xline(move_onset(RTmax_index,i)-start/fs,'-.','LineWidth',1)
    xlabel('time(s)')
    title('EEG','FontWeight','bold')
%     xlabel('time(s)')
    ylabel('Amplitude(\muV)')
%     title('EEG')

    set(gca,'fontsize',17,'LineWidth', 0.7,'FontWeight','bold')

%     subplot(313)
%     plot(time,beta_plot,'linewidth',1.3)
%     hold on
%     plot(time,beta_env_plot,'linewidth',2)
%     xlim([0 length(alpha_plot)/fs])
%     ylim([-5,5])
%     xline((cue_plot - start)/fs,'LineWidth',1)
%     xline(move_onset(RTmax_index,i)-start/fs,'-.','LineWidth',1)
%     xlabel('time(s)','FontWeight','bold')
%     ylabel('Amplitude(\muV)','FontWeight','bold')
%     title('beta-band EEG','FontWeight','bold')
% 
%     set(gca,'fontsize',14,'LineWidth', 0.7)


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

%% データ切り出してplot

% time = t(1:5000);
% 
% % データのソートと上位5つの取得
% [RT_sort, RT_index] = sort(RT(:)); % 行列をベクトルに変換し、降順にソート
% 
% short = RT_sort(1:4);
% short_index = RT_index(1:4);
% 
% long = RT_sort(numel(RT_sort)-3:numel(RT_sort)); % 上位5つの値を取得
% long_index = RT_index(numel(RT_sort)-3:numel(RT_sort)); % 上位の値に対応するインデックスを取得
% 
% % 元の行と列の情報の取得
% [short_num_row, short_num_col] = size(RT);
% [short_index_row, short_index_col] = ind2sub([short_num_row, short_num_col], short_index);
% 
% [long_num_row, long_num_col] = size(RT);
% [long_index_row, long_index_col] = ind2sub([long_num_row, long_num_col], long_index);
% 
% for i = 1:numel(long)
%     if isempty(files)
%         disp('ファイルが見つかりませんでした。')
%         disp(i)
%         disp(j)
%     else
%         for j = 1:numel(files)
%             filename = files(j).name; % ファイル名を取得
%             if contains(filename, '3') % ファイル名に '3' が含まれるか判定
%                 filePath = fullfile(select_dir, filename);
%     
%                 load(filePath)
% 
%                 plot_start = round(cue_all(short_index_row(i),short_index_col(i))*fs - 3000);
%                 plot_end = plot_start + 4999;
%                 
% 
% %                 top_alpha = alpha(:);
%                 
%                 break % 条件に一致する最初のファイルをloadした後、ループを終了
%             end
%         end
%     end
% end



%% 脳波のバンドパス

function output1 = datafilter(DATA,cutoff,cutout,fs)
    aa = 1;
    Wn1(aa,:) = (aa * cutoff - 1) / (fs/2);
    Wn2(aa,:) = (aa * cutout + 1) / (fs/2);
    [a,b] = butter(2,[Wn1(aa,:) Wn2(aa,:)]);
    DATA = filtfilt(a,b,DATA);
    output1 = DATA;
end

