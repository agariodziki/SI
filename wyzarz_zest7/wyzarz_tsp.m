% Poszukiwanie minimum funkcji bledu metoda symulowanego wyzarzania.
% Wybor nowego polozenia z rozkladem rownomiernym, akceptacja nastepuje z 
% pewnym rozkladem prawdopodobienstwa zaleznym od wielkosci zmniejszenia 
% bledu(dE) i temperatury(T):
%   h(dE,T) = 1/(1 + exp(dE/cT))
% oraz pewnej stalej c. Jesli c mala dodatnia to algorytm redukuje sie
% do szukania przypadkowego (akceptacja tylko modyfikacji zmniejszajacych blad),
% jesli c duza to do bladzenia przypadkowego (poprawka nie zalezy od bledu)
clear;
tic;  
liczba_krokow = 20000;
pokaz_co = 1000;

T = 100;                                      % temperatura poczatkowa
Tmin = 0.01;                                  % temparatura minimalna
wT = 0.995;                                   % wspolczynnik zmniejszenia temperatury 
c = 0.1;                                      % stala regulujaca wplyw temperatury na akceptacje
OdlegloscMin = 10e40;
miasta = load('kroa100');                     % wczytanie wspolrzednych miast

liczba_miast = length(miasta(:,1))
N = liczba_miast;

Rozw = randperm(liczba_miast);                % rozwiazanie poczatkowe: dowolna permutacja miast

% Ocena rozwiazania - suma odleglosci miedzy sasiednimi miastami w cyklu: 
Odle = sqrt((miasta(Rozw,2)-miasta(Rozw([2:end 1]),2)).^2 + ...
               (miasta(Rozw,3)-miasta(Rozw([2:end 1]),3)).^2); 
Odleglosc = sum(Odle);

OdlegloscPop = Odleglosc;
OdlRek = []; KrokRek = [];
Odl = []; Temp = []; Pakcept = [];

format long;         % 15 miejsc znaczacych

Droga = [Rozw];
for kro=1:liczba_krokow
   % Zmiana rozwiazania przy pomocy inwersji - odwrocenie wylosowanego podciagu:
   k1 = 1+floor(rand*N);                            % losuje krawedzie do wymiany
   k2 = k1+floor(rand*(N-k1));                      % odwrocenie wybranego podciagu:
   Rozw2 = [Rozw(1:k1) fliplr(Rozw((k1+1):k2)) Rozw((k2+1):end)];
   % Korekta odleglosci:
   Odleglosc = sum(sqrt((miasta(Rozw2,2)-miasta(Rozw2([2:end 1]),2)).^2 + ...
               (miasta(Rozw2,3)-miasta(Rozw2([2:end 1]),3)).^2));
   Odl(kro) = Odleglosc;
   if Odleglosc < OdlegloscMin                      % sprawdzenie czy jest rekord
      disp('Poprawiono odleglosc:')
      OdlegloscMin = Odleglosc
      %disp('Dla rozwiazania:')
      RozwMin = Rozw2;
      OdlRek = [OdlRek Odleglosc];
      KrokRek = [KrokRek kro];
   end
   dE = Odleglosc - OdlegloscPop;
   if rand < 1/(1+exp(dE/(c*T)))                    % warunek akceptacji
      Rozw = Rozw2;                                 % jesli akceptacja to przyjecie nowego rozw. jako biezcego
      %Droga = [Droga ; Rozw];
      OdlegloscPop = Odleglosc;
      Odl = [Odl Odleglosc];
   end
   T = T*wT;                                        % zmniejszenie temperatury
   if T<Tmin 
      T=Tmin;
   end
   Temp = [Temp T];
   Pakcept = [Pakcept 1/(1+exp(dE/(c*T)))];           
   if mod(kro,pokaz_co)==0
      %close;
      cla;
      plot(miasta(RozwMin([1:end,1]),2),miasta(RozwMin([1:end,1]),3));
      hold on;
      plot(miasta(:,2),miasta(:,3),'ro');
      title(sprintf('w %g kroku dlugosc min trasy TSP = %g',kro,OdlegloscMin));
      xlabel('dlugosc trasy minimalnej kroa100 = 21282');
      hold off;
      pause(0.1);
      drawnow;
      shg;
   end
     
end

plot(Odl);
title(' Zaakceptowane dlugosci trasy');
pause
plot(KrokRek,OdlRek,'');
title(' Rekordowe dlugosci trasy ');
pause
plot(Temp);
title(' Temperatury ');
