clc; 
clear all;
close all;

% Bilder laden und mittels Schwellwert auf 0 oder 255 setzen 
% Schwellwert so setzen, sodass es keine Subpixel mit nur Nullen und nur
% Einsen entstehen
% A=filterpictobin(double(imread('..\images\bildebene\10u0.jpg')),30);
% B=filterpictobin(double(imread('..\images\bildebene\10u1.jpg')),30);

%Bilder laden ohne Filter
A=double(imread('..\images\bildebene\10u0.jpg'));
B=double(imread('..\images\bildebene\10u1.jpg'));

% %Bilder laden ohne Filter bei Niklsd sein Pc
% A=double(imread('C:\Users\Niklsd\Pictures\bildebene\10u0.jpg'));
% B=double(imread('C:\Users\Niklsd\Pictures\bildebene\10u1.jpg'));

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
    progress = i/anzSub * 100; 
end

%Ausreisser eliminieren durch prüfen auf Zugehörigkeit des Konfidenzintervalls
%Standardabweichung berechnen
sigmax = std(peakMatx,'omitnan');
sigmay = std(peakMaty,'omitnan');


%M = mean(A) Mittelwert berechnen
meanx = mean(peakMatx);
meany = mean(peakMaty);

%Stuudent t'scher Faktor t
%n= anzahlSub * anzahlSub; 100
%In t-quantil-Tabelle nachschauen:
%n = 100 , bidirektionales Intervall um 95%-> t= 1,984
n = 100;
t = 1.984;
lowerboundx = meanx - t * (sigmax / sqrt(n));
upperboundx = meanx + t * (sigmax / sqrt(n));
lowerboundy = meany - t * (sigmay / sqrt(n));
upperboundy = meany + t * (sigmay / sqrt(n));

%Filtern von Aussreissern ausserhalb des Konfidenzintervalls
for i = 1:anzSub
    for j = 1:anzSub
        
       if isnan(peakMatx(i,j))
       peakMatx(i,j) = NaN;
       elseif peakMatx(i,j) < lowerboundx
           peakMatx(i,j) = NaN;
       elseif peakMatx(i,j) > upperboundx
           peakMatx(i,j) = NaN;
       end
        
       
        if isnan(peakMaty(i,j))
       peakMaty(i,j) = NaN;
       elseif peakMaty(i,j) < lowerboundy
           peakMaty(i,j) = NaN;
       elseif peakMaty(i,j) > upperboundy
           peakMaty(i,j) = NaN;
        end
    end
end


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






