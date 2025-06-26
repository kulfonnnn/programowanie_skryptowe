import json
import requests
from datetime import datetime
from datetime import timedelta

NAZWA_PLIKU = "zadania.json"

#funkcja do wczytywania zadan z pliku json
def wczytaj_zadania():
    try: #obsluga bledu jesli plik nie istnieeje
        with open(NAZWA_PLIKU, "r") as plik: #otwieranie pliku w trybie odczytu
            return json.load(plik) #zwraca liste zadan
    except FileNotFoundError: #jesli plik nie istnieje
        return [] #zwraca pusta liste (dzieki temu program dziala nawet jesli plik nie istnieje)

#funkcja do zapisywania zadan do pliku json
def zapisz_zadania(lista_zadan):
    with open(NAZWA_PLIKU, "w") as plik:
        json.dump(lista_zadan, plik, indent=2) #sformatowanie do JSONA z wcieciem na 2 spacje


#funkcja do wyswietlania zadan
def pokaz_zadania(lista_zadan):
    for nr, zadanie in enumerate(lista_zadan):
        print(f"{nr+1}. {zadanie['tytul']} - {zadanie['data']} {zadanie['godzina']} - {zadanie['priorytet']}")
        if zadanie.get("cykliczne"): #dodatkowe info dla cyklicznych i przeterminowanych
            print("   (cykliczne)")
        if czy_przeterminowane(zadanie):
            print("   !!! Przeterminowane !!!")

#sprawdzanie czy zadanie jest przeterminowane
def czy_przeterminowane(zad):
    termin = datetime.strptime(zad["data"] + " " + zad["godzina"], "%Y-%m-%d %H:%M")
    return termin < datetime.now() #funkcja zwraca True jesli termin jest mniejszy niz teraz

#funkcja do dodawania zadan
def dodaj_zadanie():
    tytul = input("Tytuł: ")
    opis = input("Opis: ")
    data = input("Data (YYYY-MM-DD): ")
    godzina = input("Godzina (HH:MM): ")
    priorytet = input("Priorytet (niski/średni/wysoki): ")
    cykliczne = input("Powtarzanie cyklicznie co tydzień? (tak/nie): ").lower() == "tak" #dzieki .lower() input jest case insensitive
    return {
        "tytul": tytul,
        "opis": opis,
        "data": data,
        "godzina": godzina,
        "priorytet": priorytet,
        "cykliczne": cykliczne
    }


def edytuj_zadanie(lista_zadan):
    pokaz_zadania(lista_zadan)
    nr = int(input("Nr zadania do edycji: ")) - 1 # -1 poniewaz numeracja zaczyna sie od 1, a lista od 0
    lista_zadan[nr] = dodaj_zadanie() #tworzymy nowe zadanie w miejsce starego (nadpisywanie)

# funkcja do usuwania zadan
def usun_zadanie(lista_zadan):
    pokaz_zadania(lista_zadan) #wypisanie zadan, aby uzytkownik mogl wybrac
    nr = int(input("Nr zadania do usunięcia: ")) - 1
    del lista_zadan[nr]



def eksport_do_api(lista_zadan):
    for zadanie in lista_zadan: #dla kazdego zadania
        r = requests.post("https://jsonplaceholder.typicode.com/posts", json=zadanie) #wyslij je przez API
        print(f"Wyeksportowano ({zadanie['tytul']})")

def import_z_api():
    r = requests.get("https://jsonplaceholder.typicode.com/posts") #znowu testowe API
    dane = r.json()[:1]  #pobieramy tylko jedno zadanie
    z_importu = []
    for post in dane: #dodajemy zadanie w formacie zgodnym z naszymi wymaganiami
        z_importu.append({ 
            "tytul": post["title"], #tytul to title z API
            "opis": post["body"], #opis to body z API\
            #testowe API nie ma szczegolow w naszym formacie, wiec dodajemy jakies testowe wartosci
            "data": datetime.now().strftime("%Y-%m-%d"), #data to dzisiejsza data
            "godzina": "23:00", #godzina to 23:00 (moze byc inna, ale dla testow zostawiamy)
            "priorytet": "średni", 
            "cykliczne": False
        })
    return z_importu



