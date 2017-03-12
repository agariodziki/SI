% wyznaczenie sciezki eksploatacyjnej - czyli takiej, gdy dla kazdego pola
% kolejno wybierane pole jest polem o najwiekszej ilosci feromonu sposrod
% pol dostepnych (bez czynnika losowego)

krok = 1;
pole = start;
pole_pop = start;
sciezka_ekspl = [start];
while (krok < liczba_krokow_max)&&((pole(1) ~= meta(1))||(pole(2) ~= meta(2)))
    % wyznaczenie dostepnych pol, w ktore mozna wejsc:
    % zakladamy, ze mrowka nie moze wyjsc poza plansze, nie moze
    % wejsc na sciane oraz nie cofa sie na pole z ktorego przyszla
    % (chyba ze nie ma innej mozliwosci)
    pola_dost = [];
    ilosci_fer = [];
    if (pole(2) > 1) && (t(pole(1),pole(2)-1)==1) && (pole(2)-1 ~= pole_pop(2))
        pola_dost = [pola_dost ; pole-[0 1]];
        ilosci_fer = [ilosci_fer f(pole(1),pole(2)-1)];
    end
    if (pole(2) < lkolumn) && (t(pole(1),pole(2)+1)==1) && (pole(2)+1 ~= pole_pop(2))
        pola_dost = [pola_dost ; pole+[0 1]];
        ilosci_fer = [ilosci_fer f(pole(1),pole(2)+1)];
    end
    if (pole(1) > 1) && (t(pole(1)-1,pole(2))==1) && (pole(1)-1 ~= pole_pop(1))
        pola_dost = [pola_dost ; pole-[1 0]];
        ilosci_fer = [ilosci_fer f(pole(1)-1,pole(2))];
    end
    if (pole(1) < lwierszy) && (t(pole(1)+1,pole(2))==1) && (pole(1)+1 ~= pole_pop(1))
        pola_dost = [pola_dost ; pole+[1 0]];
        ilosci_fer = [ilosci_fer f(pole(1)+1,pole(2))];
    end
    liczba_dost = length(ilosci_fer);

    if liczba_dost == 0
        p = pole;
        pole = pole_pop;                          % cofniecie sie do pola poprzedniego, jesli brak innych dostepnych pol
        pole_pop = p;
    else
        pole_pop = pole;                          % pole poprzednie (by do niego ponownie nie wejsc

        % wyszukianie nast. pola o najwiekszej ilosci feromonu:
        max_fer = 0;
        ind_pola_wybr = 1;
        for i=1:liczba_dost
            if max_fer <= ilosci_fer(i)
                ind_pola_wybr = i;
                max_fer = ilosci_fer(i);
            end
        end
        
        pole = pola_dost(ind_pola_wybr,:);          % przejscie do nowego wybranego pola
    end

    sciezka_ekspl(krok+1,:) = pole;                     % wpisanie pola do sciezki
    krok = krok + 1;
end  % while po krokach mrowki



if (pole(1) == meta(1))&&(pole(2) == meta(2))  % jesli koncowym polem jest meta
    % usuwanie petli:

%     i=1;
%     while i <= length(sciezka_ekspl(:,1))
%         pole = sciezka_ekspl(i,:);
%         for j=length(sciezka_ekspl(:,1)):-1:i+1
%             if (sciezka_ekspl(j,1)==pole(1))&&(sciezka_ekspl(j,2)==pole(2))
%                 sciezka_ekspl(i+1:j,:) = [];
%                 break;
%             end
%         end
%         i = i+1;
%     end
    dlugosc_sciezki = length(sciezka_ekspl(:,1));
else
    dlugosc_sciezki = inf;  
end