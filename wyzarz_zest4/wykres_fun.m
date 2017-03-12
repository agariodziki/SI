% Rysowanie funkcji 
[X Y] = meshgrid(-10:0.1:10,-10:0.1:10);
%surf(X,Y,fun3(X,Y));
%pause

V = [-1.8 -1.5 -1 -0.5 0 1 2 3 4 5];

contour(X,Y,fun3(X,Y),V);