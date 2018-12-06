
t = 1.984;

%Bilder laden ohne Filter
A=double(imread('..\images\bildebene\0.jpg'));
%  Matrix für Messwerte erstellen
data = zeros(20,14)

for i = 1:1:20
    file = strcat('..\images\bildebene\',int2str(i),'.jpg');
    B=double(imread(file));
    x  = korr(A, B, 10); % get [meanx, meany, sigmax, sigmay,lowerboundx,upperboundx,lowerboundy,upperboundy]
  
    %pro forma variablen zur leichteren Zuordnung. Das muss dann noch alles
    %in data überführt werden,oder man definiert die Variablen vor der for
    %schleife und referenziert diese per (i)...
    %bsp: Messwert_x = zeros(1,20);
    %anfang for
    %Messwert_x(i) = x(1);
    %for ende
    [Verschiebung_x] = 1:1:20;
    [Verschiebung_y] = zeros(1,20);
    [Messwert_x] = x(1);
    [Messwert_y] = x(2);
    [abs_Fehler_x] =  ;
    [abs_Fehler_y] =  ;
    [Sigma_x] = x(3);
    [Sigma_y] = x(4);
    [relFehler_x] = ;%abs/mess
    [relFehler_y] =;
    [Konfidenzintervall_x_unten] = x(5);
    [Konfidenzintervall_x_oben]  = x(6);
    [Konfidenzintervall_y_unten] = x(7);
    [Konfidenzintervall_y_oben]  = x(8);
    
end

T = table(Verschiebung_x,Verschiebung_y,Messwert_x,Messwert_y,abs_Fehler_x,abs_Fehler_y,Sigma_x,Sigma_y,relFehler_x,relFehler_y,Konfidenzintervall_x_unten,Konfidenzintervall_x_oben,Konfidenzintervall_y_unten,Konfidenzintervall_y_oben);
warning('off','MATLAB:xlswrite:AddSheet');
filename = 'messdatei.xlsx';
xlswrite(filename,T,'Messdaten','A1');

