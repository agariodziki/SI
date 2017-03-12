% Poszukiwanie minimum funkcji bledu metoda symulowanego wyzarzania.
% Wybor nowego polozenia z rozkladem rownomiernym, akceptacja nastepuje z
% pewnym rozkladem prawdopodobienstwa zaleznym od wielkosci zmniejszenia
% bledu(dE) i temperatury(T):
%   h(dE,T) = 1/(1 + exp(dE/cT))
% oraz pewnej stalej c. Jesli c mala dodatnia to algorytm redukuje sie
% do szukania przypadkowego (akceptacja tylko modyfikacji zmniejszajacych blad),
% jesli c duza to do bladzenia przypadkowego (poprawka nie zalezy od bledu)
 
wsp_rozmiaru = 0.8;

liczba_param = 2;
liczba_cykli = 50000;
N = liczba_param;
Rozw = rand(1,N)*20-10;                 % rozw. poczatkowe
T = 200                                 % pocz. krok iteracji
Tmin = 0.1                              % minimalny krok iteracji
wT = 0.995                                % wsp zminy kroku
c = 0.1                                 % wsp. regulacji wplywu temperatury
Emin = 10e40;
Epop = 0;
format long;                            % 15 miejsc znaczacych
Droga = [Rozw];
for cyk=1:liczba_cykli
   x = (0.5*T*(2*rand-1));
   y = (0.5*T*(2*rand-1));
   Rozw2 = [mod((Rozw(1) + x),10),mod((Rozw(2) + y),10)];                          % nowe rozwiazanie (powinno byc uzaleznine od temperatury)
 
   E = fun3(Rozw2(1),Rozw2(2));         % wartosc funkcji
   
   dE = E - Epop;                       % roznica wartosi funkcji
   if rand < 1/(1+exp(dE/(c*T)))        % warunek akceptacji
      Rozw = Rozw2;    
      Epop = E;
   end
   
   if E < Emin                          % sprawdzenie czy jest rekord
      disp('Poprawiono minimum:')
      Emin = E
      disp('Dla rozwiazania:')
      Rozwmin = Rozw2  
      Droga = [Droga ; Rozwmin];
   end
   
   T = T*wT;                            % nowa wartosc temperatury
   if T<Tmin
      T=Tmin;
   end
end
 
f = figure;
ekran = get(0,'screensize');  
set(f,'Position',[ekran(3)*(1-wsp_rozmiaru)/2 ekran(4)*(1-wsp_rozmiaru)/2 ekran(3)*wsp_rozmiaru ekran(4)*wsp_rozmiaru]); 

wykres_fun
hold on
plot(Droga(:,1)',Droga(:,2)');
plot(Droga(:,1)',Droga(:,2)','ro');
plot(Droga(end,1)',Droga(end,2)','gs');
 
for i=1:length(Droga(:,1)')
        text(Droga(i,1)'+0.01, Droga(i,2)'+0.01, int2str(i), ...
        'fontsize', 8);
end
hold off
pause
close(f);