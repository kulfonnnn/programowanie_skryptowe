#!/bin/bash



read -p "Podaj ścieżkę pliku do sprawdzenia: " plik


echo "Metadane pliku:"
exiftool "$plik"
