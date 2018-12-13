
t = 1.984;

%Bilder laden ohne Filter
A=double(imread('..\..\images\bildebene\0.jpg'));
%  Matrix für Messwerte erstellen
data = zeros(20,14)
subsetSize= 10

for i = 1:1:20
    file = strcat('..\..\images\bildebene\',int2str(i),'.jpg');
    B=double(imread(file));
    x  = korr(A, B, subsetSize) % get [meanx, meany, sigmax, sigmay]    
    meanx = x(1)
    meany = x(2)
    sigmax = x(3)
    sigmay = x(4)   
    data(i,1) = i;  % Verschiebung in X [um]
    data(i,2) = 0;  % Verschiebung in Y
    data(i,3) = x(1); % meanx
    data(i,4) = x(2); % meany
    data(i,5) = data(i,1)-x(1); % Differenz in X [um]
    data(i,6) = data(i,2)-x(2); % Differenz in Y [um]
    data(i,7) = x(3); % Sigma X
    data(i,8) = x(4); % Sigma Y
    data(i,9) = data(i,5)/data(i,1) ; % Relativer Fehler x
    if data(i,2) == 0
        data(i,10) = 0;
    else
        data(i,10) = data(i,6)/data(i,2); % Relativer Fehler y
    end
    n = subsetSize^2;
    t = 1.984; % fixme buy licence
    data(i,11) = x(1) - t * x(3) / subsetSize ; % Konfidenzinterval x -
    data(i,12) = x(1) + t * x(3) / subsetSize; % Konfidenzinterval x +
    data(i,13) = x(2) - t * x(4) / subsetSize; % Konfidenzinterval y -
    data(i,14) = x(2) + t * x(4) / subsetSize; % Konfidenzinterval y +
    
end

filename = 'messdatei.xlsx';
col_header = {'Verschiebung X [um]','Y [um]','Messwert X [um]','Y [um]','Differenz X [um]','Y [um]','Standardabweichung X [um]','Y [um]','Relativer Fehler X','Y', 'Konfidenzintervall X [um]','','Konfidenzintervall Y [um]',''};
xlswrite(filename,col_header,'Messdaten','A1');    
xlswrite(filename,data,'Messdaten','A2');
