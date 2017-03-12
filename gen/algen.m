% Szukanie minimum funkcji - algorytm genetyczny
clear;
 
wsp_rozmiaru = 0.8;

liczba_rozw = 10 ;                                % liczba osobnikow (rozwiazan) w populacji
                                 
liczba_epok = 1000;
pkrz = 0.3;                                        % prawdopodobienstwo krzyzowania
pmut = 0.6;                                        % prawdopodobienstwo mutacji
wsp_selekcji = 0.3;                                % nacisk selekcyjny
 
liczba_param = 2;                                   % liczba parametrow funkcji
L = liczba_rozw;
N = liczba_param;
Droga=[];
Popul = rand(N,L)*20-10;                           % losowanie populacji dla L osobnikow (rozwiazan)
minimum = 10e40;                                                                                                 % poczatkowa wartosc rekordu    
format long;                                                                                                     % duza liczba miejsc po przecinku
tic                                                                                                                              % poczatek pomiaru czasu
for ep=1:liczba_epok
   Funkcja = fun3(Popul(1,:),Popul(2,:));           % wartosc funkcji dla kazdego rozwiazania (funkcje wskazuje prowadzacy)
   % Ocena = ...                                       % ocena > 0 i tym wieksza, im lepsze rozwiazanie
   Oceny=[];
   for i=1:liczba_rozw
       Ocena = (1/(Funkcja(i)+2))^wsp_selekcji;
       Oceny = [Oceny Ocena];
   end
   %i1 = length(Oceny);
   %i2 = length(Funkcja);
   
   [min1 Imin] = min(Funkcja);
   if minimum > min1                                 % sprawdzenie rekordu
      minimum = min1;
      Rekord = Popul(:,Imin);                          
      Droga = [Droga ; Rekord'];                    % umieszczenie wspolrzednych na liscie
      %sprintf('w epoce %d  rekord = %f  w punkcie %s \n',ep,min1,num2str(Rekord'))
   end
   
   % Reprodukcja ...
    Popul = rep_rul(Popul, Oceny);
   % Krzyzowanie ...
    for i=1:liczba_rozw
       if (rand < pkrz)
           i1  = 1+floor(rand*liczba_rozw);
           i2  = 1+floor(rand*liczba_rozw);
           tmp1 = Popul(1, i1);
           tmp2 = Popul(2, i1);
           Popul(1, i1) = Popul(1, i2);
           Popul(2, i1) = Popul(2, i2);
           Popul(1, i2) = tmp1;
           Popul(2, i2) = tmp2;
       end
    end
   % Mutacja ...
   for i=1:liczba_rozw
       if (rand < pmut)
           x = ((2*rand-1));
           y = ((2*rand-1));
           Popul(1, i) = Popul(1, i)+x;
           Popul(2, i) = Popul(2, i)+y;
       end
    end
end
 
f = figure;
ekran = get(0,'screensize');  
set(f,'Position',[ekran(3)*(1-wsp_rozmiaru)/2 ekran(4)*(1-wsp_rozmiaru)/2 ekran(3)*wsp_rozmiaru ekran(4)*wsp_rozmiaru]); 


disp('czas poszukiwan [s]:')
toc                                                 % koniec pomiaru czasu
% Rysowanie funkcji:
[X Y] = meshgrid(-10:0.1:10,-10:0.1:10);            % siatka punktow na plaszczyznie dwuwymiarowej
V = [ -1.75 -1.5 -1 0 1 2 3 4 5];                   % wysokosci poziomic
[cs h] = contour(X,Y,fun3(X,Y),V);                  % wykres - mapa
clabel(cs,h);                                                                                               % etykiety poziomic                
hold on                                                                                                                  % rysuj na istniejacym rysunku
% Rysowanie rekordowych punktow:
plot(Droga(:,1)',Droga(:,2)');                                                   % przejscia pomiedzy rekordami        
plot(Droga(:,1)',Droga(:,2)','ro');                                              % rekordowe punkty oznaczone czerwonymi kolkami               
title('Kolejne rekordy (w czerwonych kolkach)');
for i=1:length(Droga(:,1)')                                                         % etykiety (numery) rekordow       
        text(Droga(i,1)', Droga(i,2)', int2str(i), ...
        'fontsize', 8);
end
disp('Rozwiazanie: ')
fun3(Droga(end,1), Droga(end,2))
hold off;
pause
close(f);