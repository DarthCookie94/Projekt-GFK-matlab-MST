
function y = getPeak(ima,imb)

% Korrelation bilden
C = xcorr2(ima,imb);

% Peaks bestimmen
[max_cc, imax] = max(abs(C(:)));
[ypeak, xpeak] = ind2sub(size(C),imax(1));
xpeak = xpeak - size(ima,2);
ypeak = ypeak - size(ima,1);

y = [xpeak,ypeak];
end