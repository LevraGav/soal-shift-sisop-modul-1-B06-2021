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
 
 #1b
 grep -oP "(?<=ERROR )(.*)(?= [(])" syslog.log | sort | uniq -c | sort -nr | 
 while read a b
 do
      echo $b,$a
 done
 
 echo
 
 #1c
 cut -d"(" -f2 < syslog.log | cut -d")" -f1 | sort | uniq | 
        while read -r line
            do
               a=$(grep -E -o "ERROR.*($line))" syslog.log | wc -l)
               b=$(grep -E -o "INFO.*($line))" syslog.log | wc -l)
               printf "%s,%d,%d\n" $line $b $a
           done
 
 #1d
 grep -oP "(?<=ERROR )(.*)(?= [(])" syslog.log | sort | uniq -c | sort -nr | 
 while read a b
 do
     echo $b,$a
 done | sed '1 i\Error,Count' > error_message.csv
 
 
 #1e
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
Regex 
```bash
grep -oP "(?<=ERROR )(.*)(?= [(])" syslog.log | sort | uniq -c | sort -nr | 
 while read a b
 do
      echo $b,$a
 done
```
Penjelasan Regex no 1 adalah mencari kata diantara "ERROR" dan "(" lalu disort agar uniq nya dapat bekerja dengan baik, lalu di sort lagi agar benar ordernya
karena format terbalik, setiap line diputar dengan snipper kode
```bash
 while read a b
 do
      echo $b,$a
 done
```
Untuk 1d sendiri hanya menambahkan Error,Count dan menaruh ke file csv
```bash
 grep -oP "(?<=ERROR )(.*)(?= [(])" syslog.log | sort | uniq -c | sort -nr | 
 while read a b
 do
     echo $b,$a
 done | sed '1 i\Error,Count' > error_message.csv
```
sed sendiri digunakan hanya untuk menyelipkan "Error,Count" di line pertama dan di export ke error_message.csv

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

## Permasalahan
- Belum terbiasa dengan syntax
- Regex ribet
- Penggunaan grep yang kurang tepat
