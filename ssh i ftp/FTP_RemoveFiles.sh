#!/bin/bash


#dane logowania do FTP
user=<user>
haslo=<haslo> #nie mozna uzyc read, bo cron go nie obsluzy

#lokalizacja serwera
host="localhost"
FTP_folder="backup_lab10"

#pobranie listy plików z serwera (posortowanych wg daty)
pliki=$(lftp -u "$user","$haslo" "$host"/"$FTP_folder" -e "cls -l; bye")
#-e = execute
#bye -> konczy dzialanie bez wyswietlania CLI w terminalu


while read -r linijka; do
	#wyciaganie daty
	data_plik=$(echo $linijka | awk '{print $6, $7}')
	plik=$(echo $linijka | awk '{print $9}')
	
	#stworzenie timestampow
	data_teraz=$(date +%s)
	data_plik_timestamp=$(date -d "$data_plik" +%s)

	#oblcizenie roznicy w czasie i zmiana jej na dni
	roznica=$((($data_teraz - $data_plik_timestamp)/86400))
	
	#usuwanie starszych plikow
	if [[ $roznica -gt 30 ]];then
		echo "Plik $plik jest stary jak swiat i wyrzucam go na smietnik"
		lftp -u "$user","$haslo" "$host"/"$FTP_folder" -e "rm "$plik"; bye"
	fi
	

done <<< "$pliki"
