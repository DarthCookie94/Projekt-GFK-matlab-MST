clc; 
clear all;
close all;

% Bilder laden und mittels Schwellwert auf 0 oder 255 setzen 
A=filter(imread('..\images\bildebene\normal0.jpg'),180);
B=filter(imread('..\images\bildebene\normal1.jpg'),180);

%Bilder laden ohne Filter
% A=imread('..\images\bildebene\normal0.jpg');
% B=imread('..\images\bildebene\normal1.jpg');

% Anzahl Subbereiche
anzSub = 5;
peakMatx = zeros(anzSub, anzSub);
peakMaty = zeros(anzSub, anzSub);

for i = 0:anzSub-1
    for j = 0:anzSub-1
       
        starty = round(i/anzSub * size(A,1)) + 1;
        endey = round((i+1)/anzSub * size(A,1));
        startx = round(j/anzSub * size(A,2)) + 1;
        endex = round((j+1)/anzSub * size(A),2);
        subA = A(starty:endey,startx:endex);
        subB = B(starty:endey,startx:endex);
        peak = getPeak(subA,subB)
        peakMatx(i+1,j+1) = peak(1);
        peakMaty(i+1,j+1) = peak(2);
        
        %Bildauschnitt darstellen
%         figure();
%         imshow(subA);
%         axis on;
    end    
end

%plot Vektorfeld
x = 1:1:anzSub
y = 1:1:anzSub
[x,y] = meshgrid(x,y)
u = peakMatx(x)
v = peakMaty(y)
quiver(x,y,u,v)

 %Kreutzkorrelation via Subpixelmethode
usfac = 100; %Genauigkeit auf 1/usfac 
[output, Greg] = dftregistration(fft2(ima),fft2(imb),usfac);
display(output);
% %output = 1x4 double
% %Wert 1: normalized root-mean-squared error
% %Wert 2: global phase shift -> ideal ist 0
% %Wert 3: shift row
% %Wert 4: shift column

function y = getPeak(ima,imb)
% Bildauschnitt darstellen
% figure();
% imshow(A(x,x));
% axis on;
% 
% figure();
% imshow(B(x,x));
% axis on;

%Kommentar von Niklas: Das funkt nicht mit den Bildausschnitten
% %Kreutzkorrelation via Subpixelmethode
% usfac = 100; %Genauigkeit auf 1/usfac 
% [output, Greg] = dftregistration(fft2(ima),fft2(imb),usfac);
% display(output);
% %output = 1x4 double
% %Wert 1: normalized root-mean-squared error
% %Wert 2: global phase shift -> ideal ist 0
% %Wert 3: shift row
% %Wert 4: shift column
% 
% % Peaks bestimmen
% xpeak = output(3);
% ypeak = output(4);

% Korrelation bilden
C = xcorr2(ima,imb);
% auf [0,1] normieren
%C_norm = (C - min(min(C))) / (max(max(C))-min(min(C))) ;

% Peaks bestimmen
[max_cc, imax] = max(abs(C(:)));
[ypeak, xpeak] = ind2sub(size(C),imax(1));
xpeak = xpeak - size(ima,2);
ypeak = ypeak - size(ima,1);



% figure();
% imshow(C_norm);
% axis on;
y = [xpeak,ypeak];
grid on
hold on 

ax = axis
axis([ 0 7 0 6])
title('Vektorfeld')
xlabel ('Verschiebung in x-Richtung')
ylabel ('Verschiebung in y-Richtung')
end


% filtert ein Bild mit Schwellenwert
function y = filter(x,boarder)
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
