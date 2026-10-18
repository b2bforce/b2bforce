# Wzorce AI w polskiej prozie

Lista dla tekstów po polsku (`language: pl`), napisana od zera na podstawie polskich
tekstów generowanych przez modele. Rozbudowujesz ją po przeglądzie prawdziwego
tekstu: nowy wzorzec dopisujesz z przykładem, z którego wyszedł.

Siła (w raporcie `strong` / `weak`): **mocny** = flaguj przy pierwszym wystąpieniu; **słaby** = flaguj przy 2+
wystąpieniach na 300 słów albo w skupisku. Polska wersja reguł stop-slop: strona
bierna i przysłówki są w polszczyźnie naturalne, więc to sygnały, nie zakazy.

## O. Otwarcia i rozbiegi

| ID | Wzorzec | Przykłady | Siła | Co zamiast |
|---|---|---|---|---|
| PL-O01 | Otwieracz o epoce | „W dzisiejszym dynamicznym/cyfrowym/szybko zmieniającym się świecie”, „W erze AI”, „W dobie” | mocny | Zacznij od problemu albo wniosku |
| PL-O02 | Zapowiedź uwagi | „Warto zauważyć/podkreślić/wspomnieć/pamiętać, że”, „Należy zaznaczyć, że”, „Nie da się ukryć, że”, „Nie ma co ukrywać” | mocny | Usuń zapowiedź, zostaw treść |
| PL-O03 | Zapowiedź omówienia | „Przyjrzyjmy się bliżej”, „Spójrzmy na”, „W tym artykule przyjrzymy się/omówimy”, „Oto, co musisz wiedzieć”, „Zanurzmy się” | mocny | Od razu pierwsza informacja |
| PL-O04 | Wyreżyserowana szczerość | „Spójrzmy prawdzie w oczy:”, „Powiedzmy sobie szczerze”, „Bądźmy szczerzy” | mocny | Usuń |
| PL-O05 | Zaproszenie do wyobrażenia | „Wyobraź sobie, że…” na otwarcie | słaby | Opisz realny przypadek |
| PL-O06 | Pytanie-haczyk | „Brzmi znajomo?”, „Czy zastanawiałeś się kiedyś…?” | mocny | Usuń albo zamień na fakt |

## S. Słowa nadużywane

Tell to częstotliwość, nie samo słowo. Pojedyncze „istotny” jest w porządku.

| ID | Słowa | Siła | Co zamiast |
|---|---|---|---|
| PL-S01 | kluczowy, kluczowa rola, kluczem jest, klucz do sukcesu | słaby (mocny przy „klucz do sukcesu”) | Powiedz, co od tego zależy |
| PL-S02 | istotny, niezwykle, niezwykle ważny, ogromny (o abstrakcjach) | słaby | Liczba albo konsekwencja |
| PL-S03 | kompleksowy, holistyczny, innowacyjny, dynamiczny, nowoczesny, zaawansowany | słaby | Nazwij, co konkretnie obejmuje |
| PL-S04 | szereg (czegoś), szeroki wachlarz, cała gama, bogactwo możliwości | mocny | Liczba albo wymienienie |
| PL-S05 | odgrywa kluczową/istotną rolę, stanowi fundament, stanowi (zamiast „jest”) | mocny dla „odgrywa … rolę”, słaby dla „stanowi” | „jest”, „ma”, „decyduje o” |
| PL-S06 | rewolucja, rewolucjonizuje, przełomowy, game changer, przenosi na wyższy/nowy poziom, na nowo definiuje | mocny | Opisz zmianę i jej skalę |
| PL-S07 | synergia, optymalizacja (ogólnikowo), efektywność (bez miary), skalowalny, elastyczny | słaby | Co, o ile, w czym |
| PL-S08 | tak naprawdę, w rzeczywistości, de facto, prawdziwe wyzwanie, sedno sprawy, sekret tkwi w | mocny dla „sekret tkwi w”, słaby dla reszty | Usuń, zostaw twierdzenie |
| PL-S09 | Co więcej, Ponadto, Dodatkowo, Jednocześnie na początku kolejnych zdań | słaby | Połącz zdania albo zacznij od treści |
| PL-S10 | zarówno … jak i (w każdym akapicie), nie tylko … ale również | słaby | Wymień bez ramy |

## K. Konstrukcje

