#!/bin/bash

read -p "podaj liczbe, a ja sprawdze jej znak i parzystość " liczba

if (( $liczba > 0 && $liczba%2 == 1 )); then
       	echo "liczba jest dodatnbia i nieparzysta"
else
	echo "liczba nie jest I dodatnia I nieparzysta"
fi
