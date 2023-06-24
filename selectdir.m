% ディレクトリ選択

function [directory,files,subject_name] = selectdir()
    defaultanswer = {'mone'};
    subject = inputdlg({'subject'},'Input the answer',1,defaultanswer);
    subject_name = char(subject(1));
    
    directory = uigetdir();
    
    files = dir(fullfile(directory, 'random*.mat'));
end
