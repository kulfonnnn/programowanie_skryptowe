#!/bin/bash


#deklarowanie scieżki do logów
LOG="/var/log/auth.log"

#deklarowanie słów do wyszukania w logach
KEYWORDS="Failed password|Invalid user|authentication failure"


tail -F "$LOG" | grep --line-buffered -E "$KEYWORDS" >> "raport2.txt"
