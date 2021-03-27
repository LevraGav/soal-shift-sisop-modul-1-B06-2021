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
 #Potong semua kata sebelum dan sesudah () lalu sort dan unique lalu di iterasi disetiap line dan grep banyak nya okurensi kata         tersebut dalam error dan info lalu print itu dan taruh Username,Info,Error di awal file
 cut -d"(" -f2 < syslog.log | cut -d")" -f1 | sort | uniq | 
     while read -r line
         do
            a=$(grep -E -o "ERROR.*($line))" syslog.log | wc -l)
            b=$(grep -E -o "INFO.*($line))" syslog.log | wc -l)
            printf "%s,%d,%d\n" $line $b $a
         done | sed '1 i\Username,Info,Error'> user_statistic.csv
