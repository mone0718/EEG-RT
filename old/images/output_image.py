#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jun 25 00:59:37 2023

@author: mone
"""

import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import glob

# PDFファイルを作成
pdf = PdfPages("graphs.pdf")

# PNGファイルのパスを取得
png_files = glob.glob("/Users/mone/Documents/MATLAB/EEG-RT/figure_all/*.png")

# グラフをページに追加
page_count = 1

# 4枚ごとに新しいページに切り替え
for i, png_file in enumerate(png_files, start=1):
    # グラフ画像を読み込み
    img = plt.imread(png_file)

    # 画像をページに追加
    plt.imshow(img)
    plt.axis('off')  # 軸を非表示にする（任意）
    plt.title(f"Page {i}")
    pdf.savefig()
    plt.clf()  # グラフをクリア

# PDFを閉じる
pdf.close()
