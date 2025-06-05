#!/bin/bash


#deklaracja plikow
folder_wysylany="/home/kulfon/skryptowe/lab10/wazne_pliki"
plik_docelowy="backup_lab10"
archiwum="/home/kulfon/backup_lab10/archiwum.tar.gz"


#deklaracja danych do FTP
user="kulfon"
read -s -p "podaj haslo: " haslo
echo
adres="localhost"

#stworzenie archiwum (skopresowanej wersji folderu)
tar -czf "$archiwum" -C "$folder_wysylany" .



#wyslanie archiwum do serwera ftp
curl -T "$archiwum" ftp://$user:$haslo@$adres/
echo "Wysłałem archiwum na serwer FTP"

