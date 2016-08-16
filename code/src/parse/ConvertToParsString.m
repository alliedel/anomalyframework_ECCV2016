function [ argsString ] = ConvertToParsString( varargin )
%CONVERTTOPARSSTRING Summary of this function goes here
%   Detailed explanation goes here

argsString = '';
fnameFlag = 0;
fileFlag = 0;
cuboidSzFlag = 0;
usefilenameonlyFlag = 0;
for i = 1:length(varargin)
    %% Shortening some things
    if fileFlag==1
        fileFlag = 0;
        continue;
    elseif strcmpi(varargin{i},'slidingWindowOnline')
        argsString = sprintf('%s_%s',argsString, 'SWO');
        continue;
    end
    if strcmpi(varargin{i},'slidingWindowOnlineOld')
        argsString = sprintf('%s_%s',argsString, 'SWOO');
        continue;
    end
    if strcmpi(varargin{i},'regressionIntervalWeightType')
        argsString = sprintf('%s_%s',argsString, 'RIWT');
        continue;
    elseif any(strcmpi(varargin{i},{'anomDetectRoot','pathToTrainVideos','pathToTrainVideoDir'}))
        fileFlag = 1;
        continue;
    elseif strcmpi(varargin{i},'cuboidSz')
        argsString = sprintf('%s_%s',argsString, 'cuboidSz');
        cuboidSzFlag = 1;
        continue
    elseif strcmpi(varargin{i},'fn_libsvm')
        argsString = sprintf('%s_%s',argsString, 'fn_libsvm');
        usefilenameonlyFlag = 1;
        continue
    %% Done shortening things(?)
    elseif any(strcmpi(varargin{i},{'fname', 'pathToVideo','pathToGndTruth','pathToGroundTruth'}))
        fnameFlag = 1;
        continue;
    elseif usefilenameonlyFlag
        [~,zz,~] = fileparts(varargin{i});
        argsString = sprintf('%s_%s',argsString, zz);
        usefilenameonlyFlag = 0;
        continue;
    elseif fnameFlag
        fnameFlag = 0;
        continue;
    elseif fileFlag
        % Note:  I HAD TO THROW AWAY THE FILE ARGUMENTS!!! BAD, I KNOW, BUT
        % MATLAB HATES LONG FILENAMES...
%          [PATHSTR,NAME,EXT] = fileparts(varargin{i});
%         argsString = sprintf('%s_%s',argsString, NAME);
        fileFlag = 0;
        continue;
    elseif cuboidSzFlag
        cuboidSzFlag = 0;
        if isnumeric(varargin{i}) && length(varargin{i}) == 3
            argsString = sprintf('%s_%d_%d_%d',argsString, varargin{i}(1), varargin{i}(2), varargin{i}(3));
        else
            error('cuboidSz is incorrect\n');
        end
    elseif isnumeric(varargin{i})
        if length(varargin{i}) == 1
            argsString = sprintf('%s_%s',argsString, num2str(varargin{i}));
        else
            if strcmpi(varargin{i-1},'cuboidSlideMults')
                argsString = sprintf('%s_%s_%.3g_%.3g',argsString,'mult',varargin{i}(1),varargin{i}(3));
            elseif strcmpi(varargin{i-1},'downsampleSize')
                argsString = sprintf('%s_%s_%.3gx%.3g',argsString,'downsampleSize',varargin{i}(1),varargin{i}(2));
            elseif strcmpi(varargin{i-1},'blockSize')
                argsString = sprintf('%s_%.3gx%.3gx%.3g',argsString,varargin{i}(1),varargin{i}(2),varargin{i}(3));
            elseif strcmpi(varargin{i-1},'blockStride')
                argsString = sprintf('%s_%.3gx%.3gx%.3g',argsString,varargin{i}(1),varargin{i}(2),varargin{i}(3));
            elseif strcmpi(varargin{i-1},'videoSize')
                argsString = sprintf('%s_%.3gx%.3gx%.3g',argsString,varargin{i}(1),varargin{i}(2),varargin{i}(3));
            else
                error('I don''t know how to handle arbitrary vectors of values\n');
            end
        end
    else
        if ~isempty(regexp(varargin{i},'\w*file\w*','match'))
            fileFlag = 1;
        end
        argsString = sprintf('%s_%s',argsString, varargin{i});
    end
end

end

