
function [siga,sigb] = ClipSignals(siga,sigb,tol)
a = length(siga);
b = length(sigb);
if tol < abs((a-b)/a)
    error('vectors aren''t close in length.  Something is wrong');
end
l = min(a,b);
siga = siga(1:l);
sigb = sigb(1:l);

end
