!#/bin/bash

cd /gscratch/wasser/khan3/elephant_snps/data/gatk/gvcf/

ls -1 gvcf/map_files/*.map > ../done_chrs.txt

cd ../
pwd #/gscratch/wasser/khan3/elephant_snps/data/gatk/

sed -i 's/map//g' done_chrs.txt
sed -i 's/[[:punct:]]\+//g' done_chrs.txt
cat chromosomes.txt |grep -v -f done_chrs.txt>remaining_chr.txt 
