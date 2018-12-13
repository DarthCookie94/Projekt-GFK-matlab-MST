
t = 1.984;

%Bilder laden ohne Filter
A=double(imread('..\..\images\bildebene\0.jpg'));
%  Matrix für Messwerte erstellen
data = zeros(20,15)

resolution = [3840,2448,1920,1280,640] % 4k,2k,FullHD,HD,Kartoffel

for i = 1:1:20
    subsetSize = i 
    file = strcat('..\..\images\bildebene\10.jpg');
    B=double(imread(file));
    x  = korr(A, B, subsetSize); % get [meanx, meany, sigmax, sigmay]    
    data(i,1) = subsetSize^2;
    data(i,2) = 10;  % Verschiebung in X [um]
    data(i,3) = 0;  % Verschiebung in Y
    data(i,4) = x(1); % meanx
    data(i,5) = x(2); % meany
    data(i,6) = data(i,2)-x(1); % Differenz in X [um]
    data(i,7) = data(i,3)-x(2); % Differenz in Y [um]
    data(i,8) = x(3); % Sigma X
    data(i,9) = x(4); % Sigma Y
    data(i,10) = data(i,6)/data(i,2) ; % Relativer Fehler x
    if data(i,3) == 0
        data(i,11) = 0;
    else
        data(i,11) = data(i,7)/data(i,3); % Relativer Fehler y
    end
    n = subsetSize^2;
    t = 1.984; % fixme buy licence
    data(i,12) = x(1) - t * x(3) / subsetSize ; % Konfidenzinterval x -
    data(i,13) = x(1) + t * x(3) / subsetSize; % Konfidenzinterval x +
    data(i,14) = x(2) - t * x(4) / subsetSize; % Konfidenzinterval y -
    data(i,15) = x(2) + t * x(4) / subsetSize; % Konfidenzinterval y +
    
end

filename = 'messdatei.xlsx';
col_header = {'Anzahl Subset','Verschiebung X [um]','Y [um]','Messwert X [um]','Y [um]','Differenz X [um]','Y [um]','Standardabweichung X [um]','Y [um]','Relativer Fehler X','Y', 'Konfidenzintervall X [um]','','Konfidenzintervall Y [um]',''};
xlswrite(filename,col_header,'Messdaten','A1');    
xlswrite(filename,data,'Messdaten','A2');
