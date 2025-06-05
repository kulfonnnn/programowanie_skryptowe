#!/bin/bash

#funkcja nie przyjmuje zadnych argumentow
#funkcja sprawdza dostepne aktualizacje i je pobiera
update_upgrade() {
echo "Sprawdzam dostępne aktualizacje:"
sudo apt update
echo "Instaluje dostępne aktualizacje:"
sudo apt upgrade -y
#flaga y=yes automatycznie zatwierdza instalacje (nie trzeba potwierdzac)
}

klient_pocztowy() {
	echo "Instaluje klienta pocztowego"
	sudo apt install thunderbird -y
}

#funkcja przyjmuje 2 argumenty (nazwa uzytkownika, haslo)
#funkcja tworzy nowego uzytkownika w systemie 
add_user() {
sudo useradd -m $1 #-m -> make home directory, tworzy katalog w home (taki pulpit)
#jezeli nie uzyjemy -m, mozemy po prostu dodac komende mkdir /home/username (bez tego folderu nie da sie logowac)
echo $1:$2 | sudo chpasswd
echo "Stworzyłem konto $1 i założyłem tam hasło"
}

#funkcja przyjmuje jedna argumentow (nazwe uzytkownka)
#funkcja tworzy katalogi Documents, Pictures I videos dla nowego uzytkownika
#te katalogi sa samoistnie tworzone przez GUI, dlatego instrukcja warunkow sprawdza czy juz sa
#a jak sa to sie nie beda tworzyc zeby nie wyswietlac bledow
katalogi() {
if [[ ! -d /home/$1/Documents ]]; then
	sudo mkdir /home/$1/Documents
	sudo chown $1:$1 /home/$1/Documents

fi	
if [[ ! -d /home/$1/Pictures ]]; then
	sudo mkdir /home/$1/Pictures
	sudo chown $1:$1 /home/$1/Pictures

fi	
if [[ ! -d /home/$1/Videos ]]; then
	sudo mkdir /home/$1/Videos
	sudo chown $1:$1 /home/$1/Videos
#-d = directory, sprawdza czy sciezka prowadzi do katalogu
fi

#tutaj nigdy sie nic nie stworzy, wiec dodam jeden folder, zeby sie cos dzialo
sudo mkdir /home/$1/tajne_dokumenty
sudo chown $1:$1 /home/$1/tajne_dokumenty

}

system_info() {

wersja_systemu=$(hostnamectl | grep "System" | cut -d' ' -f3,4,5)
adres_IP=$(ifconfig | head -n 2 | tail -n 1 | awk '{print $2}')
adres_MAC=$(ifconfig | head -n 6 | tail -n 1 | awk '{print $2}')

echo "Wersja systemu: $wersja_systemu"
echo "Adres IP = $adres_IP"
echo "Adres MAC = $adres_MAC"

}

#funkcja glowna
main() {
read -p "Podaj nazwe użytkownika, którego stworzę: " login
read -s -p "Podaj hasło, jakie dodam do tego konta: " passwd
echo


update_upgrade
klient_pocztowy
add_user $login $passwd
katalogi $login
system_info
}

main
