#!/bin/bash


#podaj twoj klucz API
api=c0fc81f751e1b2de6437f94ca97d9463f2ae822d7995be5ee4e9eb4455def039


#wczytywanie pliku
read -p "Podaj nazwe pliku, a jeżeli jesteś w innym katalogu to ścieżkę: " file

#sprawdzanie, czy plik istnieje
if [[ ! -f $file ]]; then
	echo "Plik nie istnieje"
	exit
fi

#obliczenie sumy kontrolnej
hash=$(sha256sum $file | awk '{print $1}')

#wysłanie zapytania do virustotal
scan=$(curl "https://www.virustotal.com/api/v3/files/$hash" -H "x-apikey: $api")

#wstępne opracowanie wyników przez jq
result=$(echo "$scan" | jq '.data.attributes.last_analysis_stats.malicious')

#sprawdzenie, czy plik znajduje sie w bazie virustotal
if [[ -z $result || $result == "null" ]]; then
	echo "Nie moge ci pomóc, plik prawdopodobnie nie znajduje sie w bazie wirustotal"
fi

#sprawdzenie, czy plik jest bezpieczny
if [[ $result -eq 0 ]]; then
	echo "Twój plik jest bezpieczny, możesz go śmiało otworzyć!"

elif [[ $result -gt 0 ]]; then
	echo "UWAGA! Twój plik nie jest bezpieczny. Nie otwieraj go. Wykryto $result zagrożeń."

else 
	echo "Nie udało mi się określić, czy twój plik jest bezpieczny :("
fi

