function b = Classifier(x,y,weights,classifierType)
% Each row of x is a new data point (each column = ).
% Each row of y is a label for each row of x
% Type: {'logistic' (default), 'linear'}

%% Check/Parse arguments
types = {'logistic','linear'};

if size(x,1) ~= size(y,1)
    error('Each row should be a point. (Transpose x and/or y)');
end

if nargin <= 3
    type = 1; % logistic
else
    if strcmpi(classifierType,types{1})
        type = 1;
    elseif strcmpi(classifierType,types{2})
        type = 2;
    else
        warning('Classifier type not recognized. Using logistic\n');
    end
end

%% Run classifier
if type==1
    b = logisticReg(x,y, weights);
elseif type == 2
    b = linearReg(x,y);
end

end
