#!/bin/bash

#NO 2A
export LC_ALL=C
awk '
BEGIN{FS="\t"}{
    PercentageProfit=(($21/($18-$21))*100)
    if (PercentageProfit>=ProfitMax){
        ProfitMax=PercentageProfit
        MAXRowID=$1
    }
}  
END{
    print "Transaksi terakhir dengan profit percentage terbesar yaitu", MAXRowID, "dengan persentase", ProfitMax, "%\n"}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt

#NO 2B
export LC_ALL=
awk '
BEGIN{FS="\t"}{
    if ($2~"2017" && ($10=="Albuquerque")){
        CustomerName[$7]++
    }
}
END{
    print "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:"
    for (NameofCustomer in CustomerName){
        print NameofCustomer
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
        if (SalesMinimum > Segment[bidang]){
            SalesMinimum = Segment[bidang]
            SalesMinimum = bidang
        }
    }
print "\nTipe segmen customer yang penjualannya paling sedikit adalah", bidang, "dengan", Segment[bidang], "transaksi\n"}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt

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
        if (ProfitMinimum > region[daerah]){
            ProfitMinimum = region[daerah]
            ProfitMinimum = daerah
        }
    }    
print "Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah", daerah, "dengan total keuntungan", region[daerah]}' /home/arvel/Documents/Praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt



