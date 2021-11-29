#!/bin/bash

#SBATCH --job-name=bamconvert
#SBATCH --account=wasser
#SBATCH --partition=wasser
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8G
#SBATCH --time=96:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/convert.%j.out
#SBATCH -e logfiles/convert.%j.err

pwd; hostname; date

module load contrib/gatk4/4.1.9.0
#module load contrib/samtools-1.11/samtools-1.11

for fn in data/bwamem/*.sam
do
    # get the path to the file
    dir=`dirname $fn`;
   
    # get just the file (without path)
    base=`basename $fn`;

    # the read filename, without the suffix
    rf=${base%.sam};

    # do what I need with it
    gatk SamFormatConverter -I ${dir}/${rf}.sam -O ${dir}/${rf}.bam
#    samtools view -S -b ${dir}/${rf}.sam > ${dir}/${rf}.bam
#    java -jar picard.jar SamFormatConverter -I=${dir}/${rf}.sam -O=${dir}/${rf}.bam

done
