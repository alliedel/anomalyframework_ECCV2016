function [y,gt] = ConvertGtAnToSameForm(an3, volLabel, upsize_to_gt, gttype)

[Hs, Ws] = size(volLabel{1});

switch gttype
    case 'pixel'

    if upsize_to_gt % takes FOREVER
        vecvsn_gt = cell2mat(volLabel); vecvsn_gt = vecvsn_gt(:);
        sig = NaN(size(vecvsn_gt));
        size_each = Hs*Ws;
        sig_idx = 1;
        for ii = 1:size(an3,3)
            upsized = imresize(an3(:,:,ii) ,[Hs, Ws], 'bilinear');
            sig(sig_idx:(sig_idx + size_each - 1)) = upsized(:);
            sig_idx = sig_idx + size_each;
        end
    else
        [M_, N_, ~] = size(an3);
        vecvsn_gt = NaN(M_*N_*length(volLabel),1);
        gt_idx = 1;
        size_each = M_*N_;
        for ii = 1:length(volLabel)
            downsized = imresize(volLabel{ii},[M_,N_],'bilinear');
            vecvsn_gt(gt_idx:(gt_idx + size_each-1)) = downsized(:);
            gt_idx = gt_idx + size_each;
        end
        sig = NaN(size(vecvsn_gt));
        sig_idx = 1;
        for ii = 1:size(an3,3);
            regsize = an3(:,:,ii);
            sig(sig_idx:(sig_idx+size_each-1)) = regsize(:);
            sig_idx = sig_idx + size_each;
        end
    end
    
    case {'frameFromPixelSoft','frameFromPixelHard'}
        [M_, N_] = deal(1,1);
        vecvsn_gt = NaN(M_*N_*length(volLabel),1);
        gt_idx = 1;
        size_each = M_*N_;
        for ii = 1:length(volLabel)
            if any(volLabel{ii}(:) == 1)
                dbstophere = 5;
            end
            if strcmpi(gttype,'frameFromPixelSoft')
                downsized = imresize(double(volLabel{ii}),[M_,N_],'bilinear');
            else
                downsized = any(volLabel{ii}(:));
            end
            vecvsn_gt(gt_idx:(gt_idx + size_each-1)) = downsized(:);
            gt_idx = gt_idx + size_each;
        end
        sig = NaN(size(vecvsn_gt));
        sig_idx = 1;
        for ii = 1:size(an3,3);
            regsize = an3(:,:,ii);
            downsized = imresize(regsize,[M_,N_],'bilinear');
            sig(sig_idx:(sig_idx+size_each-1)) = downsized(:);
            sig_idx = sig_idx + size_each;
        end
    otherwise
        error('Didn''t recognize your gttype: %s',gttype);
end

y = sig;
gt = vecvsn_gt;

end
