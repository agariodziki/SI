% Rysowanie funkcji 
[X Y] = meshgrid(-10:0.3:18,-10:0.3:18);

V = [-3 -2 -1 0 1 2 3 4 5];
Z = fun_xxx(X,Y);
contour(X,Y,Z,-3:0.5:5);