% 脳波のバンドパス

function output1 = datafilter(DATA,cutoff,cutout,fs)
    aa = 1;
    Wn1(aa,:) = (aa * cutoff - 1) / (fs/2);
    Wn2(aa,:) = (aa * cutout + 1) / (fs/2);
    [a,b] = butter(2,[Wn1(aa,:) Wn2(aa,:)]);
    DATA = filtfilt(a,b,DATA);
    output1 = DATA;
end