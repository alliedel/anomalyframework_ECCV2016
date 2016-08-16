function defaults = DefaultPars()
% Note: this function now controls which variables are going to be read
% into the input parser!

% etc
defaults.visualize = 0;
defaults.rawFeatsOnly = 0;
defaults.finalFeatsOnly = 0;

% Paths
defaults.pathToTrainPredict = 'code/src/utils/submodules/liblinear-multicore-2.01/allie';
defaults.pathToVideo = '';
defaults.pathToTrainVideoDir = '';
defaults.finalFeatMATfile='';
defaults.fn_libsvm='';
defaults.pathToGndTruth=''; % not used anymore.
defaults.pathToGroundTruth = '';
defaults.dictionaryMATfile='';
defaults.rawFeatMATfile='';
defaults.BOVfile = ''; %
defaults.anomDetectRoot = '.'; % Change if you're moving your script (should point to the uppermost folder)
defaults.fname = ''; % should be a function handle if displayPars.display = 1.
defaults.processId = '';
defaults.videoSize = [];

% Feature parameters
% --- Raw: general
defaults.featType = 'mine'; % 'mine'
defaults.startFrame = 1;
defaults.endFrame = inf;
defaults.rawFeatType = 'DT'; % 'cuboidBin'
defaults.cuboidFeatsFile = '';
% --- Raw: Blocks
%          Divide each frame up into 'blocks'; treat each block as a frame
defaults.frameToBlocks = 0; % 1: should divide each frame up into 'blocks';
defaults.blockSize = [0.5 0.5 1];
defaults.blockStride = [1 1 1];
% --- Raw: DT
defaults.W = ''; % DT features
defaults.maxn_Cub = 100000;
defaults.grouping = 'none';
defaults.firstRandom = 0;
% --- Raw: Liu
defaults.liu_imresize = [120 160];
defaults.liu_patchWin = 10; % 3D patch spatial size                                                                      
defaults.liu_tprLen = 5;    % 3D patch temporal length                                                                   
defaults.liu_PCAdim = 100;  % PCA Compression dimension                                                                  
defaults.liu_MT_thr = 5;    % 3D patch selecting threshold                                                               
defaults.liu_srs = 5;       % spatial sampling rate in trainning video volume                                            
defaults.liu_trs = 2;       % temporal sampling rate in trainning video volume                                           
defaults.liu_numEachVol = 3000;

% --- Raw: freq
defaults.downsampleSize = [1 1]; % reduce each image to a pixel; [M N]
defaults.fft_window = 15; % number of frames in an FFT window

% --- Postprocess
defaults.K = 50; %whether to display LCA results as lca_function runs
defaults.BOVtype = 'hard'; % 'none' -- don't combine!!
defaults.whitenBeforeKmeans = 0;
defaults.whitenAfterKmeans = 0;
defaults.whitenBeforeAnomalyDetect = 1;
defaults.kPCARawFeats=[];
defaults.kPCAFinalFeats=40;
defaults.normHist = 'none'; %'l1'

% - Anomaly detection Parameters

defaults.methodType = 'mine'; % 'oneclasssvm'

% -- Default: My method
defaults.splitType = 'slidingWindowOnline'; % See GenerateSplits for all methods
defaults.S = 8; % numSplits
defaults.windowSz = 100;
defaults.windowStride = 1;
defaults.avgOverSplits = 'mean'; %'mean', 'median'
defaults.shuffleSize = 1; % 'interval', 'stride', 'window' % window is 1/2 interval
defaults.nShuffles = 0; % 
defaults.dictTrain = 'all';
defaults.regularization = 'none';
defaults.CV = 'resubstitution';
defaults.lambda = 0.01;
defaults.alpha = 1E-30;
defaults.logitMethod = 'liblinear';
% Bonus feature: classify each feature independently and sum (rather than classifying each frame independently)
defaults.ScoreEach = 'frame'; %'frame','interestpoint'

%liusparse
defaults.liusparse_dim = 20; 
defaults.liusparse_thr = 0.1;
defaults.liusparse_ThrTest = 0.2;
defaults.liusparse_dicttraincap = '';
defaults.liurelearndictionary = 1;

% -- Strawman: one-class SVM
defaults.nu = 1e-2;
defaults.sigma = 1e-2;
defaults.lam = 1e-2;
defaults.eta = 5e-2;
defaults.t = 1;
defaults.tau = 1000;
defaults.rho = 1;
defaults.beta = 1e-1;
defaults.alpha = 1e-1;
defaults.kernel_type = 'gaussian'; % poly, uniform
defaults.sigma_ocn = 0.001;
defaults.c = 1;
defaults.d = 2;
defaults.stopmodelframe = 1e1000;

% - Etc
defaults.numThreads = 50; % used by allie.c (new version of train)

end