| ID | Wzorzec | Przykład | Siła | Co zamiast |
|---|---|---|---|---|
| PL-K01 | „To nie tylko X, to Y” / „To nie X, to Y” | „To nie tylko narzędzie, to filozofia pracy.” | mocny | Powiedz Y wprost |
| PL-K02 | „Nie chodzi o X, chodzi o Y” (też rozbite na dwa zdania) | „Nie chodzi o szybkość. Chodzi o kontrolę.” | mocny | Y wprost; kontrast tylko gdy ktoś realnie twierdził X |
| PL-K03 | Pytanie retoryczne i odpowiedź | „Dlaczego to ważne? Bo…”, „Co to oznacza? To proste:” | mocny | Zdanie twierdzące |
| PL-K04 | Odsłona z dwukropkiem | „Odpowiedź jest prosta:”, „Efekt? …”, „Wniosek jest jeden:” | mocny | Podaj odpowiedź bez zapowiedzi |
| PL-K05 | Trójki | trzy przymiotniki, trzy równoległe zdania, „szybko, tanio i skutecznie” | słaby (mocny przy 2+ trójkach w akapicie) | Dwa elementy albo tyle, ile jest naprawdę |
| PL-K06 | Puenta na końcu sekcji | „I to jest właśnie klucz do sukcesu.”, „To robi różnicę.”, „Proste.” | mocny | Usuń; sekcja kończy się ostatnim faktem |
| PL-K07 | Aforyzm zamiast twierdzenia | „Dane to nowa ropa.”, „Zaufanie buduje się latami.” | mocny | Konkretne twierdzenie |
| PL-K08 | Polemika z nikim | „Nie twierdzę, że…”, „Nie zrozum mnie źle”, „Nie oznacza to, że…” bez wcześniejszej tezy | mocny | Usuń albo nazwij, kto tak twierdzi |
| PL-K09 | Właśnie dlatego / To właśnie | „Właśnie dlatego warto…”, „To właśnie X sprawia, że…” | słaby | „Dlatego”, albo usuń |
| PL-K10 | Nominalizacje | „dokonać analizy”, „przeprowadzić wdrożenie”, „dokonać wyboru”, „w sposób efektywny” | słaby | Czasownik: przeanalizować, wdrożyć, wybrać, efektywnie |
| PL-K11 | Uniwersalny adresat | „Niezależnie od tego, czy jesteś X, czy Y…” | mocny | Pisz do jednego czytelnika z ICP |
| PL-K12 | Piętrowa asekuracja | „może potencjalnie”, „w pewnym sensie można by uznać” | mocny | Jedno zastrzeżenie albo żadne |
| PL-K13 | Bezosobowy autorytet | „Eksperci są zgodni”, „Badania pokazują” bez źródła, „Coraz więcej firm” | mocny | Nazwij źródło albo usuń |
| PL-K14 | Fałszywy zakres | „od małych firm po globalne korporacje”, „od strategii po wdrożenie” | słaby | Wymień, co naprawdę obejmuje |
| PL-K15 | Rzecz wykonuje ludzką czynność | „Dane mówią same za siebie”, „Strategia wymaga odwagi”, „Rynek nagradza” | słaby | Wskaż, kto działa |
| PL-K16 | Równoległe zdania jak hasło reklamowe | „Faza 1 daje nowe pliki. Faza 2 sprawia, że ktoś je zasila.” | mocny | Jedno zwykłe zdanie z relacją między członami |
| PL-K17 | Sentencja z wyliczeniem bez czasownika | „Mała zmiana, duże znaczenie.” | mocny | Powiedz, co i dlaczego się zmienia |

## Z. Zakończenia

| ID | Wzorzec | Siła | Co zamiast |
|---|---|---|---|
| PL-Z01 | „Podsumowując”, „Reasumując”, „Na zakończenie”, „Krótko mówiąc” jako otwarcie ostatniego akapitu | mocny | Ostatni akapit = następny krok czytelnika |
| PL-Z02 | „Mamy nadzieję, że ten artykuł…”, „Mam nadzieję, że pomogłem” | mocny | Usuń |
| PL-Z03 | Optymistyczna przyszłość | „Przyszłość rysuje się w jasnych barwach”, „Przyszłość należy do tych, którzy…”, „Jedno jest pewne” | mocny | Usuń, zakończ faktem |
| PL-Z04 | Resztki czatu | „Daj znać, jeśli…”, „Chętnie pomogę”, „Świetne pytanie!”, „Oczywiście!” | mocny | Usuń |
| PL-Z05 | Wezwanie bez treści | „Nie czekaj, zacznij już dziś!” | mocny | Konkretny krok: link, plik, polecenie |

