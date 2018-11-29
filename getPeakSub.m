function y = getPeakSub(ima,imb)

%Kreutzkorrelation via Subpixelmethode
usfac = 500; %Genauigkeit auf 1/usfac 
[output, Greg] = dftregistration(fft2(ima),fft2(imb),usfac);
%output = 1x4 double
%Wert 1: normalized root-mean-squared error
%Wert 2: global phase shift -> ideal ist 0
%Wert 3: shift row
%Wert 4: shift column


%Kommentar Niklas: schreibt hier mal bitte mehr zu. Mir ist das nicht
%richtig klar wieso hier auf NaN geprüft werden muss...
% Peaks bestimmen
if isnan(output(1))
    ypeak = NaN;
    xpeak = NaN;
else
    ypeak = output(3);
    xpeak = output(4);
end 

y = [xpeak,ypeak];
end
