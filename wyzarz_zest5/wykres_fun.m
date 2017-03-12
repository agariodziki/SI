% Rysowanie funkcji 
[X Y] = meshgrid(-10:0.1:10,-10:0.1:10);

V = [-0.87 -0.8 -0.5 0 1 2 3 4 5];

contour(X,Y,fun2(X,Y),V);