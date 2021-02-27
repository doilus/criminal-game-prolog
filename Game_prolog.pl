:- dynamic pozycja/1.
:- dynamic rozmowa/1.
:- dynamic torebka/1.
:- dynamic rozmowa_kto/1.

%osoby z przyjecia
man(cezary).
man(filip).
man(radek).

woman(dominika).
woman(magda).
woman(monika).
woman(ania).

%ich relacje
marriage(cezary,dominika).
marriage(filip,magda).
marriage(radek,ania).

torebka([cukierek, telefon]).
rozmowa_kto([]).

znajdz_torebka(X) :-
			torebka(Y),
			member(X,Y).
			
znajdz_rozmowa(X) :-
			rozmowa_kto(Y),
			member(X,Y).

wypisz_liste([H|T]) :- write(H), nl, wypisz_liste(T).
rzeczy :- torebka(X), wypisz_liste(X).
z_kim_rozmawiales :- rozmowa_kto(X), wypisz_liste(X).
dodaj(X) :- torebka(Y), append(Y,[X],Z), retract(torebka(Y)), assert(torebka(Z)).
dodaj_rozmowe(X) :- rozmowa_kto(Y), append(Y,[X],Z), retract(rozmowa_kto(Y)), assert(rozmowa_kto(Z)).



parent(cezary,monika).
parent(dominika,monika).

pozycja(sypialnia).
rozmowa(cezary).

miejsce_czlowiek(sypialnia,cezary).
miejsce_czlowiek(salon,monika).
miejsce_czlowiek(salon,ania).
miejsce_czlowiek(salon,radek).
miejsce_czlowiek(kuchnia,dominika).
miejsce_czlowiek(korytarz,magda).
miejsce_czlowiek(taras,filip).
miejsce_przeszukanie(sypialnia,list).
miejsce_przeszukanie(sypialnia,szkatulka).
miejsce_przeszukanie(sypialnia,skrytka).
miejsce_przeszukanie(salon,tv).
miejsce_przeszukanie(kuchnia,szafka).
miejsce_przeszukanie(korytarz,plaszcz).
miejsce_przeszukanie(taras,popielniczka).



polaczenie_miejsc(sypialnia,salon).
polaczenie_miejsc(salon,korytarz).
polaczenie_miejsc(toaleta,salon).
polaczenie_miejsc(salon, kuchnia).
polaczenie_miejsc(korytarz, taras).


%rekurencja drogi
droga(X,Y) :- polaczenie_miejsc(X,Y), write('->'), write(Y).
droga(X,Y) :- polaczenie_miejsc(X,Z), write('->'), write(Z), droga(Z,Y).
droga(X,Y) :- droga(Y,X).

idz(taras) :- znajdz_torebka(klucz), pozycja(Y), polaczenie_miejsc(Y,taras), retract(pozycja(Y)), assert(pozycja(taras)), !.
idz(taras) :- write('Musisz najpierw znalezc klucz do tarasu').				
idz(X) :- pozycja(Y), polaczenie_miejsc(Y,X), retract(pozycja(Y)), assert(pozycja(X)).
idz(X) :- pozycja(Y), polaczenie_miejsc(X,Y), retract(pozycja(Y)), assert(pozycja(X)).
idz(X) :- write('Nie mozesz isc do '), write(X).

gdzie_isc(X) :- polaczenie_miejsc(X,Y), write(Y).
gdzie_isc(X) :- polaczenie_miejsc(Y,X), write(Y).

rozpocznij :-
				samouczek,
				write('Witamy na przyjeciu!'), nl,
				write('Cezary poprosil Cie o pomoc. Ze skrytki zostal ukradziony jego drogocenny pierscien.'), nl,
				write('Twoim zadaniem jest odnalezienie pierscienia lub zlodziejaszka.'), nl,
				write('Porozmawiaj z Cezarym gdy zdobedziesz dowod.'), nl,
                write('-----------------------------------------------'),nl,
				opis.

samouczek :-
				write('-----------------------------------------------'),nl,
				write('Samouczek'),nl,
				write('Gdy chcesz wiedziec gdzie sie znajdujesz --> opis.'),nl,
				write('Gdy chcesz z kims porozmawiac --> porozmawiaj(imie).'),nl,
				write('Gdy chcesz zadac komus pytanie --> zadaj_pytanie(index_pytania).'),nl,
				write('Gdy chcesz cos zbadac wpisz --> zbadaj(nazwa).'),nl,			
				write('Gdy chcesz isc w inne miejsce --> idz(miejsce).'),nl,
				write('Gdy chcesz sprawdzic droge --> droga(miejsce_od, miejsce_do).'),nl,
				write('Aby sprawdzic rzeczy w torebce --> rzeczy.'),nl,
				write('UWAGA! Podczas rozmow korzystaj z oskarzen tylko gdy jestes pewny!'),nl,
				write('-----------------------------------------------'),nl.

