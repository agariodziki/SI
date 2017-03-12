% Zastosowanie algorytmu mrowkowego do wyznaczania trasy (sciezki) o minimalnej
% dlugosci - wersja 2

clear                           % wyczyszczenie pamieci roboczej
close all                       % zamkniecie wszystkich okien z rysunkami
nazwa_pliku = 'labirynt6.bmp'
sledzenie = 1;                  % czy rysowac po kazdej trasie aktualny stan feromonu
liczba_tras = 1500;             % liczba tras wyznaczanych przez mrowki
liczba_krokow_max = 400;        % maksymalna liczba krokow, by zabezpieczyc sie przed petla

droga_pow = 4;
n = 0.3;         % wspolczynnik nacisku selekcyjnego (im wiekszy, tym wieksze prawd. wyboru kierunku z wieksza iloscia feromonu)
par = 0.1;       % wspolczynik parowania feromonu (zmniejszenie feromonu po kazdym cyklu)

t = imread(nazwa_pliku);        % wczytanie labiryntu 
fig1 = figure;                  % otwarcie okna rysunkowego    

mapa_kol = [ones(1,255);[1:255]/255;ones(1,255)]';
mapa_kol = [[0 0 0];mapa_kol];
colormap(mapa_kol);             % ustawienie kolorow
imagesc(t);                     % rysowanie obrazka - labiryntu
title(sprintf('labirynt %s nacisnij klawisz ...',nazwa_pliku));
pause                


[lwierszy lkolumn] = size(t);

start = [ceil(lwierszy/2),1]         % pole poczatkowe (mrowisko): wektor dwuelem.: [nr wiersza, nr kolumny]
meta = [ceil(lwierszy/2),lkolumn]    % pole koncowe (jedzenie)

f = ones(lwierszy,lkolumn);         % tablica feromonu 
f_swiezy = zeros(lwierszy,lkolumn);  % tablica feromonu swiezo naniesionego

% Petla po trasach: kazda trasa, po jej wyznaczeniu, powinna byc przez prawdziwa mrowke
% (mrowki) pokonana wiele razy, by pozostawiona ilosc feromonu byla uzalezniona od dlugosci trasy,
% tutaj mozna od razu umiescic feromon w odpowiedniej ilosci (np odwrotnie
% proporcjonalnie do dlugosci trasy)
for trasa=1:liczba_tras
    krok = 1;
    pole = start;
    pole_pop = start;
    sciezka = [start];
    while (krok < liczba_krokow_max)&&((pole(1) ~= meta(1))||(pole(2) ~= meta(2)))
        % wyznaczenie dostepnych pol, w ktore mozna wejsc:
        % zakladamy, ze mrowka nie moze wyjsc poza plansze, nie moze 
        % wejsc na sciane oraz nie cofa sie na pole z ktorego przyszla
        % (chyba ze nie ma innej mozliwosci)
        % tablica pola_dostepne zawiera pola w wierszach, w kazdym wierszu nr wiersza i kolumny w labiryncie 
        % tablica ilosci_feromonu zawiera informacje o ilosciach feromonu w
        % kazdym dostepnym polu
        pola_dostepne = [];
        ilosci_feromonu = [];
        if (pole(2) > 1) && (t(pole(1),pole(2)-1)==1) && (pole(2)-1 ~= pole_pop(2))
            pola_dostepne = [pola_dostepne ; pole-[0 1]];
            ilosci_feromonu = [ilosci_feromonu f(pole(1),pole(2)-1)];
        end
        if (pole(2) < lkolumn) && (t(pole(1),pole(2)+1)==1) && (pole(2)+1 ~= pole_pop(2))
            pola_dostepne = [pola_dostepne ; pole+[0 1]];
            ilosci_feromonu = [ilosci_feromonu f(pole(1),pole(2)+1)];
        end
        if (pole(1) > 1) && (t(pole(1)-1,pole(2))==1) && (pole(1)-1 ~= pole_pop(1))
            pola_dostepne = [pola_dostepne ; pole-[1 0]];
            ilosci_feromonu = [ilosci_feromonu f(pole(1)-1,pole(2))];
        end
        if (pole(1) < lwierszy) && (t(pole(1)+1,pole(2))==1) && (pole(1)+1 ~= pole_pop(1))
            pola_dostepne = [pola_dostepne ; pole+[1 0]];
            ilosci_feromonu = [ilosci_feromonu f(pole(1)+1,pole(2))];
        end
        liczba_dostepnych = length(ilosci_feromonu);  % liczba pol dostepnych w danym kroku      

        
        if liczba_dostepnych == 0
            p = pole; 
            pole = pole_pop;                          % cofniecie sie do pola poprzedniego, jesli brak innych dostepnych pol
            pole_pop = p;
        else
            pole_pop = pole;                          % pole poprzednie (by do niego ponownie nie wejsc
            
            % ................  TUTAJ NALEZY WYBRAC NOWE POLE ...........
            ilosc_feromonu = ilosci_feromonu .^ n;
             if liczba_dostepnych == 1
                ind_pola_wybr = 1;
            else
                losowa = rand*(sum(ilosci_feromonu));
                if losowa <= ilosci_feromonu(1)
                    ind_pola_wybr = 1;
                else
                    if losowa <= ilosci_feromonu(1) + ilosci_feromonu(2)
                        ind_pola_wybr = 2;
                    else
                        ind_pola_wybr = 3;
                    end
                end              
            end
            
            % .........................................................
                                       
            pole = pola_dostepne(ind_pola_wybr,:);    % przejscie do nowego wybranego pola
        end
        
        sciezka(krok+1,:) = pole;                     % wpisanie pola do sciezki       
        krok = krok + 1;
    end  % while po krokach mrowki
    
    if (pole(1) == meta(1))&&(pole(2) == meta(2))  % jesli koncowym polem jest meta  
        
        % ............... TUTAJ NALEZY ZMODYFIKOWAC TABLICE FEROMONU
        for i=1:length(sciezka(:,1))
            f_swiezy(sciezka(i,1),sciezka(i,2)) = 1/( 4 + length(sciezka(:,1))^droga_pow);     % na razie stala wartosc
        end
        
        
        
        
        
        
        
        % ..........................................................       
    end
    
    f = f*(1-par) + f_swiezy;                  % parowanie zapachu + swiezy feromon
    f_swiezy = zeros(lwierszy,lkolumn);        % wyzerowanie tablicy swiezego feromonu

    if sledzenie                               
        f_rys = (1-f/max(max(f))*0.95).*t;     % przygotowanie rysunku (by bylo widac sciany labiryntu i feromon
        figure(fig1);                          % wybor okna rysunkowego
        imagesc(f_rys);                        % rysowanie labiryntu z zaznaczonym feromonem
        sciezka_max;                           % wyznaczenie sciezki, jaka pojdzie mrowka bez losowosci - eksploracji (kierujac sie tylko zapachem)
        title(sprintf('po %d trasach: pozostaly feromon, dlugosc sciezki = %d',trasa,dlugosc_sciezki))
        %pause(0.1);
    end
  
end

f_rys = (1-f/max(max(f))*0.95).*t;
figure(fig1); 
imagesc(f_rys);
sciezka_max;
title(sprintf('po %d trasach: pozostaly feromon, dlugosc trasy = %d',trasa,dlugosc_sciezki))

