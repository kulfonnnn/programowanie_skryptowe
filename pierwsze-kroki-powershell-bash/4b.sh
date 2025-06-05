#!/bin/bash

i=0
while ((i<10)) do 
        echo "192.168.1.$i"
	i=$(( i+1 ))

done
