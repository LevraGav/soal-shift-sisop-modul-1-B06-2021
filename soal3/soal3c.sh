#!/bin/bash

kucing=$(find Kucing* 2> /dev/null | wc -l)                                                                     
kelinci=$(find Kelinci* 2> /dev/null | wc -l)                                                                   
if (( kucing == kelinci )); then
	folder="Kucing_$(date '+%d-%m-%Y')"
	mkdir $folder
	cd $folder
	for loop in {1..23}; do
		wget -O Koleksi_$loop -a "Foto.log" https://loremflickr.com/320/240/kitten
		max=$loop
		for (( i=1; i<max; i++ )) do
			if [ -f Koleksi_$i ]; then
				if cmp Koleksi_$i Koleksi_$loop &> /dev/null; then
					rm Koleksi_$loop
					break
				fi
			fi
		done
	done

	for loop in {1..23}; do
		if [ ! -f Koleksi_$loop ]; then
			for (( i=23; loop<i; i-- )) do
				if [ -f Koleksi_$i ]; then
					mv Koleksi_$i Koleksi$loop
					break
				fi
			done
		fi
	done

	for loop in {1..9}; do
		mv Koleksi_$loop Koleksi_0$loop
	done
elif (( kucing > kelinci )); then
	folder="Kelinci_$(date '+%d-%m-%Y')"
	mkdir $folder
	cd $folder
	for loop in {1..23}; do
		wget -O Koleksi_$loop -a "Foto.log" https://loremflickr.com/320/240/bunny
		max=$loop
		for (( i=1; i<max; i++ )) do
			if [ -f Koleksi_$i ]; then
				if cmp Koleksi_$i Koleksi_$loop &> /dev/null; then
					rm Koleksi_$loop
					break
				fi
			fi
		done
	done

	for loop in {1..23}; do
		if [ ! -f Koleksi_$loop ]; then
			for (( i=23; loop<i; i-- )) do
				if [ -f Koleksi_$i ]; then
					mv Koleksi_$i Koleksi$loop
					break
				fi
			done
		fi
	done

	for loop in {1..9}; do
		mv Koleksi_$loop Koleksi_0$loop
	done
fi