opis :-
				pozycja(X),
				opis_miejsca(X).

opis_miejsca(sypialnia) :-
				write('Obecnie znajdujesz sie w sypialni,'), nl,
				write('mozesz porozmawiac z: '), miejsce_czlowiek(sypialnia,X), write(X), nl,
				write('mozesz zbadac: '), miejsce_przeszukanie(sypialnia, Y), write(Y).
				
opis_miejsca(salon) :-
				write('Obecnie znajdujesz sie w salonie,'), nl,
				write('mozesz porozmawiac z: '), miejsce_czlowiek(salon,X), write(X),nl;
				write('mozesz zbadac: '), miejsce_przeszukanie(salon, Y), write(Y).
opis_miejsca(kuchnia) :-
				write('Obecnie znajdujesz sie w kuchni,'), nl,
				write('mozesz porozmawiac z: '), miejsce_czlowiek(kuchnia,X), write(X),nl;
				write('mozesz zbadac: '), miejsce_przeszukanie(kuchnia, Y), write(Y).
opis_miejsca(toaleta) :-
				write('Obecnie znajdujesz sie w toalecie,'), nl,
				write('Spedz tutaj tyle czasu ile potrzebujesz...'), nl,
				write('Z nikim tu nie porozmawiasz. Nie ma rowniez nic do zbadania'), nl.
opis_miejsca(korytarz) :-
				write('Obecnie znajdujesz sie na korytarzu,'), nl,
				write('mozesz porozmawiac z: '), miejsce_czlowiek(korytarz,X), write(X),nl;
				write('mozesz zbadac: '), miejsce_przeszukanie(korytarz, Y), write(Y).
opis_miejsca(taras) :-
				write('Obecnie znajdujesz sie na tarasie,'), nl,
				write('mozesz porozmawiac z: '), miejsce_czlowiek(taras,X), write(X),nl,
				write('mozesz zbadac: '), miejsce_przeszukanie(taras, Y), write(Y).

zbadaj(X) :-
				pozycja(Y), miejsce_przeszukanie(Y, X), aktywuj(X), !.
zbadaj(_) :-
				write('Nie moge tego znalezc').

aktywuj(list):-
				write('Tresc listu: '), nl,
				write('Nienawidze Cie! Zaplacisz za to co zrobiles'),nl,
				write('Podpis: M.'),nl.
aktywuj(szkatulka) :-
				write('Szkatulka jest pusta, niezniszczona. Zostala otwarta kluczem').
aktywuj(skrytka) :-
				write('Ukryty byl w niej klucz do szkatulki. Zostala kompletnie zniszczona. Ktos kto to zrobil musial miec duzo sily.').
aktywuj(tv)		:-
				write('Wiadomosci nie pokazuja nic ciekawego...'),nl.
aktywuj(szafka) :-
				write('Brawo! Znalazles klucz!'),nl, dodaj(klucz).
aktywuj(plaszcz) :-
				write('To plaszcz Magdy, chyba planuje szybkie wyjscie z przyjecia').
aktywuj(popielniczka) :-
				write('Mnostwo papierosow. Przyjecie trwa od niedawna, a nikt z domownikow nie pali. Ktos musial byc mocno zestresowany.'),nl.

porozmawiaj(X) :-
				rozmowa(Z), pozycja(Y), miejsce_czlowiek(Y,X), opcje_dialog(X),
				retract(rozmowa(Z)), assert(rozmowa(X)), !.
porozmawiaj(_) :-
				write('W tym pomieszczeniu nie ma tej osoby'),nl.

opcje_dialog(cezary) :-
				write('Kogo obstawiasz za zlodziejaszka?'),nl,
				write('*Jesli jestes pewien to napisz: zlodziejaszek(imie_zlodziejaszka).'),nl.
				
opcje_dialog(ania) :-
				write('Czesc, co slychac? Tak dawno Cie nie widzialam'),nl,
				write('*Pytania: '),nl,
				write('* 1. Czy widzialas cos podejrzanego? '),nl,
				write('* 2. Jaka masz relacje z Cezarym? '),nl.
opcje_dialog(radek) :-
				write('Jak milo Cie widziec! Mow co u Ciebie'),nl,
				write('*Pytania: '),nl,
				write('* 1. Czy widziales cos podejrzanego? '),nl,
				write('* 2. Jaka masz relacje z Cezarym? '),nl,
				write('* 3. Czy wiesz cos o pierscieniu? '),nl.
