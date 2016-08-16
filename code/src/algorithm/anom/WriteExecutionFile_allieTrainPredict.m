function WriteExecutionFile_allieTrainPredict(runinfo_fname, trainFile, predictDirectory, solverNum, c, windowSize, windowStride, numThreads)
% WriteExecutionFile_allieTrainPredict(runinfo_fname, trainFile, predictDirectory, solverNum, c)
% solverNum = 7 or 0 for logistic regression.
fid = fopen(runinfo_fname,'w');

B=1;

str_train = sprintf('-s %d -c %d -B %f',solverNum,c,B);

fprintf(fid,'commandLine=%s\n',str_train);
fprintf(fid,'inputFile=%s\n',trainFile);
fprintf(fid,'outputDirectory=%s\n', predictDirectory);
if ~isempty(windowSize)
    fprintf(fid, 'windowSize=%d\n',windowSize);
end
if ~isempty(windowStride)
    fprintf(fid, 'windowStride=%d\n',windowStride);
end
if ~isempty(numThreads)
fprintf(fid, 'numThreads=%d\n',numThreads);
end

fclose(fid);

end
