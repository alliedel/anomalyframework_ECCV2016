function b = linearReg(x,y)

[b,dev,stats] = glmfit(x,[y ones(size(y))],'binomial','link','identity','constant','off');

%     % Debug
%     yfit = glmval(b,x,'logit','size',ones(size(y)),'constant','off');

end
