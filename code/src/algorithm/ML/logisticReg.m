function b = logisticReg(x,y,weights)

[b,dev,stats] = glmfit(x,[y ones(size(y))],'binomial','link','logit','constant','off','weights',weights);

%     % Debug
%     yfit = glmval(b,x,'logit','size',ones(size(y)),'constant','off');
%     xx = linspace(-1.5,2);
    %     yfit = glmval(b,xx,'logit');
    %     plot(x,y,'o',xx,yfit,'-')

end
