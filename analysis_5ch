% 2023/4/1
% α帯、β帯とその包絡線

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

% α帯
Wn1 = 8 - 1 / (fs/2);
Wn2 = 15 + 1 / (fs/2);
[a,b] = butter(2,[Wn1 Wn2]);
alpha = filtfilt(a,b,data());


