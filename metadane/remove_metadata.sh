#!/bin/bash

read -p "Podaj ścieżkę do pliku: " plik


echo "Usuwam metadane z pliku "$plik".."
exiftool -all= "$plik"
echo "Usunalem metadane z pliku."
