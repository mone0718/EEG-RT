% 2023/06/24
% figureを画像にまとめる

clear
close all

directory = 'figure_all';
fig_list = dir(fullfile(directory, '*.png'));
fig_num = numel(fig_list);

figs_image = 4; % ひとつの画像にいくつfigure入れるか
image_num = ceil(fig_num / figs_image); % 必要な画像の数

figs = cell(image_num, 1); % ?

for i = 1:image_num
    start_idx = (i - 1) * figs_image + 1;
    end_idx = min(i * figs_image, fig_num);
    
    figs{i} = cell(end_idx - start_idx + 1, 1); % フィギュア内の画像を格納するセル配列を作成
    
    % 画像を読み込んでセル配列に格納
    for j = start_idx:end_idx
        image_path = fullfile(directory, fig_list(j).name); % 画像ファイルのパスを作成
        figs{i}{j - start_idx + 1} = imread(image_path); % 画像を読み込んでセル配列に格納
    end
end

% フィギュアごとに画像をまとめて表示
for i = 1:image_num
    resize_images = cellfun(@(x) imresize(x, [500, 500]), figs{i}, 'UniformOutput', false);

    output_name = sprintf('img%d.png',i);
    
    montage(resize_images, 'Size', [2 2])
    saveas(gcf, fullfile('figure_sub', output_name))
end
