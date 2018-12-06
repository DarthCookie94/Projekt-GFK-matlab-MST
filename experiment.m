
t = 1.984;

%Bilder laden ohne Filter
A=double(imread('..\images\bildebene\0.jpg'));
%  Matrix für Messwerte erstellen
data = zeros(20,14)

for i = 1:1:20
    file = strcat('..\images\bildebene\',int2str(i),'.jpg');
    B=double(imread(file));
    x  = korr(A, B, 10) % get [meanx, meany, sigmax, sigmay]
    meanx = x(1)
    meany = x(2)
    sigmax = x(3)
    sigmay = x(4)   
end



%     %Stuudent t'scher Faktor t
%     n = anzahlSub * anzahlSub; %100
%     %In t-quantil-Tabelle nachschauen:
%     %n = 100 -> t= 1,984
%     % x = tinv(p,nu) berechnet t benötigt aber besondere Lizensen
%     
%     t = 1.984;
%     lowerboundx = meanx - t * (sigmax / sqrt(n));
%     upperboundx = meanx + t * (sigmax / sqrt(n));
%     lowerboundy = meany - t * (sigmay / sqrt(n));
%     upperboundy = meany + t * (sigmay / sqrt(n));
% 
%     fprintf('Verschiebung in X: %f Konfidenzintervall: [%f,%f] \n', meanx, lowerboundx, upperboundx);
%     fprintf('Verschiebung in Y: %f Konfidenzintervall: [%f,%f] \n', meany, lowerboundy, upperboundy);