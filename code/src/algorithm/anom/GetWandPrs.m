function [ws, prs, w_scores] = GetWandPrs(ys,fn, pars) % We assume each row is a feature.
S = whos(m_ys,'ys').size(1);
D = whos(m_fn,'fn').size(2);
N = whos(m_fn,'fn').size(1);

if strcmpi(pars.logitMethod,'liblinear')
    prs = single(NaN(S,N));
    w_scores=single(zeros(S,3));

    c=1/pars.lambda; % Decrease c to regularize more ( decrease norm(model.w) )
    B=1; % Bias term exist?
    % Initialize

    if(B)
      ws = single(zeros(S,D+1));
     else
      ws = single(zeros(S,D));
    end
    M = NaN*ones(S,1);
    
    rng('default'); rng('shuffle');
    for s = 1:S % For each split
        fprintf('===================%d/%d=================',s,S)
        y = m_ys.ys(s,:)'; % split
        idxs=~isnan(y);
        idxs = find(idxs);
        idxs = idxs(randperm(length(idxs)));
        x=fn(idxs,:);
        y = y(idxs);
        % Estimate the parameter wk of logistic classifier from {fn} and {y}
        n = sum(~isnan(y));
        w0=sum(y==1)/n; % Weight of class 0 = inv freq of class 0
        w1=sum(y==0)/n; % Weight of class 1 = inv freq class 1

        model = train(y, sparse(double(x)), sprintf('-s 7 -c %d -w0 %g -w1 %g -B %f',c,w0,w1,B));
        [predict_label, accuracy, dec_values] = predict(y, sparse(double(x)), model, '-b 1'); % test the training data
        pr = dec_values(:,2);
        w = model.w;
        % Accumulate helper variables
        prs(s,idxs) = single(pr);
        ws(s,:) = single(w);
        w_scores(s,:)=accuracy;

    end %for each split
elseif strcmpi(pars.logitMethod,'matlabglm')
    
    prs = zeros(S,N);                             
    ws = zeros(S,D);                                                                                                 

    % Initialize                                                                                                         
    w_scores = zeros(1,S);                                                                                               
    for s = 1:S % For each split  
        
        fprintf('*********s=%d of %d\n',s,S);
        y = ys(s,:)'; % split                     
        % Estimate the parameter wk of logistic classifier from {fn} and {y}                                             
        wts = NaN(size(y));
        numzeros = sum(y==0);
        numones = sum(y==1);
        % Previous method (phd2)
        % wts(y==0) = 1; % TODO: THIS IS WRONG!
        % wts(y==1) = numzeros/numones; % TODO: THIS IS WRONG!
        % New method (phd3)
	wts(y==0) = numones/(numzeros+numones);
        wts(y==1) = numzeros/(numzeros+numones);

        % Shuffle
	idxs = ~isnan(y);
	idxs = find(idxs);
	idxs = idxs(randperm(length(idxs)));
        w = Classifier(fn(idxs,:), y(idxs), wts(idxs));
        % w = Classifier(fn, y(:), wts);

        pr = NaN(1,N);


        for i = 1:N
            % Estimate the conditional probability P(y = +1 | fn;wk) and median val Mk 
            pr(i) = 1./(1+exp(-1.*w'*fn(i,:)'));
        end
        ws(s,:) = w;
        prs(s,:) = pr;
    end %for each split                                                                                                  
    w_scores = [];
else
    error('Method %s not implemented',pars.logitMethod)
end

end