opcje_dialog(monika) :-
				write('Hej, wiesz co jestem troszke zajeta...'),nl,
				write('*Pytania: '),nl,
				write('* 1. Czy widzialas cos podejrzanego? '),nl.
opcje_dialog(dominika) :-
				write('Czesc! Smakowalo Ci jedzonko?'),nl,
				write('*Pytania: '),nl,
				write('* 1. Czy widzialas cos podejrzanego? '),nl,
				write('* 2. Czy wiesz cos o pierscieniu? '),nl,
				write('* 3. Wiesz kto mogl chciec zagrozic Czarkowi? '),nl.
opcje_dialog(magda) :-
				write('Tak? Wiesz co, spiesze sie..'),nl,
				write('*Pytania: '),nl,
				write('* 1. Czy widzialas cos podejrzanego? '),nl,
				write('* 2. Jaka masz relacje z Cezarym? '),nl.
opcje_dialog(filip) :-
				write('Witaj.. Chcesz moze jednego papierosa? Nie bede musial palic tu sam.'),nl,
				write('*Pytania: '),nl,
				write('* 1. Czy widziales cos podejrzanego? '),nl,
				write('* 2. Jaka masz relacje z Cezarym? '),nl.
zadaj_pytanie(X) :-
				rozmowa(Y), odpowiedz(X,Y).

odpowiedz(1,filip) :-
				write('Nie. Jestem tutaj prawie od poczatku przyjecia'),nl.	
odpowiedz(2,filip) :-
				write('Jestesmy najlepszymi przyjaciolmi.'),nl,
				znajdz_rozmowa(rozmowa_z_magda),
				write('-----------------------------------------------'), nl,
				write('* Mozesz pytac dalej: '), nl,
				write('* 3. Twoja zona twierdzi co innego. Opowiesz o tym jak ostatnio wyglada wasza relacja?'),nl,
				write('* 4. Slyszales moze o rodzinnym pierscieniu Cezarego?'),nl, !.
odpowiedz(2,filip) :-
				write('Jestesmy najlepszymi przyjaciolmi.'),nl.	
odpowiedz(3,filip) :-
				write('Masz racje... Stracilem prace, i to zwolnil mnie moj najlepszy przyjaciel. Zostalem bez srodkow do zycia.'),nl,
				write('Pogubilem sie. Wiem, ze to bylo potrzebne. Jemu zalezy na tej firmie. Cezary oferuje pomoc w odnalezieniu czegos nowego'),nl,
				write('To rewelacyjny przyjaciel ...ale ja stracilem nadzieje.'),nl.
odpowiedz(4,filip) :-
				write('*Chwila przerwy'),nl,
				write('Tak. Cezary wspominal mi, ze ostatnio przejal pierscien po swojej babci.'),nl,
				write('-----------------------------------------------'), nl,
				write('* Mozesz pytac dalej: '), nl,
				write('* 5. Wiesz, ze jest dla niego bardzo cenny? Nie widziales pierscienia ostatnio?'),nl,
				write('* 6. To Twoja wina! Oddawaj pierscien zlodziejaszku!'),nl.
odpowiedz(5,filip) :-
				write('Widzialem, tak ogromnie przepraszam...'),nl,
				write('Oddam Ci go. Nie wiem co wpadlo mi go glowy. Nie poznaje siebie'),nl,
				dodaj(pierscien).
odpowiedz(6,filip) :-
				write('Nie prosze! To nie ja!!'),nl.
odpowiedz(1,magda) :-
				write('Nie mam czasu z Toba rozmawiac. Nic nie widzialam'),nl.
odpowiedz(2,magda) :-
				write('Okropny czlowiek! Nie wiem co ja tu robie! Filip nalegal zeby przyjsc, ale ja mu nadal nie wybaczylam!'),nl,
				dodaj_rozmowe(rozmowa_z_magda),
				write('-----------------------------------------------'), nl,
				write('* Mozesz pytac dalej lub oskarzyc: '), nl,
				write('* 3. Czy moge wiedziec co takiego sie wydarzylo miedzy wami?'),nl,
				write('* 4. Hmm.. wiesz ze pierscien zaginal? Mysle, ze wlasnie znalazlem osobe z motywem!'),nl.
odpowiedz(3,magda) :-
				write('Zwolnil mojego kochanego! A tak sie staral! On na to nie zasluzyl'), nl,
				write('Przezywamy okropny czas. Jak tak dalej pojdzie nie bedziemy mieli za co zyc!'), nl.
