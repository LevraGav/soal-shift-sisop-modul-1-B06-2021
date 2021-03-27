# soal-shift-sisop-modul-1-B06-2021
Laporan Penyelesaian Pengerjaan Soal Praktikum SISOP Modul 1 - Kelompok B06

## File .sh
- [Soal 1](https://github.com/LevraGav/soal-shift-sisop-modul-1-B06-2021/tree/main/soal1)
- [Soal 2](https://github.com/LevraGav/soal-shift-sisop-modul-1-B06-2021/tree/main/soal2)
- [Soal 3](https://github.com/LevraGav/soal-shift-sisop-modul-1-B06-2021/tree/main/soal3)

# --- No 1 ---
Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, ticky. Terdapat 2 laporan yang harus dia buat, yaitu laporan daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky.
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

# --- No 2 ---
Steven dan Manis mendirikan sebuah startup bernama “TokoShiSop”. Sedangkan kamu dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja, Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.

## 2A.
Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui <b>Row ID</b> dan <b>profit percentage terbesar</b> (jika hasil profit percentage terbesar lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari profit percentage, yaitu :
Profit Percentage = (Profit Cost Price) 100

### Source Code
```bash
#NO 2A
# Profit Percentage = (Profit / (Cost-Price)) * 100
# Menghitung transaksi dengan profit percentage terbesar
export LC_ALL=C
awk -v ProfitMax=0 '
BEGIN{FS="\t"}
{
    sales=$18
    profit=$21
    PercentageProfit=((profit/(sales-profit))*100)
    if (PercentageProfit>=ProfitMax)
    {
        ProfitMax=PercentageProfit
        MAXRowID=$1
    }
}  
END{
    printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %d%%. \n", MAXRowID, ProfitMax)}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```    
### Penjelasan
Soal 2A meminta kami untuk mencari <b>transaksi dengan profit percentage terbesar</b>, dimana jika sudah ditemukan maka yang harus kami cetak di program adalah RowID dan besar profit percentage untuk transaksi tersebut.

```bash
awk -v ProfitMax=0 '
BEGIN{FS="\t"}
{
    sales=$18
    profit=$21
    PercentageProfit=((profit/(sales-profit))*100)
    if (PercentageProfit>=ProfitMax)
    {
        ProfitMax=PercentageProfit
        MAXRowID=$1
    }
}
```
Dengan menggunakan rumus profit percentage yang sudah disediakan soal, maka kami memutuskan untuk memanipulasi rumus tersebut agar sesuai dengan yang diinginkan oleh soal. Kemudian kami membuat sebuah variable baru bernama ProfitMax, dimana variable ProfitMax ini berfungsi untuk menyimpan nilai profit percentage. Pertama variable ProfitMax akan dibandingkan nilainya dengan PercentageProfit, jika ternyata nilai dari ProfitMax <= PercentageProfit maka nilai dari ProfitMax akan dianggap sebagai profit percentage. Kemudian karena nilai profit percentage terbesar telah ditemukan, maka nilai dari $1 (kolom 1 yang berisi RowID) akan dimasukkan ke dalam variable MAXRowID. Perlu diingat bahwa nilai RowID yang dimasukkan adalah RowID yang sesuai / sebaris dengan nilai profit percentage terbesar di atas.

```bash
END{
    printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %d%%. \n", MAXRowID, ProfitMax)}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```    
Di bagian END tinggal melakukan printf untuk mencetak hasi program, yaitu dengan melakukan pemanggilan dari masing-masing variable MAXRowID dan ProfitMax. Selain itu juga dilakukan penghubungan direktori file tsv agar memasukkan output program ke dalam sebuah file bernama hasil.txt.

## 2B.
Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM. Oleh karena itu, Clemong membutuhkan daftar <b>nama customer pada transaksi tahun 2017 di Albuquerque</b>.

### Source Code
```bash
#NO 2B
# Mencari nama customer yang melakukan transaksi di ALbuquerque pada tahun 2017
export LC_ALL=
awk '
BEGIN{FS="\t"}{
    if ($2~"2017" && ($10=="Albuquerque"))
    {
        CustomerName[$7]++
    }
}
END{
    print "\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:"
    for (NameofCustomer in CustomerName)
    {
        printf ("%s\n", NameofCustomer)
    }
}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
### Penjelasan
Soal 2B meminta kami untuk mencari <b>nama customer yang melakukan transaksi pada tahun 2017 di Albuquerque</b>, dimana jika sudah ditemukan maka yang harus kami cetak di program adalah nama-nama customer tersebut.
```bash
BEGIN{FS="\t"}{
    if ($2~"2017" && ($10=="Albuquerque"))
    {
        CustomerName[$7]++
    }
}
```
Metode yang kami gunakan untuk menyelesaikan soal ini cukup sederhana. Pertama kami membuat sebuah persyaratan dengan menggunakan IF, dimana di dalam IF ini kami memasukkan syarat - syarat sesuai dengan yang diperintahkan oleh soal yaitu $2 (Kolom 2 yang berisi data order ID yang mengandung tahun) kami set untuk hanya mengambil data yang mengandung tahun 2017. Kemudian $10 (Kolom 10 yang berisi data city/kota) kami set untuk hanya mengambil data yang mengandung kota ALbuquerque. Jika kedua kondisi ini terpenuhi, maka barulah data-data nama customer yang ada di $7 (kolom 7) dimasukkan ke dalam sebuah variable baru yang kami buat dengan nama CustomerName. Di dalam variable inilah data-data nama customer yang memenuhi kedua kondisi di atas akan disimpan.
```bash
END{
    print "\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:"
    for (NameofCustomer in CustomerName)
    {
        printf ("%s\n", NameofCustomer)
    }
}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
Selanjutnya kami melakukan print kalimat "Daftar nama customer di Albuquerque pada tahun 2017 antara lain :", dimana setelah kalimat tersebut dicetak kami melakukan pemanggilan data-data nama customer yang tersimpan di dalam variable Array CustomerName. Cara melakukan pemanggilan datanya adalah dengan membuat sebuah variable baru bernama NameofCustomer. Sekarang data-data nama customer yang ada di dalam Array CustomerName sudah terpanggil dengan menggunakan variable NameofCustomer, langkah terakhir adalah dengan melakukan print pada variable NameofCustomer untuk mencetak data-data nama customer yang memenuhi kedua kondisi di atas ke dalam hasil.txt

## 2C.
TokoShiSop berfokus tiga segment customer, antara lain: Home Office, Customer, dan Corporate. Clemong ingin meningkatkan penjualan pada segmen customer yang paling sedikit. Oleh karena itu, Clemong membutuhkan <b>segment customer</b> dan <b>jumlah transaksinya yang paling sedikit</b>.

### Source Code
```bash
#NO 2C
# Mendapatkan segment customer yang penjualan / transaksinya paling sedikit
export LC_ALL=C
awk '
BEGIN{FS="\t"}{
    if($8 == "Home Office")
    {
        HomeOffice++
    }
    else if($8 == "Corporate")
    {
        Corporate++
    }
    else if($8 == "Consumer")
    {
        Consumer++
    }
    if(Consumer > Corporate)
    {
       if(Corporate > HomeOffice)
       {
            bidang = "Home Office"
            transaksi = HomeOffice
       }
       else
       {
            bidang = "Corporate"
            transaksi = Corporate
       }
    }
    else if(Consumer < Corporate)
    {
        if(Consumer > HomeOffice)
        {
            bidang = "Home Office"
            transaksi = HomeOffice
        }
        else
        {
            bidang = "Consumer"
            transaksi = Consumer
        }
    }
}
END {
    printf ("\nTipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi\n", bidang, transaksi)
}
' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
### Penjelasan
Soal 2C meminta kami untuk mencari <b>segment customer yang penjualan / transaksinya paling sedikit</b>, dimana jika sudah ditemukan maka yang harus kami cetak di program adalah nama segmentnya dan berapa kali segment tersebut dilakukan transaksi.
```bash
BEGIN{FS="\t"}{
    if($8 == "Home Office")
    {
        HomeOffice++
    }
    else if($8 == "Corporate")
    {
        Corporate++
    }
    else if($8 == "Consumer")
    {
        Consumer++
    }
```
Pada bagian ini, pertama kami membuat semacam penyocokan. Kita ketahui dari file TSV bahwa $8 / kolom 8 mengandung data-data jenis segment, dimana setiap kemunculan data dari masing-masing segment menandakan telah terjadi semacam transaksi. Disini kami melakukan set bahwa 1 kemunculan nama suatu segment di dalam kolom 8 menandakan bahwa telah terjadi 1 transaksi atas nama segment tersebut. Oleh karena itu kami membuat semacam aturan pengisian, jika baris dari kolom 8 memiliki nilai "Home Office", maka banyak kemunculan dari kata "Home Office" atau dalam hal ini jumlah transaksinya akan dimasukkan ke dalam sebuah variable baru yang kami buat dengan nama HomeOffice. Increment menunjukkan bahwa setiap penambahan kemunculan akan memberian penambahan data ke dalam variable HomeOffice. 
```bash
else if($8 == "Corporate")
    {
        Corporate++
    }
    else if($8 == "Consumer")
    {
        Consumer++
    }
```    
Hal yang sama juga berlaku untuk kemunculan segment Corporate dan Consumer, dimana penambahan kemunculan "Corporate" akan dimasukkan ke dalam variable Corporate begitu juga dengan "Consumer" yang akan dimasukkan ke dalam variable Consumer.
    


