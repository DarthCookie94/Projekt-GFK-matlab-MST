%experiment beleuchtung winkel

subsetSize = 10; %subsetSize * subsetSize =  messungen
t = 1.984; %Wert fuer 100 Messungen


%Bilder laden ohne Filter

%  Matrix f�r Messwerte erstellen
data = zeros(5,15);
j= 45;

for i = 1:1:5
    
    filea = strcat('..\..\images\Beleuchtung\Winkel\',int2str(j),'default.bmp');
    A=double(imread(filea));
    fileb = strcat('..\..\images\Beleuchtung\Winkel\',int2str(j),'.bmp');
    B=double(imread(fileb));
    x  = korr(A, B, subsetSize); % get [meanx, meany, sigmax, sigmay]    
    data(i,1) = j;
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
%     t = 1.984; % fixme buy licence
    data(i,12) = x(1) - t * x(3) / subsetSize ; % Konfidenzinterval x -
    data(i,13) = x(1) + t * x(3) / subsetSize; % Konfidenzinterval x +
    data(i,14) = x(2) - t * x(4) / subsetSize; % Konfidenzinterval y -
    data(i,15) = x(2) + t * x(4) / subsetSize; % Konfidenzinterval y +
    
    j = j + 5;
end

filename = 'messdateibeleuchtungwinkel.xlsx';
col_header = {'Winkel in Grad','Verschiebung X [um]','Y [um]','Messwert X [um]','Y [um]','Differenz X [um]','Y [um]','Standardabweichung X [um]','Y [um]','Relativer Fehler X','Y', 'Konfidenzintervall X [um]','','Konfidenzintervall Y [um]',''};
xlswrite(filename,col_header,'Messdaten','A1');    
xlswrite(filename,data,'Messdaten','A2');