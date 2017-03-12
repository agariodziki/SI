% Rysowanie funkcji 
[X Y] = meshgrid(-10:0.1:10,-10:0.1:10);

Z = fun10(X,Y);
contour(X,Y,Z,[-2:0.2:3]);