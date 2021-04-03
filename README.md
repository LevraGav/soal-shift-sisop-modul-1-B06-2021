# soal-shift-sisop-modul-1-B06-2021
Laporan Penyelesaian Pengerjaan Soal Praktikum SISOP Modul 1 - Kelompok B06

## Link-link
- [Soal](https://docs.google.com/document/d/1T3Y4o2lt5JvLTHdgzA5vRBQ0QYempbC5z-jcDAjela0/edit)
- [Jawaban Soal 1](https://github.com/LevraGav/soal-shift-sisop-modul-1-B06-2021/tree/main/soal1)
- [Jawaban Soal 2](https://github.com/LevraGav/soal-shift-sisop-modul-1-B06-2021/tree/main/soal2)
- [Jawaban Soal 3](https://github.com/LevraGav/soal-shift-sisop-modul-1-B06-2021/tree/main/soal3)

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
Di bagian END tinggal melakukan printf untuk mencetak hasil program, yaitu dengan melakukan pemanggilan dari masing-masing variable MAXRowID dan ProfitMax. Selain itu juga dilakukan penghubungan direktori file tsv agar memasukkan output program ke dalam sebuah file bernama hasil.txt.

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
```bash
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
```
Di bagian ini kami melakukan pembandingan nilai dengan menggunakan percabangan if dan else if untuk mencari segment customer yang memiliki transaksi paling sedikit. Segment yang kami bandingkan pertama kali adalah Corporate dan Consumer, jika nilai kemunculan dari Consumer lebih banyak dari Corporate maka akan masuk ke percabangan selanjutnya.
```bash
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
```
disini segment yang kami bandingkan adalah Corporate dan Home Office, dari percabangan pertama kita ketahui bahwa kemunculan dari Corporate lebih kecil daripada Consumer. Jika pada percabangan kedua nilai Corporate ternyata lebih besar daripada HomeOffice maka bisa kita simpulkan bahwa nilai kemunculan HomeOffice adalah yang paling kecil dari ketiga segment. Oleh karena itu maka string Home Office nilainya akan dimasukkan ke dalam variable baru bernama Bidang dan jumlah kemunculannya akan dimasukkan ke dalam variable baru bernama transaksi. Aturan yang sama juga berlaku jika yang terjadi adalah sebaliknya.
```bash
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
```
Di bagian ini kami kembali melakukan pembandingan nilai dengan menggunakan percabangan if dan else if untuk mencari segment customer yang memiliki transaksi paling sedikit. Segment yang kami bandingkan disini masih sama, yaitu Corporate dan Consumer tetapi disini nilai kemunculan dari Consumer lebih kecil dari Corporate maka akan masuk ke percabangan selanjutnya.
```bash
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
``` 
disini segment yang kami bandingkan adalah Corporate dan Home Office, dari percabangan pertama kita ketahui bahwa kemunculan dari Corporate lebih besar daripada Consumer. Jika pada percabangan kedua nilai Consumer ternyata lebih besar daripada HomeOffice maka bisa kita simpulkan bahwa nilai kemunculan HomeOffice adalah yang paling kecil dari ketiga segment. Oleh karena itu maka string Home Office nilainya akan dimasukkan ke dalam variable baru bernama Bidang dan jumlah kemunculannya akan dimasukkan ke dalam variable baru bernama transaksi. Aturan yang sama juga berlaku jika yang terjadi adalah sebaliknya.
```bash
END {
    printf ("\nTipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi\n", bidang, transaksi)
}
' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
Dengan menggunakan percabangan di atas, maka sudah diketahui segment customer apa yang memiliki transaksi dengan jumlah paling sedikit sekaligus berapa transaksi yang terjadi pada segment tersebut. Disini kami hanya melakukan print / cetak dengan memanggil kedua variable baru yaitu bidang dan transaksi.

## 2D.
TokoShiSop membagi wilayah bagian (region) penjualan menjadi empat bagian, antara lain: Central, East, South, dan West. Manis ingin mencari <b>wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit<b> dan <b>total keuntungan wilayah tersebut</b>.
 
 ### Source Code
 ```bash
 #NO 2D
# Mencari daerah yang total keuntungan (profit)-nya paling sedikit dan total keuntungannya
awk -v ProfitMinimum=99999 '
BEGIN {FS="\t"} {
        if(NR!=1)
        {
            region[$13]=$21+region[$13]
        }
    }
END{
    for (daerah in region){
        if (ProfitMinimum > region[daerah])
        {
            ProfitMinimum = region[daerah]
            DaerahBagian = daerah
        }
    }
    printf ("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah  %s dengan total %.2f\n", DaerahBagian, ProfitMinimum)
}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
### Penjelasan
Soal 2D meminta kami untuk mencari <b>daerah yang total keuntungan (profit)-nya paling sedikit</b> dan <b>total keuntungannya</b>, dimana jika sudah ditemukan maka yang harus kami cetak di program adalah nama region/daerahnya dan total keuntungan dari region tersebut.
```bash
if(NR!=1)
        {
            region[$13]=$21+region[$13]
        }
```
NR menandakan Number of Row, disini kami melakukan set bahwa pengecekan data akan dilakukan selama barisnya tidak sama dengan 1. Karena di dalam file tsv baris 1 hanya berisi atribut dan bukan nilai dari data maka tidak perlu dilakukan pengecekan data. Kemudian kami menggunakan ```Associative Array``` dengan region dari $13 (kolom 13 yang berisi region) sebagai index untuk melakukan semacam ```group by``` antara $13 dan $21 (kolom 21 yang berisi profit) sehingga nilai dari profit akan dikelompokkan berdasarkan regionnya. Akumulasi keuntungan dari masing-masing region dengan menggunakan rumus ```region[$13]=$21+region[$13]``` akan disimpan di dalam array ini.
```bash
for (daerah in region){
        if (ProfitMinimum > region[daerah])
        {
            ProfitMinimum = region[daerah]
            DaerahBagian = daerah
        }
    }
```
Kemudian kami melakukan iterasi untuk setiap total keuntungan dari masing-masing region yang tersimpan  pada array ```region``` untuk mencari region dengan total keuntungan paling sedikit. Jika total keuntungan dari suatu region lebih kecil dari nilai ProfitMinimum yang telah ditetapkan sebelumnya di awal kodingan maka nilai total keuntungan akan disimpan ke dalam variable ```ProfitMinimum``` menggantikan nilai ProfitMinimum yang sudah di set sebelumnya. Sedangkan untuk nama regionnya akan disimpan di dalam variable ```DaerahBagian```.
```bash
printf ("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah  %s dengan total %.2f\n", DaerahBagian, ProfitMinimum)
}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
Setelah diketahui nama region yang memiliki total profit paling sedikit sekaligus dengan total profitnya, maka kami melakukan print dengan melakukan pemanggilan variable-variable diatas yaitu DaerahBagian dan ProfitMinimum.

## 2E.
Membuat script hasil output dari soal 2A, 2B, 2C, dan 2D yang disimpan ke file 'hasil.txt' dengan format:
```
Transaksi terakhir dengan profit percentage terbesar yaitu *ID Transaksi* dengan persentase *Profit Percentage*%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
*Nama Customer1*
*Nama Customer2* dst

Tipe segmen customer yang penjualannya paling sedikit adalah *Tipe Segment* dengan *Total Transaksi* transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah *Nama Region* dengan total keuntungan *Total Keuntungan (Profit)*
```
Output dari masing - masing soal 2A, 2B, 2C, dan 2D akan ditampilkan pada file hasil.txt, caranya adalah dengan melakukan redirection untuk mengirim output ke file thasil.txt tersebut. Jika diperhatikan pada source code setiap soal 2A, 2B, 2C, dan 2D kami melakukan redirection hasil output dengan format :
```
/home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
lambang ```<<``` menandakan bahwa hasil output dimana datanya bersumber dari Laporan-TokoShiSop.tsv akan dimasukkan ke dalam hasil.txt.

## Output
![Output Soal no 2](https://user-images.githubusercontent.com/72689610/113423498-c6b73500-93f8-11eb-8eb9-c188187bc93a.jpg)

## Kendala
Tidak ada kendala dalam pengerjaan soal nomor 2.

# --- No 3 ---
Kuuhaku adalah orang yang sangat suka mengoleksi foto-foto digital, namun Kuuhaku juga merupakan seorang yang pemalas sehingga ia tidak ingin repot-repot mencari foto, selain itu ia juga seorang pemalu, sehingga ia tidak ingin ada orang yang melihat koleksinya tersebut, sayangnya ia memiliki teman bernama Steven yang memiliki rasa kepo yang luar biasa. Kuuhaku pun memiliki ide agar Steven tidak bisa melihat koleksinya, serta untuk mempermudah hidupnya, yaitu dengan meminta bantuan kalian.

## 3a. Penjelasan

```bash
    for loop in {1..23}; do
```

loop standar

```bash
    wget -O Koleksi_$loop -a "Foto.log" https://loremflickr.com/320/240/kitten
```

-O adalah parameter untuk memberikan nama custom ke file output

-a adalah parameter untuk meng-append log ke file log yang sudah ada atau membuatnya jika belum ada

```bash
    max=$((loop-1))
    for (( i=1; i<=max; i++ )) do
        if [ -f Koleksi_$i ]; then
            if cmp Koleksi_$i Koleksi_$loop &> /dev/null; then
                rm Koleksi_$loop
                break
            fi
        fi
    done
```

Nested if untuk mengecek gambar yang sama: max menandai jumlah file maksimal yang harus di-cek, -f mengecek apakah file itu ada, lalu digunakanlah command cmp untuk mengecek perbedaan antara dua gambar, jika gambar berbeda, maka akan ada output bita mana yang berbeda.

Output tersebut akan dilempar ke /dev/null menggunakan redirector '&>' (redirect stdout dan stderr), di /dev/null, data akan dibuang agar tidak mengotori terminal.

Jika ada output, maka if akan dianggap true dan file tersebut di-remove, dan terjadi break di loop itu agar pengecekan tidak dilanjutkan.

```bash
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
```

Loop selanjutnya digunakan untuk mengisi lubang yang kosong setelah mungkina ada file yang di-remove. if pertama mengecek apakah file untuk nomor tertentu tidak ada, menggunakan operator negasi (!) dan parameter -f, jika nomor tersebut terbukti tidak memiliki file, pencarian akan dilanjutkan.

For yang ada dalamnya akan mencari dari belakang untuk file terbaru, lalu setelah menemukan adanya file dengan -f, file tersebut akan dipindahkan ke tempat nomor yang kosong tadi.

```bash
    for loop in {1..9}; do
        mv Koleksi_$loop Koleksi_0$loop
    done
```

Loop terakhir digunakan untuk menambahkan 0 ke nama file satu digit, karena jika tidak, file dua digit misal Koleksi_11 akan diletakkan sebelum angka satu digit misal Koleksi_9, dan itu tidak rapi.

# Output
![Output soal no 3a](https://user-images.githubusercontent.com/11045113/113477621-6930f000-94ad-11eb-8b6b-4c9fc3b5096e.png)

## 3b. Penjelasan

```bash
    #!/bin/bash

    folder="$(date '+%d-%m-%Y')"
    mkdir $folder
    bash /home/nor/sisop/s1/soal3a.sh
    mv Koleksi* $folder
    mv Foto.log $folder
```

Shebang (#!) di awal digunakan untuk menspesifikkan command yang digunakan untuk menjalankan suatu skrip, dalam kasus ini, bash.

Variabel folder dideklarasikan sebagai date dan '+%d-%m-%Y' adalah format mask agar formatnya sesuai dengan soal.

Mkdir untuk membuat direktori baru tempat file-file akan ditempatkan, dengan nama sesuai dengan variabel yang sudah dibuat.
Soal 3a dijalankan.

File-file yang sudah terunduh beserta file log-nya dipindahkan ke folder tersebut.

```bash
    PATH=/opt/someApp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    0 20 1-31/7 * * /bin/bash /home/nor/sisop/s1/soal3b.sh
    0 20 2-31/4 * * /bin/bash /home/nor/sisop/s1/soal3b.sh
    
```

Revisi: PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin ditambahkan karena cron menjalankan command pada restricted environment, path tersebut ditambahkan agar cron dapat menjalankan commmand yang biasanya hanya dapat dilakukan user, newline di akhir juga ditambahkan karena cron hanya mengerjakan command jika ada newline

0 20 artinya cron dijalankan tiap menit 0 jam 20 atau jam 20.00.

1-31/7 artinya cron dijalankan tiap 7 hari sekali mulai dari tanggal 1 sampai dengan tanggal 31.

2-31/4 artinya cron dijalankan tiap 4 hari sekali mulai dari tanggal 2 sampai dengan tanggal 31.

Bintang kiri artinya cron dijalankan tiap bulan, sedangkan, bintang yang kanan artinya agak berbeda, by default dia berarti 'dijalankan tiap hari apa', jadi karena dia tidak di-edit maka tidak berpengaruh apa-apa.
2 cronjob tersebut memanggil soal3b.sh

## Output
![Output soal no 3b](https://user-images.githubusercontent.com/11045113/113477661-9e3d4280-94ad-11eb-8840-820dd3ec059c.png)

## 3c. Penjelasan

```bash
    kucing=$(find Kucing* 2> /dev/null | wc -l)
    kelinci=$(find Kelinci* 2> /dev/null | wc -l)
```

Command find digunakan untuk me-list jumlah folder yang ada, lalu digunakan redirector '2>' untuk membuang error (stderr) yang ada ke /dev/null, agar tidak mengganggu pipeline.

Output tersebut di pipeline ke wc dengan parameter -l untuk menghitung jumlah baris/ line, lalu output tersebut dimasukkan ke masing-masing variabel kucing dan kelinci.

```bash
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
```

Kode-kode di atas terlihat kompleks, namun sebenarnya itu hanyalah soal 3a dan soal 3a yang disalin dan kucing-nya diganti kelinci, jika jumlah folder kucing dan kelinci sama, maka gambar-gambar kucing akan diunduh untuk hari itu, namun, jika ada lebih banyak folder kucing, yang diunduh adalah gambar kelinci.

Beberapa tambahan yaitu variabel folder dideklarasikan terlebih dahulu untuk folder yang akan dibuat, lalu folder tersebut dibuat, dan bash cd ke direktori tersebut, agar gambar-gambar yang diunduh dan file lognya langsung berada di sana.

## Output
![Output soal no 3c](https://user-images.githubusercontent.com/11045113/113477565-edcf3e80-94ac-11eb-8836-478604de22b2.png)

## 3d. Penjelasan

```bash
    #!/bin/bash

    pwd="$(date '+%m%d%Y')"
    zip -P $pwd -r Koleksi K*
    rm -r Kucing*
    rm -r Kelinci*
```

Variabel pwd dideklerasikan dengan cara yang sama dengan deklarasi nama folder tadi.

Command zip dijalankan, dengan parameter -P untuk memberikan password, -r agar pen-zip-an terjadi secara rekursif, dan argumen selanjutnya adalah argumen default yaitu nama folder yang diinginkan dan file yang harus di-zip, karena Kucing dan Kelinci sama-sama diawali K, maka digunakan K dengan wildcard (artinya semua file yang diawali dengan K menjadi target operasi).

Command rm dijalankan untuk me-remove semua folder kucing dan kelinci secara rekursif (artinya folder maupun file didalamnya dihapus).

## Output
![Output soal no 3d](https://user-images.githubusercontent.com/11045113/113477595-28d17200-94ad-11eb-8e65-46874f0acf2a.png)


## 3e. Penjelasan

```bash
    0 1 * * * cd /home/nor/sisop/s1 && /bin/bash /home/nor/sisop/s1/soal3c.sh
    0 7 * * 1-5  cd /home/nor/sisop/s1 && /bin/bash /home/nor/sisop/s1/soal3d.sh
    0 18 * * 1-5 cd /home/nor/sisop/s1 && unzip -P $(date +"%m%d%Y") Koleksi.zip && rm Koleksi.zip
    
```

Untuk baris pertama cron, tidak dituliskan secara eksplisit siapa yang disuruh mengunduh gambar anak kucing dan kelinci secara bergantian tiap hari atau menggunakan apa pada soal 3c. Namun, karena ada cron, sekalian saja kami gunakan itu.
0 1 * * * artinya soal3c.sh dijalankan tiap hari jam 01.00.

0 7 * * 1-5 artinya soal3d.sh (skrip untuk men-zip koleksi) dijalankan tiap hari Senin-Jumat (hari Kuuhaku kuliah) jam 07.00.

0 18 * * 1-5 artinya tiap Senin-Jumat, jam 18.00, akan dijalankan 2 buat command yaitu crontab akan cd ke folder tempat koleksi berada, lalu command unzip akan dijalankan dengan parameter -P dengan password yang sama yaitu tanggal dari hari itu.

Revisi: Ditambahkan command cd agar file terdownload di folder s1

Revisi: Di command terakhir, ditambahkan command rm untuk menghapus zip Koleksi

## Kendala
- Cron tidak bisa jalan karena path belum diatur dan belum ada newline di akhir file cron
- Lupa mengatur direktori penjalanan script sehingga file tidak terdownload di tempat seharusnya

Sekian dari laporan kami. Mohon maaf jika ada kekurangan. Terima kasih.
