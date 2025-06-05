#!/bin/bash


#deklarowanie danych logowania
user=$(whoami)
adres="localhost"
key="/home/kulfon/.ssh/id_rsa"

#deklaracja komend do wykonania (lepiej wykonać wszystkie jednym połączeniem)
COMMANDS="ps aux | head -n 5; ls -l; cd skryptowe; ls"


#nawiązanie połączenia
ssh -i "$key" "$user@$adres" "$COMMANDS" > output.txt

#zakończenie połączenia
exit
