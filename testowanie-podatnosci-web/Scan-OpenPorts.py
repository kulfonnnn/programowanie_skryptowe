

import socket #do nawiazania poleczen sieciowych



#wczytywanie danych
adres=input("Podaj adres IP do przeskanowania \n")
first_port=int(input("Podaj port, od ktorego zaczynamy skanowanie: \n"))
last_port=int(input("Podaj port, na ktorym konczymy skanowanie: \n"))



#dla kazdego portu
for port in range(first_port, last_port + 1):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #nowy obiekt dla ipv4 i TCP
    s.settimeout(1) #zapobieganie nieskonczonemu skanowaniu
    wynik=s.connect_ex((adres,port)) #proba poleczenia sie z adresem na porcie, ex powoduje brak errrora
    
    if (wynik==0):
        print (f"Port nr {port} jest otwarty")
    s.close()
