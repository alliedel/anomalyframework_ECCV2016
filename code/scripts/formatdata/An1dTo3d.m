
function an3 = An1dTo3d(an, LocV3, BKH, BKW, T)

sig = an./(1-an);
Err = sig(:)';
AbEvent = zeros(BKH, BKW, T);
for ii = 1 : length(Err)
    AbEvent(LocV3(1,ii),LocV3(2,ii),LocV3(3,ii)) =  Err(ii);
end
an3 = smooth3( AbEvent, 'box', 5);

end

