% 32ch

% ch1:トルク
% ch2~6:EEG
%   ch2:Cz
%   ch3:
% ch31:EMG

fs = 1000;

defaultanswer = {'Ichikawa'};
subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
subject_name = char(subject(1));

[fname, pname] = uigetfile('*.mat','解析するデータ');
FP = [fname pname];
if fname == 0
    return;
end

load([pname fname]);

mod_cuestime = cuestime + 12.9;

% EMG
EMG = data(:,31);
a = zeros(9,7);
b = zeros(9,7);
for i = 1:9
    [b(i,:),a(i,:)] = butter(3,[i*50-1 i*50+1]/500,'stop');
    EMG = filtfilt(b(i,:),a(i,:),EMG);
end

% EEG α帯
% Wn1 = 8 - 1 / (fs/2);
% Wn2 = 15 + 1 / (fs/2);
% [a,b] = butter(2,[8-1 15+1]/500);
% alpha = filtfilt(a,b,data(:,2));

alpha = datafilter(data(:,2),8,15,fs);
% a_alpha = datafilter(data(:,3),8,15,fs);
% b_alpha = datafilter(data(:,4),8,15,fs);
% c_alpha = datafilter(data(:,5),8,15,fs);
% d_alpha = datafilter(data(:,6),8,15,fs);

% alpha = Cz_alpha - (a_alpha + b_alpha + c_alpha + d_alpha) / 4;

t = 0 : 1/fs : (length(alpha)-1)/fs;


move_onset = zeros(1,20);
count = 1;


for j = 1:length(t)
    if j >= mod_cuestime(i) 
        if abs(EMG) > 0.5 
            move_onset(i) = t(i);
            count = count + 1; 
            break
        end
    end
end


figure;
subplot(2,1,1);
plot(t,EMG,'linewidth',1.3);
xlim([0 length(alpha)/fs]);
xline(mod_cuestime);

subplot(2,1,2);
plot(t, alpha*100,'linewidth',1.3);
xlim([0 length(alpha)/fs]); 
xline(mod_cuestime);
%ylim([-20 20]);
% xticks((7:14:14*30));
% xticklabels((1:30));


function output1 = datafilter(DATA,cutoff,cutout,fs)
    % band-pass
    aa = 1;
    Wn1(aa,:) = (aa * cutoff - 1) / (fs/2) ;
    Wn2(aa,:) = (aa * cutout + 1) / (fs/2) ;
    [a,b] = butter(2,[Wn1(aa,:) Wn2(aa,:)]);
    DATA = filtfilt(a,b,DATA);
    output1 = DATA;
end
