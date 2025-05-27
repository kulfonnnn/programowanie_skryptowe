#Napisz skrypt, który zaszyfruje plik tekstowy np. algorytmem AES

from Crypto.Cipher import AES                     # Moduł do szyfrowania AES
from Crypto.Random import get_random_bytes       # Funkcja do generowania losowego IV
from Crypto.Util.Padding import pad              # Dopełnianie danych do wielokrotności bloku
import hashlib                                   # Do tworzenia klucza z hasła (SHA-256)


#otwieranie pliku do szyfrowania
with open("plik.txt", "r", encoding="utf-8") as f: #"utf-8" pozwala na polskie znaki
    tekst = f.read()# Odczytujemy plik jako tekst


#utworzenie parametrów do szyfrowania
haslo = input("Hasło: ").encode("utf-8") #pyta o hasło i koduje je do bajtów
klucz = hashlib.sha256(haslo).digest() # Tworzymy klucz AES z hasła (SHA-256)
iv = get_random_bytes(16) #generujemy losewe IV (16 bajtów dla AES)


#utworzenie obiektu szyfrującego
cipher = AES.new(klucz, AES.MODE_CBC, iv)
    #AES.new() — metoda tworząca nowy obiekt szyfrowania 
    #klucz — klucz szyfrowania, który wygenerowaliśmy z hasła.
    #AES.MODE_CBC — wskazujemy tryb pracy AES, tutaj CBC
    #iv — podajemy wcześniej wygenerowany iv (niezbędny w trybie CBC)

# Szyfrowanie danych
dane = tekst.encode("utf-8")
zaszyfrowane = cipher.encrypt(pad(dane, 16))
    #pad(dane, 16) — dodaje do danych dopełnienie tak, aby długość danych była wielokrotnością 16 bajtów

# Zapis do pliku 
with open("zaszyfrowane.bin", "wb") as f: #w=write=zapis, b=binary
    f.write(iv + zaszyfrowane)


print("Dane do sprawdzenia w CyberShefie")
print(f"Klucz: {klucz.hex()}")
print(f"IV: {iv.hex()}")
print("Zaszyfrowane dane:", zaszyfrowane.hex())