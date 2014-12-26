#!/bin/bash 


for i in $(seq 1 100)
do
	x=$(($RANDOM%100))
	y=$(($RANDOM%100))
	z=$(($RANDOM%10))
	if [ $(($z%2)) == 0 ]; then
		a="+"	
	else
		a="-"
	fi
	if [ $x -lt $y ]; then
		a="+"
	fi
	echo "$x $a $y = "
done