# funkcja do filtrowania zadan
def filtruj_zadania(lista_zadan):
    filtr = input("Filtruj po (data/priorytet/status): ").lower()  # użytkownik podaje filtr (case insensitive)

    if filtr == "data": #jezeli filtr to data
        podana_data = input("Podaj datę (YYYY-MM-DD): ") #wybieramy date z ktorej chcemy zadania
        wynik = []
        for z in lista_zadan: #dla kazdego zadania
            if z["data"] == podana_data: #jezeli jego data jest taka jak podana
                wynik.append(z) #to dodajemy do wyniku
        return wynik #zwracamy wynik

    #analogicznie dla innych filtrow
    elif filtr == "priorytet":
        p = input("Podaj priorytet: ")
        wynik = []
        for z in lista_zadan:
            if z["priorytet"] == p:
                wynik.append(z)
        return wynik

    elif filtr == "status":
        s = input("status (przeterminowane/nadchodzące): ")
        wynik = []
        if s == "przeterminowane":
            for z in lista_zadan:
                if czy_przeterminowane(z):
                    wynik.append(z)
        else:
            for z in lista_zadan:
                if not czy_przeterminowane(z):
                    wynik.append(z)
        return wynik

    return lista_zadan


# funkcja do sortowania zadan
def sortuj_zadania(lista_zadan):
    kryterium = input("Sortuj po (data/priorytet): ")
    if kryterium == "data": #jezeli kryterium to data
            return sorted(lista_zadan, key=lambda z: z["data"] + z["godzina"])
            #zwraca posortowana liste zadan, sortuje wg daty i godziny, lambda z (argument) : data (wyrazenie, ktore zwraca)
    elif kryterium == "priorytet":
        slownik = {"niski": 1, "średni": 2, "wysoki": 3} #slownik zmieniajacy priorytet na liczby
        return sorted(lista_zadan, key=lambda z: slownik.get(z["priorytet"], 2), reverse=True) #sortowanie malejaco
            #dla kazdego zadania zczytaj priorytet, zamien na liczbe i posortuj  
    return lista_zadan


#obsluga cyklicznych zadan
def aktualizuj_cykliczne(lista_zadan):
    nowe_zadania = []
    for zad in lista_zadan: #dla kazdego zadania
        if zad.get("cykliczne") and czy_przeterminowane(zad): #jezeli zadanie jest cykliczne i przeterminowane
            stara_data = datetime.strptime(zad["data"], "%Y-%m-%d") #string do datetime
            nowa_data = stara_data + timedelta(days=7) #przesuwamy date o 7 dni
            zad["data"] = nowa_data.strftime("%Y-%m-%d") #datetime do stringa i dopisujemy do zadania
            nowe_zadania.append(zad)
        else:
            nowe_zadania.append(zad)
    return nowe_zadania






#glowna funkcja menu
def menu():
    zadania = wczytaj_zadania()
    zadania = aktualizuj_cykliczne(zadania)

    while True: #nieskonczona petla
        print("\n1. Pokaż\n2. Dodaj\n3. Edytuj\n4. Usuń\n5. Eksportuj do API\n6. Importuj z API\n7. Filtruj\n8. Sortuj\n9. Zakończ")
        wybor = input("Wybierz opcję: ")

        #odpowiednio dla wybranego numeru wykonujemy funkcje
        if wybor == "1":
            pokaz_zadania(zadania)
        elif wybor == "2":
            zadania.append(dodaj_zadanie())
            zadania = aktualizuj_cykliczne(zadania)
        elif wybor == "3":
            edytuj_zadanie(zadania)
            zadania = aktualizuj_cykliczne(zadania)
        elif wybor == "4":
            usun_zadanie(zadania)
        elif wybor == "5":
            eksport_do_api(zadania)
        elif wybor == "6":
            zadania += import_z_api()
        elif wybor == "7":
            pokaz_zadania(filtruj_zadania(zadania))
        elif wybor == "8":
            zadania = sortuj_zadania(zadania)
        elif wybor == "9":
            break
        else:
            print("Nieznana opcja.")

        zapisz_zadania(zadania)

menu()