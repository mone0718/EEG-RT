% 2023/03/22

% ch1:トルク
% ch2~6:EEG
%   ch2:Cz
%   ch3:
% ch10:EMG


% EMG LP = 500 Hz, HP = 1 Hz
% EEG LP = 100 Hz, HP = 0.5 Hz

% EMG Sens HI (x1000)
% EEG Sens Low (x1000)
% (多分)


%サンプリング周波数
fs = 1000;

%被験者名
defaultanswer = {'Ichikawa'};
subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
subject_name = char(subject(1));

%解析するデータ（matファイル）を選択し、読み込む
[fname, pname] = uigetfile('*.mat','解析するデータを選択してください');
FP = [fname pname];
if fname == 0
    return;
end

%fnameがファイル名／pnameはファイルのある場所（ディレクトリ）
load([pname fname]);

%フィルタリング
data_filtered = data;
a = zeros(9,7);
b = zeros(9,7);
for i = 1:9
    [b(i,:),a(i,:)] = butter(3,[i*50-1 i*50+1]/500,'stop');
    data_filtered = filtfilt(b(i,:),a(i,:),data_filtered);
end

%EEGローパス 100Hz
[b_low,a_low] = butter(3,100/500,"low");
data_low_filtered = filtfilt(b_low,a_low,data_filtered);

%計測データの定義
%EMGは1000μV→1Vなので、マイクロボルト単位に変換（1000倍）
%EEGは100μV→1Vなので、マイクロボルト単位に変換（100倍）
Force = data_filtered(:,1);
EMG = data_filtered(:,10)*1000;
EEG_Cz = data_low_filtered(:,2)*100;
EEG_FCz = data_low_filtered(:,3)*100;
EEG_C1 = data_low_filtered(:,4)*100;
EEG_CPz = data_low_filtered(:,5)*100;
EEG_C2 = data_low_filtered(:,6)*100;


% Force = data(:,1);
% EMG = data(:,10); %ここの*1000
% EEG_Cz = data(:,2)*100;
% EEG_FCz = data(:,3)*100;
% EEG_C1 = data(:,4)*100;
% EEG_CPz = data(:,5)*100;
% EEG_C2 = data(:,6)*100;


%EMGのトレンド除去（平均を引く）
EMG = (EMG-mean(EMG));
%全波整流
rEMG = abs(EMG);

%EEGのトレンド除去（detrend関数を用いる）
%【課題①】detrendを用いてそれぞれのchデータのトレンド除去をしてみよう／detrend前後のシグナルを比較してみよう
dEEG_Cz = detrend(EEG_Cz);
dEEG_FCz = detrend(EEG_FCz);
dEEG_C1 = detrend(EEG_C1);
dEEG_CPz = detrend(EEG_CPz);
dEEG_C2 = detrend(EEG_C2);

%ラプラシアン導出
%Czの脳波から残り4chの脳波の平均をひく
EEG = dEEG_Cz - (dEEG_FCz + dEEG_CPz + dEEG_C1 + dEEG_C2) / 4;
% EEG = EEG_Cz - (EEG_FCz + EEG_CPz + EEG_C1 + EEG_C2) / 4;


% 時間行列を作成
time = 0 : 1/fs : length(Force)/fs-1/fs;

% グラフ描画
figure('Position',[1 1 400 800]);
subplot(4,1,1);
plot(time,Force,'LineWidth',1.5);
ylabel('Force (V)','FontName','Arial','Fontsize',12);
xlabel('time (s)','FontName','Arial','Fontsize',12);

subplot(4,1,2);
plot(time,EMG,'LineWidth',1.5);
ylabel('EMG (\muV)','FontName','Arial','Fontsize',12);
xlabel('time (s)','FontName','Arial','Fontsize',12);

subplot(4,1,3);
plot(time,rEMG,'LineWidth',1.5);
ylabel('rEMG (\muV)','FontName','Arial','Fontsize',12);
xlabel('time (s)','FontName','Arial','Fontsize',12);

subplot(4,1,4);
plot(time,EEG,'LineWidth',1.5);
ylabel('EEG (\muV)','FontName','Arial','Fontsize',12,'LineWidth',2);
xlabel('time (s)','FontName','Arial','Fontsize',12);
 
