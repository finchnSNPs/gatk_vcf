#!/bin/bash

#SBATCH --job-name=bwamem
#SBATCH --account=wasser
#SBATCH --partition=wasser
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=30G
#SBATCH --time=4-00:00:00
#SBATCH -o logfiles/bwamem.%j.out
#SBATCH -e logfiles/bwamem.%j.err

pwd; hostname; date

module load contrib/bwa/0.7.17

for fn in data/reads2/*_R1_trimmed.fastq.gz
do
    # get the path to the file
    dir=`dirname $fn`;
   
    # get just the file (without path)
    base=`basename $fn`;

    # the read filename, without the suffix
    rf=${base%_R1_trimmed.fastq.gz};

    # grabs the first line of the file
    header=$(zcat $fn | head -n 1);

    # grabs the illumina flowcell and lane information
    id=$(echo $header | head -n 1 | cut -d':' -f1,2,3,4 | sed 's/@//' | sed 's/:/_/g');
#    sm=$(echo $header | head -n 1 | grep -Eo "[ATGCN]+$");
    echo "Read Group @RG\tID:${id}\tSM:${rf}\tLB:${rf}\tPL:ILLUMINA"
    
    # do what I need with it
    bwa mem -t 16 -M -R $(echo "@RG\tID:${id}\tSM:${rf}\tLB:${rf}\tPL:ILLUMINA") ./data/reference/loxAfr4/loxAfr4.v2.fasta ${dir}/${rf}_R1_trimmed.fastq.gz ${dir}/${rf}_R2_trimmed.fastq.gz > ./data/bwamem/${rf}_paired_aln.sam
done


