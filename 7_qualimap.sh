#!/bin/bash

#SBATCH --job-name=qualimap
#SBATCH --account=wasser
#SBATCH --partition=wasser
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=7
#SBATCH --mem=20GB
#SBATCH --time=7-00:00:00
#SBATCH -o logfiles/qualimap.%j.out
#SBATCH -e logfiles/qualimap.%j.err

pwd; hostname; date

for fn in data/sorted/*_aln_sorted.bam
do
	dir=`dirname $fn`;
	base=`basename $fn`;
	rf=${base%_paired_aln_sorted.bam};

	qualimap bamqc -bam ${dir}/${base} -nt 7 --java-mem-size=20G -outdir 1qc/3qualimap/${rf}_qualimap -sd
done
