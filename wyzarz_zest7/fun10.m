function y = fun10(x1,x2)

y = sin(x1*4.2)./(abs(x1)+1.5) + sin(x2*5-1).^2./(abs(x2/2-1)+1) + ((x1-4).^2+(x2-5).^2)/55 + ...
    -sin((x1+2.5).*(x2+1))./(3+abs((x1+3).*x2)) + ...
    -2*sin((x1-1).^2 + (x2-2).^2)./(2.5+(x1-4).^2 + (x2-1).^2) + ...
    -3.5*sin(1.5*(x1+3).^2 + 3*(x2-2.7).^2)./(2+(x1+3).^2 + (x2-1).^2);
   
