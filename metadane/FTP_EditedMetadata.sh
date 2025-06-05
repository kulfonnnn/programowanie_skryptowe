#!/bin/bash


#deklaracja danych lokowania/sciezek folderow
read -p "Podaj sciezke do katalogu: " folder
read -p "Podaj adres serwera FTP: " adres
read -p "Podaj login na serwer FTP: " login
read -s -p "Podaj haslo: " haslo
echo
echo
folder_docelowy="backup_lab10"

#tekst zapisuje jako lista, automatycznie jest rozdzielany jako kazde slowo osobno
lista=(W Bashu skrypt płynie jak rzeka wartka w PowerShellu magia każda linijka twarda Pętle tańczą w rytm zmienne śpiewają funkcje jak czary co świat nam odmieniają Logika gęsta jak las pełen zwrotów debug i test to nasze powroty Wiersze kodu płyną jak rym w poezji każdy skrypt to klucz do cyfrowej kreacji Gdy problem się zbliża nie ma co marudzić bo w skryptowym świecie potrafimy czarować i budzić)  


#dla kazdego pliku w katalogu
for plik in "$folder"/*; do 
	echo "Aktualnie pole description w "$plik" wygląda tak:"
	echo $(exiftool -Description "$plik")
	
	read -p "Czy chcesz zmienic pole przed wyslaniem pliku na serwer FTP (y/n)? " temp

	#jezeli chcesz zmienic opis..
	if [[ "$temp" == "y" ]]; then
		read -p "Podaj nowy tekst do zmiany pola Description: " opis
		
		#wylosowanie miejsca z listy i utworzenie slowa
		numer=$(( RANDOM % ${#lista[@]} ))
		slowo=${lista[$numer]}
		
		#utworzenie nazwy do nowego pliku
		new_file="${slowo}_$(basename "$plik")"
		
		#zmienienie metadanych w pliku i wyslanie zmienionego na serwer
		exiftool -Description="$opis" -o "$new_file" "$plik"
		curl -T "$new_file" ftp://$login:$haslo@$adres/$folder_docelowy/
		echo "Wysłałem plik "$new_file""

		#usuniecie pliku ze zmianami lokalnie
		rm "$new_file"

	else	
		#jezeli nie, to plik wysylany jest bez opisu
		curl -T "$plik" ftp://$login:$haslo@$adres/$folder_docelowy/
		echo "Wyslalem plik "$plik""
		
	fi
	echo
done
