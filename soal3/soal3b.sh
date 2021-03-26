#!/bin/bash

folder="$(date '+%d-%m-%Y')"
mkdir $folder
bash /home/nor/sisop/s1/soal3a.sh
mv Koleksi* $folder
mv Foto.log $folder
