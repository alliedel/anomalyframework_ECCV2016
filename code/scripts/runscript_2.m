function runscript(volnum)
% As is, this uses the 'default' set of aparameters in Configure.m to compute
% anomalies.  The test video is 03 in the Avenue Dataset.  Features were
% precomputed.

% volnum: 1,...,21 : 21 = number of test videos in Avenue
if ~exist('volnum','var')
    volnum = 3;
end

% ==== Parameters / User Input
feats_libsvm = '~/Documents/videofeatures_github/data/input/features/Avenue/03/03_pW_10_tprLen_5_MTthr_5_srs_5_trs_2_nEV_3000_PCAdim_100.train';
videoname = sprintf('%02d',volnum); % used as an identifier; gets included in all the filenames the code produces
CONFIGSTRING = 'default';
diary debug_runscript.txt
rootpth = AbsolutePath('../../'); % Where is the root directory? Usually we are running this from code/scripts.




% ==== Do not change anything below unless you know what you're doing.

% Add paths
addpath(genpath(fullfile(rootpth,'code','src')));
% Set parameters (check code/src/DefaultPars.m for options)
parsCell = Configure(CONFIGSTRING,feats_libsvm,videoname);

tags.datestring = datestr(now,'yyyy_mm_dd');
tags.timestring = datestr(now,'HH_MM_SS');
datetimestr = sprintf('%s_%s',tags.datestring,tags.timestring);
save(['parsCells/parsCell_' datetimestr '.mat'],'parsCell'); % So you can see where your results were saved.
for i = 1:(length(parsCell))
    pars = parsCell{i};
    wrap_DetectAnomalies(pars);
    fprintf('Anomaly ratings file written to %s\n', ...
	    fullfile(pars.paths.folders.pathToResults,'an.mat'));
end
fprintf('Done\n');

end
