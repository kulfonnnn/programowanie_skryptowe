#!/bin/bash


host=$(hostname)
test() {
	echo "Aktualna data na $host to $(date)"
	echo "Wersja linuxa na $host to $(uname -r)"
	echo "Użytkownik aktualnie używający $host to $(whoami)"
	echo "Jego adres IP (na urządzeniu $host ) to $(hostname -I)"
}

test


