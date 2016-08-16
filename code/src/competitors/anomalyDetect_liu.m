function an = anomalyDetect_liu(pars)

% Dictionary learning
load(pars.paths.files.liu_trainFeatsPCA);
if exist(pars.paths.files.liusparsedictionary,'file')==0 || pars.liurelearndictionary
  fprintf('Building sparse dictionary\n');
  dicttraincap = pars.liusparse_dicttraincap;
    if ~isempty(dicttraincap)
        feaMatPCA = feaMatPCA;
        N = size(feaMatPCA,2);
        subidxs = linspace(1,N,min(dicttraincap,N));
        feaMatPCA = feaMatPCA(:,round(subidxs));
    end
    D = sparse_combination(feaMatPCA, pars.liusparse_dim, pars.liusparse_thr);
    for ii = 1 : length(D);
       R(ii).val = D(ii).val*inv(D(ii).val'*D(ii).val)*D(ii).val' - eye(size(D(ii).val,1)); % R matrix in Eq. (13).  
    end
    save(pars.paths.files.liusparsedictionary,'D','R');
else
    load(pars.paths.files.liusparsedictionary);
end

% Reconstruction error
load(pars.paths.files.finalFeatMATfile); feaPCA = fn;
Err = recError(feaPCA', R, pars.liusparse_ThrTest);
an = Err;

save(fullfile(pars.paths.folders.pathToTmp,'an.mat'),'an');

end
