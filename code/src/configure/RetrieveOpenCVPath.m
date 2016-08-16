function OPENCVLIBPATH = RetrieveOpenCVPath()

[~, sysname] = system('uname -n');
if any(strcmpi({strtrim(sysname),sysname},'yell.ius.cs.cmu.edu'))
    OPENCVLIBPATH='/IUS/vmr101/software/ubuntu12.04/opencv-2.4.5/lib/';
elseif any(strcmpi({sysname,strtrim(sysname)},'allieLaptop-Ubuntu'))
    OPENCVLIBPATH='/IUS/vmr101/software/ubuntu12.04/opencv-2.4.5/lib/';
    % Do nothing
elseif any(strcmpi({strtrim(sysname),sysname},'speedy3'))
    OPENCVLIBPATH='/IUS/vmr101/software/ubuntu12.04/opencv-2.4.5/lib/';
elseif any(strcmpi({strtrim(sysname),sysname},'del-Precision-M4800'))
    OPENCVLIBPATH='/IUS/vmr101/software/ubuntu12.04/opencv-2.4.5/lib/';    
elseif any(strcmpi({strtrim(sysname),sysname},'allie-iMac'))
    OPENCVLIBPATH='/IUS/vmr101/software/ubuntu12.04/opencv-2.4.5/lib/';    
else
    error(sprintf('You''re running on a system I don''t recognize: %s',sysname));
end


end
