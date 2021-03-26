#!/bin/bash

#NO 2A
export LC_ALL=C
awk '
BEGIN{FS="\t"}{
    sales=$18
    profit=$21
    PercentageProfit=((profit/(sales-profit))*100)
    if (PercentageProfit>=ProfitMax){
        ProfitMax=PercentageProfit
        MAXRowID=$1
    }
}  
END{
    printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %d%%. \n", MAXRowID, ProfitMax)}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt

#NO 2B
export LC_ALL=
awk '
BEGIN{FS="\t"}{
    if ($2~"2017" && ($10=="Albuquerque")){
        CustomerName[$7]++
    }
}
END{
    print "\nDaftar nama customer di Albuquerque pada tahun 2017 antara lain:"
    for (NameofCustomer in CustomerName){
        printf ("%s\n", NameofCustomer)
    }
}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt

#NO 2C
awk '
BEGIN{FS="\t"}{
    if (1!=NR){
        Segment[$8]+=1
    }
}
END{
    SalesMinimum=4000
    for (bidang in Segment){
        if ( Segment[bidang] < SalesMinimum){
            SalesMinimum = Segment[bidang]
            SalesMinimum = bidang
        }
    }
printf ("\nTipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi\n", bidang, Segment[bidang])}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt

#NO 2D
export LC_ALL=C
awk '
BEGIN{FS="\t"}{
    if (1!=NR){
        region[$13]=$21 + region[$13] 
    }
}
END{
    ProfitMinimum=4000
    for (daerah in region){
        if (region[daerah] < ProfitMinimum){
            ProfitMinimum = region[daerah]
            ProfitMinimum = daerah
        }
    }    
printf ("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.2f", daerah, region[daerah])}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt



