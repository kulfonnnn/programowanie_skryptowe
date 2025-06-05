#!/bin/bash

date=$(date)
maxram=$(free -h | awk '{print $2}' | head -n 2 | tail -n 1)
pamiec=$(df -h | grep "^/dev/" | awk '{print $1, $3, $4}')
system=$(hostnamectl | grep "System" | cut -d' ' -f3,4,5)



generowanie () {
echo "RAPORT AKTUALNEGO ZUŻYCIA KOMPUTERA."
echo
echo "Wygenerowano:"
echo $date
echo
echo "Pamięć RAM: $maxram"
echo
echo "Wykorzystanie dysków: "
echo "(format: nazwa_dysku  zajęta_przestrzeń wolna_przestrzeń)"
echo $pamiec
echo
echo "Nazwa Hosta:"
echo $HOSTNAME
echo
echo "Nazwa Systemu Operacyjnego:"
echo $system

}

generowanie > /home/kulfon/lab3/system_info.txt
