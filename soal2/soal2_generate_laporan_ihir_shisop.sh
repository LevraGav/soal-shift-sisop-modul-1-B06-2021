#!/bin/bash

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

#NO 2D
# 
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