## A. Kalki z angielskiego

| ID | Kalka | Siła | Po polsku |
|---|---|---|---|
| PL-A01 | na koniec dnia (at the end of the day) | mocny | ostatecznie, w praktyce |
| PL-A02 | robić sens / ma to sens (o wywodzie) | mocny / słaby | jest sensowne, ma uzasadnienie |
| PL-A03 | adresować problem | mocny | rozwiązywać, zajmować się |
| PL-A04 | dostarczać wartość, dowozić wartość | mocny | konkret: oszczędza X, daje Y |
| PL-A05 | w tym kontekście (bez wskazanego kontekstu), w kontekście X (= w sprawie X) | słaby | tu, w sprawie X |
| PL-A06 | dedykowany (= specjalny, osobny) | słaby | osobny, przeznaczony do |
| PL-A07 | robi różnicę (makes a difference) | mocny | zmienia wynik, wpływa na |
| PL-A08 | na ten moment, na chwilę obecną | słaby | teraz, obecnie |
| PL-A09 | finalnie, generalnie (jako wata) | słaby | w końcu / usuń |
| PL-A10 | implementować (proces, zmianę) | słaby | wdrażać, wprowadzać |
| PL-A11 | bazować na | słaby | opierać się na |
| PL-A12 | gra toczy się o, wygrać grę | słaby | chodzi o (konkret) |
| PL-A13 | utykać, utknąć, utknięcie (kalka „stall”, „get stuck”) o sprzedaży, zakupie, projekcie, firmie | mocny | stanąć, zatrzymać się, nie rosnąć, rosnąć wolniej, przeciągać się, nie ruszyć z miejsca |

## F. Forma i formatowanie

| ID | Wzorzec | Siła | Co zamiast |
|---|---|---|---|
| PL-F01 | Pogrubienia jako ozdoba (kilka na akapit, bez funkcji) | mocny przy 3+ w akapicie | Bez bold albo jeden na sekcję |
| PL-F02 | Lista z pogrubioną etykietą i dwukropkiem w każdym punkcie | mocny | Proza albo lista bez etykiet |
| PL-F03 | Emoji i strzałki (→) w nagłówkach lub punktach | mocny | Usuń |
| PL-F04 | Wielkie Litery W Nagłówkach (Title Case) | mocny | Po polsku wielka litera tylko na początku i w nazwach |
| PL-F05 | Lista tam, gdzie wystarczy zdanie (2–3 krótkie punkty, które są jedną myślą) | słaby | Jedno zdanie |
| PL-F06 | Nagłówek powtórzony w pierwszym zdaniu sekcji | mocny | Usuń pierwsze zdanie |
| PL-F07 | Nagłówki-pytania w każdej sekcji | słaby | Nagłówek niosący informację |

## T. Typografia

Uwaga: w polszczyźnie myślnik (półpauza ze spacjami: „ – ”) jest normalnym znakiem
interpunkcyjnym i występuje częściej niż w angielskim. Nie flagujesz go odruchowo.

| ID | Wzorzec | Siła | Co zamiast |
|---|---|---|---|
| PL-T01 | Pauza bez spacji jak w angielskim („słowo—słowo”) | mocny | „ – ” albo przecinek, kropka, dwukropek |
| PL-T02 | Myślnik zamiast przecinka lub kropki w większości zdań (gęstość powyżej wytycznych treści albo 1+ na 2 zdania) | słaby | Przecinek, kropka, nawias |
| PL-T03 | Angielskie cudzysłowy "…" w tekście polskim | słaby | „…” |
| PL-T04 | Wielokropek i wykrzyknik jako emocja w tekście eksperckim | słaby | Usuń |

## Jak dopisywać wzorce

1. Wzorzec musi pochodzić z prawdziwego tekstu (cytat w kolumnie przykładów).
2. Nadaj kolejne ID w kategorii, nie przenumerowuj istniejących (raporty się do nich odwołują).
3. Wpisz siłę i jedno „co zamiast”. Jeśli nie umiesz podać zamiennika, to nie jest wzorzec, tylko gust.
