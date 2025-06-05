#!/bin/bash

#wczytywanie nazwy miasta
miasto=$1


#wyszukanie danych
#-w w grep powoduje ze wroclaw jest wynikiem a inowroclaw juz nie (tylko dokladne wyszukanie)
#-i = ignore case, -d okresla ze dane rozdiela tabulator, a -f wybiera kolumny
miasto_x_y=$(cat cities1000.txt | grep -wi "$miasto" | cut -d$'\t' -f2,5,6)

#walidacja wpisania poprawnych danych
if [[ -z $miasto_x_y ]]; then 
	echo "Raport pogodowy zakończony niepowodzeniem."
	echo "Podano niepoprawną nazwę miasta, lub nazwę miasta z ilością mieszkańców <1000"
	exit
fi

#utworzenie zmienny ze wspolrzednymi x i y, czyli x=lat=latitude, y=lon=longitude
lat=$(echo $miasto_x_y | cut -d' ' -f2)
lon=$(echo $miasto_x_y | cut -d' ' -f3)


#pobranie danych pogdowych dla danego miasta i
#-s wylacza postep pobirania=bardziej czytelne
dane=$(curl -s "https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=$lat&lon=$lon")


#wybranie odpowiednich danych przy pomocy jq
#timeseries[0] oznacza, ze to sa najbardziej aktualne dane (wypisane jako pierwsze)
#pozniejszą sciezke ustalilem na podstawie wypisanego jsona i akapitow ( z echo $dane | jq )
temperatura=$(echo $dane | jq '.properties.timeseries[0].data.instant.details.air_temperature')
wilgotnosc=$(echo $dane | jq '.properties.timeseries[0].data.instant.details.relative_humidity')


#zdobycie indeksów następnych dni (najpierw jest indeksowanie co 1h, a później co 6h więc ciężko to policzyć ręcznie)
#map wyświetla liste składającą się z samych dat kolejnych indeksów
#grep wyszukuje jutro i zwraca nr linii: linia
#cut wycina sam numer linii i jest to numer indeksu 
#nie zgadzalo mi sie indeksowanie o 2,a data byla poprawna -> po przeanalizowaniu wyniku z samym map zobaczylem, ze piersza linijka to [, a indeksowanie zacyzna sie od 0, wiec trzeba odjac -2
jutro=$(date -u -d "+1 day 12:00" +"%Y-%m-%dT%H:%M:%SZ") 
indeks_jutro=$(echo $dane | jq '.properties.timeseries | map(.time)' | grep -n -w ""$jutro"" | cut -d: -f1)
((indeks_jutro-=2))


pogoda_jutro=$(echo $dane | jq ".properties.timeseries[$indeks_jutro].data.instant.details")


#wypisywanie wczesniej stworzonych zmiennych, a petla for to w zasadzie skopiowane linijki z tworzenia jutra, wiec nie opisuje na nowo
raport_pogodowy() {

	echo "Raport pogodowy dla miasta "$miasto""
	echo
	echo "Aktualna temperatura (*C): $temperatura"
	echo
	echo "Aktualna wilgotność (%): $wilgotnosc"
	echo
	echo "Prognoza na najbliższe 5 dni (godzinę 12stą):"
	echo
	echo "Jutro:"
	echo
	echo $pogoda_jutro
	for i in {2..4}; do
		jutro=$(date -u -d "+$i days 12:00" +"%Y-%m-%dT%H:%M:%SZ") 
		indeks_jutro=$(echo $dane | jq '.properties.timeseries | map(.time)' | grep -n "$jutro" | cut -d: -f1)
		((indeks_jutro-=2))
		pogoda_jutro=$(echo $dane | jq ".properties.timeseries[$indeks_jutro].data.instant.details")
		echo
		echo "$jutro"
		echo
		echo $pogoda_jutro
			done
}

#wypisanie zawartosci funkcji do pliku raport.txt
raport_pogodowy > raport.txt

#przekonwertowanie pliku do pdf z uzyciem pandoc (-o = output, preserve tabs zachowuje uklad z enterami)
pandoc --preserve-tabs raport.txt -o raport.pdf

