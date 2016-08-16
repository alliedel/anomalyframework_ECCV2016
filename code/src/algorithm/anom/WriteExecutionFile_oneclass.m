function WriteExecutionFile_oneclass(runinfo_fname, ...
    featsfile, outfile, ...
    nu, lam, eta, t, tau, rho, beta, ...
    alpha, kernel_type, c, d, sigma_ocn, stopmodelframe)
% WriteExecutionFile_oneclass(runinfo_fname, featsfile, anfile, nu, lam, eta, t, tau, rho, beta, alpha, kernel_type, c, d)
% outfile = anfile
varstoset = {'featsfile','outfile','nu','lam','eta','t','tau','rho', ...
    'beta','alpha','kernel_type','c','d','sigma_ocn','stopmodelframe'};

fid = fopen(runinfo_fname,'w');
fprintf(fid,'[DEFAULT]\n');
for i = 1:length(varstoset)
    val = eval(varstoset{i});
    if isnumeric(val) && isscalar(val)
       fprintf(fid,'%s=%.3g\n',varstoset{i}, val);
    elseif ischar(val)
       fprintf(fid,'%s=%s\n', varstoset{i}, val);
    else
	error('I don''t know how to handle this case\n');
    end
end

fclose(fid);

end
