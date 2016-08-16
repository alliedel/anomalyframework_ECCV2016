function pars = parseArgs_anomalyDetection(varargin)

defaults = DefaultPars();

p = inputParser;
fs = fieldnames(defaults);
for i = 1:length(fs)
    p.addOptional(fs{i},defaults.(fs{i}));
end

p.KeepUnmatched = false;
try
    parse(p,varargin{:});
catch ME
    fprintf(['Check to see if the variable you entered is in DefaultPars.m.' ...  
    'If not, add it there and this will work.'])
    rethrow(ME);
end
pars = p.Results;

pars.processId = sprintf('%.5d',randi(10000));

%% Generate string with all arguments used (except filename)
pars.argsString = ConvertToParsString( varargin{:} );
pars.paths = GetPaths_anomalyDetection(pars); % Also does mkdir stuff

CheckInputExistence_anomalyDetection(pars)

% Create the directories in the file system
MkdirPaths_anomalyDetection(pars.paths);

end
