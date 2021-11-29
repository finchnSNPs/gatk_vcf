#!/bin/bash

#SBATCH --job-name=sortbams
#SBATCH --account=wasser
#SBATCH --partition=wasser
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10G
#SBATCH --time=100:00:00
#SBATCH -o logfiles/sortreads.%j.out
#SBATCH -e logfiles/sortreads.%j.err

pwd; hostname; date

module load contrib/gatk4/4.1.9.0
#module load contrib/samtools-1.11/samtools-1.11

for fn in data/bwamem/*.bam
do
    # get the path to the file
    dir=`dirname $fn`;
   
    # get just the file (without path)
    base=`basename $fn`;

    # the read filename, without the suffix
    rf=${base%.bam};

    # do what I need with it
    gatk SortSam -SO coordinate -I ${dir}/${base} -O data/sorted/${rf}_sorted.bam
#    samtools sort ${dir}/${base} -o ${dir}/${rf}_sorted.bam
done
