function an3 = an_1dTo3d(anfile, locsfile, pars)

load(anfile,'an');       % produces an
load(locsfile,'LocV3');     % produces LocV3
%% Parameters 
% params.srs = 5;       % spatial sampling rate in trainning video volume
% params.trs = 2;       % temporal sampling rate in trainning video volume 
% params.PCAdim = 100;  % PCA Compression dimension
% params.MT_thr = 5;    % 3D patch selecting threshold 

H = pars.liu_H;
W = pars.liu_W; 
patchWin = pars.liu_patchWin;
tprLen = pars.liu_tprLen; 
BKH = pars.liu_BKH;
BKW = pars.liu_BKW;

addpath('functions')
addpath('data')

%% Loading and saving my results
% resultdir = '/home/allie/Documents/anomalyframework_github/data/results/2016_08_15/14_35_30/03_methodType_mine_lambda_10_windowSz_10_windowStride_10_nShuffles_10_fn_libsvm_03_pW_10_tprLen_5_MTthr_5_srs_5_trs_2_nEV_3000_PCAdim_100/';
% load(fullfile(resultdir,'an.mat'));
% load(fullfile(resultdir,'pars.mat'));
load(strrep(pars.paths.files.fn_libsvm,'.train','.mat'));
sig = an./(1-an);
Err = sig(:)';
T = max(LocV3(:,3));
AbEvent = zeros(BKH, BKW, T);
for ii = 1 : length(Err)
    AbEvent(LocV3(1,ii),LocV3(2,ii),LocV3(3,ii)) =  Err(ii);
end
AbEvent3 = smooth3( AbEvent, 'box', 5);
plot(AbEvent3(:));