odpowiedz(4,magda) :-
				write('Slucham?! Nie wiem nic o zadnym pierscieniu! Przezywam okropne chwile, a Ty masz czelnosc mnie oskarzac!'),nl,
				write('* Dostajesz w twarz od Magdy, ostrozniej z oskarzeniami'),nl.
odpowiedz(1, dominika) :-
				write('Nie bardzo. Caly czas spedzam w kuchni.'),nl,
				write('Zapomnialam kompletnie! Jezeli chcialbys wyjsc na taras, klucz jest na polce.').
odpowiedz(2, dominika) :-
				write('Czarek Ci powiedzial? To miala byc tajemnica. Czulby sie bezpieczniej gdyby nikt o tym nie wiedzial '),nl,
				write('Och! Nie wiedzialam, ze zniknal. Nikt nie widzial o nim oprocz nas'),nl.
odpowiedz(3, dominika) :-
				write('Jest takim kochanym czlowiekiem, nie ma wrogow.'), nl,
				write('Jedynie... ostatnio musial zwolnic swojego najlepszego przyjaciela.'),nl,
				write('To byla trudna decyzja, ale Filip zrozumial.'),nl,
				write('Nawet nie maja sobie nic za zle. Filip pojawil sie na przyjeciu :) '),nl.
odpowiedz(1,ania) :-
				write('Czyzby cos sie stalo? Wczesniej bylam pomoc Dominice w kuchni. Nic nie widzialam.'),nl.
odpowiedz(2,ania) :-
				write('Jest bratem mojego meza. Nigdy nie spotkalo mnie nic nieprzyjemnego z jego strony.'),nl,
				write('Mysle ze to bardzo wartosciowy czlowiek.').
odpowiedz(1,radek) :-
				write('Ja? Och nie... zupelnie nic nie widzialem.'),nl.
odpowiedz(2,radek) :-
				write('No wiesz co? To moj brat. Lubie go oczywiscie, choc czasam potrafi zajsc mi za skore'),nl,
				write('Ostatnio stal sie jakis dziwny. Zmarla nasza babcia. Zostawila w spadku bardzo drogocenny pierscien'),nl,
				write('Byl w mojej rodzinie od dawna... '), nl,
				write('...ale slad po nim zaginal. Mozliwe ze Cezarego to zalamalo. Wiem, ze go pragnal.'), nl,
				write('Ja sie tym nie przejalem. I tak w pierwszej kolejnosci przypadlby mojemu bratu...'), nl.
odpowiedz(3,radek) :-
				write('Ja? Ech... nie, za duzo nie wiem. Nalezal do mojej babci, byl bardzo duzo warty.'),nl,
				write('ktos moglby sie na nim mocno wzbogacic'), nl,
				write('-----------------------------------------------'), nl,
				write('* Mozesz pytac dalej lub oskarzyc: '), nl,
				write('* 4. Nie czujesz zalu, ze przypadl twojemu bratu?'),nl,
				write('* 5. Hmm.. wiesz ze pierscien zaginal? Mysle, ze wlasnie znalazlem osobe z motywem!'),nl.
odpowiedz(4,radek) :-
				write('Oczywiscie, ze nie mam zalu. Zycze mojemu bratu jak najlepiej.'),nl,
				write('Mialbym chyba zal jakby chcial zachowac ten staroc w rodzinie. To tylko pierscien...'),nl,
				write('Mojemu bratu znacznie bardziej przydalaby sie jego wartosc'),nl,
				write('Wiesz, ze otworzyl firme? To jest gosc!'),nl.
odpowiedz(5,radek) :-
				write('Jak smiesz! To zaden motyw!'),nl,
				write('Za takie bezpodstawne oskarzenia nalezy Ci sie lanie!'),nl,
				write('* Wlasnie pobil Cie Radek, ostrozniej z oskarzeniami.'),nl.
odpowiedz(1,monika) :-
				write('Cos mowiles? Eeee....'),nl,
				write('Podejrzanego? Nie, umarlabym z nudow obserwujac co tu sie dzieje. Wole grac w Stardew Valley na telefonie.'),nl,
				write('Zobacz tylko.. o wiele ciekawsze niz wasze zajecia.'),nl.
odpowiedz(_,_) :-
				write('Mie ma takiego pytania.'),nl.
zlodziejaszek(filip) :-
				znajdz_torebka(pierscien),
				write('Brawo! Udalo Ci sie rozwiazac zagadke!'),nl, !.
zlodziejaszek(_) :-
				write('Przykro mi, ta osoba jest niewinna'),nl.
