clc; 
clear all;
close all;

% Bilder laden und mittels Schwellwert auf 0 oder 255 setzen 
% Schwellwert so setzen, sodass es keine Subpixel mit nur Nullen und nur
% Einsen entstehen
% A=filter(double(imread('..\images\bildebene\10u0.jpg')),30);
% B=filter(double(imread('..\images\bildebene\10u1.jpg')),30);

%Bilder laden ohne Filter
A=double(imread('..\images\bildebene\10u0.jpg'));
B=double(imread('..\images\bildebene\10u1.jpg'));

% Anzahl Subbereiche
anzSub = 10;
peakMatx = zeros(anzSub, anzSub);
peakMaty = zeros(anzSub, anzSub);

for i = 0:anzSub-1
    for j = 0:anzSub-1
       
        starty = round(i/anzSub * size(A,1)) + 1;
        endey = round((i+1)/anzSub * size(A,1));
        startx = round(j/anzSub * size(A,2)) + 1;
        endex = round((j+1)/anzSub * size(A,2));
        subA = A(starty:endey,startx:endex);
        subB = B(starty:endey,startx:endex);
        peak = getPeakSub(subA,subB);
        peakMatx(i+1,j+1) = peak(1);
        peakMaty(i+1,j+1) = peak(2);
        
    end
    progress = i/anzSub * 100 
end

peakMatx
peakMaty
%plot Vektorfeld
x = 1:1:anzSub;
y = 1:1:anzSub;
[x,y] = meshgrid(x,y);
quiver(x,y,peakMatx,peakMaty);

grid on
hold on 

axis([ 0 anzSub+2 0 anzSub+1]);
title('Vektorfeld');
xlabel ('Verschiebung in x-Richtung');
ylabel ('Verschiebung in y-Richtung');



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
%richtig klar wieso hier uaf NaN geprüft werden muss...
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

function y = studentt()

end

% filtert ein Bild mit Schwellenwert
function y = filterpictobin(x,boarder)
for i = 1:size(x,1)
    for j = 1:size(x,2)
        if x(i,j) > boarder
            x(i,j)  = 255;
        else   
            x(i,j)  = 0;
        end
    end   
end            
y = x; 
end
