# soal-shift-sisop-modul-1-B06-2021
Laporan Penyelesaian Pengerjaan Soal Praktikum SISOP Modul 1 - Kelompok B06

## File .sh
- [Soal 1](https://github.com/LevraGav/soal-shift-sisop-modul-1-B06-2021/tree/main/soal1)
- [Soal 2](https://github.com/LevraGav/soal-shift-sisop-modul-1-B06-2021/tree/main/soal2)
- [Soal 3](https://github.com/LevraGav/soal-shift-sisop-modul-1-B06-2021/tree/main/soal3)

# --- No 1 ---
## Pengerjaan
```bash
#!bin/bash

#Cari semua line error dan count berapa kali keluar
perm="$(grep -o "Permission denied while closing ticket" syslog.log | wc -l)"
notexist="$(grep -o "Ticket doesn't exist" syslog.log | wc -l)"
failedcon="$(grep -o "Connection to DB failed" syslog.log | wc -l)"
modify="$(grep -o "The ticket was modified while updating" syslog.log | wc -l)"
close="$(grep -o "Tried to add information to closed ticket" syslog.log | wc -l)"
timeout="$(grep -o "Timeout while retrieving information" syslog.log | wc -l)"

#print error tersebut dan sort kolom 2 dengan menggunakan fungsi sort dan menggunakan , sebagai delimiter lalu sed Error, Count di line 1
printf "Permission denied while closing ticket,%d\n
Ticket doesn't exist,%d\n
The ticket was modified while updating,%d\n
Connection to DB failed,%d\n
Tried to add information to closed ticket,%d\n
Timeout while retrieving information,%d\n" $perm $notexist $modify $failedcon $close $timeout | sort -t, -k2 -nr | sed '1 i\Error,Count' > error_message.csv

#Potong semua kata sebelum dan sesudah () lalu sort dan unique lalu di iterasi disetiap line dan grep banyak nya okurensi kata tersebut dalam error dan info lalu print itu dan taruh Username,Info,Error di awal file
cut -d"(" -f2 < syslog.log | cut -d")" -f1 | sort | uniq |
    while read -r line
        do
           a=$(grep -E -o "ERROR.*($line))" syslog.log | wc -l)
           b=$(grep -E -o "INFO.*($line))" syslog.log | wc -l)
           printf "%s,%d,%d\n" $line $b $a
        done | sed '1 i\Username,Info,Error'> user_statistic.csv

```
## Penjelasan

1A B D
Cari semua line error dan count berapa kali keluar
```bash
perm="$(grep -o "Permission denied while closing ticket" syslog.log | wc -l)"
notexist="$(grep -o "Ticket doesn't exist" syslog.log | wc -l)"
failedcon="$(grep -o "Connection to DB failed" syslog.log | wc -l)"
modify="$(grep -o "The ticket was modified while updating" syslog.log | wc -l)"
close="$(grep -o "Tried to add information to closed ticket" syslog.log | wc -l)"
timeout="$(grep -o "Timeout while retrieving information" syslog.log | wc -l)"
```
dan diulangi untuk semua error yang ada lalu print semua error dan variablenya 
```bash
#print error tersebut dan sort kolom 2 dengan menggunakan fungsi sort dan menggunakan , sebagai delimiter lalu sed Error, Count di line 1
printf "Permission denied while closing ticket,%d\n
Ticket doesn't exist,%d\n
The ticket was modified while updating,%d\n
Connection to DB failed,%d\n
Tried to add information to closed ticket,%d\n
Timeout while retrieving information,%d\n" $perm $notexist $modify $failedcon $close $timeout
```
lalu kita sort melalui pipe 
```bash
sort -t, -k2 -nr
```
-t, ini sendiri adalah membuat koma menjadi delimiter dan mensort kolom ke 2 dengan numerikal reverse (-k2 -nr).
Karena diminta adanya line  "Error,Count" di awal file, dapat digunakan sed untuk menyelipkan kalimat tersebut di awal file.

1A C E
Untuk mendapatkan semua nama username dapat dilihat dengan snippet code dibawah
```bash
cut -d"(" -f2 < syslog.log | cut -d")" -f1
```
Disini fungsi cut -d"(" -f2 sendiri menghilangkan semua kata yang berada sebelum "(" dan fungsi  cut -d")" -f1 menghilangkan semua kata yang berada seletah ")"
Setelah itu data dapat dipipeline ke fungsi sort dan uniq
```bash
sort | uniq 
```
Dimana data tersebut akan di sort alphabetically dan duplicate dihapus lalu diiterasikan di output tersebut berapa kali kata-kata error dan info keluar
```bash
while read -r line
        do
           a=$(grep -E -o "ERROR.*($line))" syslog.log | wc -l)
           b=$(grep -E -o "INFO.*($line))" syslog.log | wc -l)
           printf "%s,%d,%d\n" $line $b $a
        done
```
Sebenarnya -E dan -o tidak perlu digunakan tapi sudah di push jadi yasudahlah
kode diatas mengiterasi dari line 1 nama - nama dari output pipeline dan menghitung okurensi nama tersebut keluar diantara Error dan Info lalu menprint tersebut ke file
karena diawal file ingin ada kata kata "Username,Info,Error" dapat dilakukan sed agar awal file terdapat line tersebut.

##Permasalahan
- Belum terbiasa dengan syntax
- Regex berantakan
- Penggunaan grep yang kurang tepat
