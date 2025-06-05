#!/bin/bash

#dane logowania do FTP
user=<user>
haslo=<haslo> #nie mozna uzyc read, bo cron go nie obsluzy

#deklaracja plikow/folderow
ftp_folder="backup_lab10"
docelowy_folder="/home/kulfon/skryptowe/lab10/pobrane_pliki/"
host="localhost"


#usuniecie aktualnie pobranych danych (chcemy je zmienic na nowe)
rm -rf "$docelowy_folder"*


#pobranie wszystkich plików z folderu FTP
#używam wget zamiast curla, bo pozwala na sciagniecie wiekszej liczby plikow w latwy sposob
wget -q --ftp-user="$user" --ftp-password="$haslo" -r -nH --cut-dirs=1 ftp://"$host"/"$ftp_folder/" -P "$docelowy_folder"
