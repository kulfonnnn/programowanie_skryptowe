#!/bin/bash


read -p "Podaj nazwe użytkownika: " login
read -p "Podaj hasło: " haslo

if [[ "$login" == "admin" && "$haslo" == "123pass" ]]; then
	echo "Poprawne dane, jesteś zalogowany!"
else
	echo "Błędne dane, odmowa dostępu."
fi
