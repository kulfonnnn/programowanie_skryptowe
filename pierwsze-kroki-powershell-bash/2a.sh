#!/bin/bash

user=$(whoami)
echo "Twoja nazwa użytkownika to $user"
if [[ "$user" == "admin" ]]
then
	echo "To jest konto admina"
else
	echo "To nie jest konto admin"
fi

