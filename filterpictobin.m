
% binärisiert ein Bild mit Schwellenwert
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
