function b = logisticReg(x,y,weights,pars)

  if strcmpi(pars.regularization,'lasso')
  fprintf('***********Lasso\n')
   % Note you need the glmnet package in global/gentools for this to work.
%   b = cv.glmnet(x,y,family='binomial');
   [b, fitinfo] = lassoglm(x,y,'binomial','link','logit', 'Alpha', pars.alpha, 'Lambda',pars.lambda,'Standardize', false, 'CV', pars.CV);
  else
    [b,dev,stats] = glmfit(x,[y ones(size(y))],'binomial','link','logit','constant','off','weights',weights);
  end
%     % Debug
%     yfit = glmval(b,x,'logit','size',ones(size(y)),'constant','off');
%     xx = linspace(-1.5,2);
%     yfit = glmval(b,xx,'logit');
%     plot(x,y,'o',xx,yfit,'-')

end
