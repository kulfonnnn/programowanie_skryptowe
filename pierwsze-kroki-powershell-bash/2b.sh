#!/bin/bash


read -p "Podaj nazwe pliku: " nazwa

if [[ -e $nazwa ]]; then
	echo "Plik $nazwa istnieje"

	if [[ -d $nazwa ]]; then
		echo "Plik jest katalogiem"
		if [[ -z $(ls -A "$nazwa") ]]; then #-z sprawdza czy to po tym jest puste, ls -a zwraca wszystkie pliki z katalogu, a A powoduje ze gdy ich nie ma to nic nie jest zwracane
			echo "Katalog $nazwa jest pusty"
		else
			echo "Katalog $nazwa nie jest pusty"
		fi
	else
		echo "Plik nie jest katalogiem"

		if [[ -s $nazwa ]]; then
			echo "Plik nie jest pusty" 
		else 
			echo "Plik jest pusty"
		fi	
	fi
else
	echo "Plik $nazwa nie istnieje"
fi


