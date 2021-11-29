#!/bin/bash

#SBATCH --job-name=cutadapt
#SBATCH --account=wasser
#SBATCH --partition=wasser
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8G
#SBATCH --time=48:00:00
#SBATCH -o logfiles/cutadapt.%j.out
#SBATCH -e logfiles/cutadapt.%j.err

pwd; hostname; date

#for fn in ./data/rawdata/*.fastq.gz
for fn in ./data/rawdata/*_R1_001.fastq.gz
do
        # get the path to the file
        dir=`dirname $fn`;

        # get filename without the path and suffix
        base=`basename $fn`;

        # the read filename without the suffix
	rf=${base%_R1_001.fastq.gz};

        ~/.local/bin/cutadapt -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT --minimum-length 70 -q 15 -o ./data/reads2/${rf}_R1_trimmed.fastq.gz -p ./data/reads2/${rf}_R2_trimmed.fastq.gz ./${dir}/${rf}_R1_001.fastq.gz ./${dir}/${rf}_R2_001.fastq.gz
done
