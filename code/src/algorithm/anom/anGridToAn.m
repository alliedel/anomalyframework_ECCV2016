function an = anGridToAn(anGrid,rct,tstarts,dt,T,fnctn)
% Average or take max? across time                                                             
an = zeros(T,1);
for i = 1:length(tstarts)
    tst = tstarts(i);
    iis = (rct(:,3) >= tst) & (rct(:,3) < tst + dt);
    if sum(iis) == 0
        val = NaN;
    else
        val = fnctn(anGrid(iis));
    end
    an(tst:(tst+dt-1)) = val;
end

end

