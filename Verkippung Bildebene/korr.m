
function y = korr(A,B, subSetSize)
    % liefert Mittelwert und Standartabweichung der Verschiebung aus 2
    % Bildern und einer SubSetgröße
    % liefert [meanx, meany, sigmax, sigmay]

    % Konstante für um/pixel bei einer großen Verschiebung gemessen (4k Bild)
    umpp = 100 / 31.8550;

    % Anzahl Subbereiche
    anzSub = subSetSize;
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

    clc;
    % Umrechnen der Pixelwerte in um
    peakMatx = peakMatx .* umpp;
    peakMaty = peakMaty .* umpp;

    % statistische Auswertung
    sigmax = std2(peakMatx);
    sigmay = std2(peakMaty);

    meanx = mean(mean(peakMatx));
    meany = mean(mean(peakMaty));

    % 3 Sigma Intervall
    % lowerboundx = meanx - 3 * sigmax;
    % upperboundx = meanx + 3 * sigmax;
    % lowerboundy = meany - 3 * sigmay;
    % upperboundy = meany + 3 * sigmay;
    % fprintf('Verschiebung in X: %f +- %f -->[%f,%f] \n', meanx, 3 * sigmax, lowerboundx, upperboundx);
    % fprintf('Verschiebung in Y: %f +- %f -->[%f,%f] \n', meany, 3 * sigmay, lowerboundy, upperboundy);

    %Ausreisser eliminieren durch prüfen auf Zugehörigkeit des Konfidenzintervalls


    %plot Vektorfeld
%     x = 1:1:anzSub;
%     y = 1:1:anzSub;
%     [x,y] = meshgrid(x,y);
%     quiver(x,y,peakMatx,peakMaty);

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


    % Wenn der Fehler der Korrelation NaN ergibt soll der Punkt nicht
    % mitgeplottet werden
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

y = [meanx, meany, sigmax, sigmay];
end