#!/bin/bash

#SBATCH --job-name=make_intervals
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=7G
#SBATCH --time=12-00:00:00
#SBATCH -o log/make_intervals_%j.out
#SBATCH -e log/make_intervals_%j.err

#use seqkit to get sequence length information

module load singularity

CHRS=$(cat /gscratch/wasser/khan3/elephant_snps/chromosomes.txt)

for CHR in $CHRS; do
	FILES=($(ls -1 /gscratch/wasser/khan3/elephant_snps/data/reference/loxAfr4/loxAfr4.v2.fasta.split/*.fasta |grep "${CHR}.fasta"))
	for FILE in $FILES; do
	singularity exec --bind /gscratch /gscratch/wasser/containers/seqkit.sif seqkit stats $FILE | sed 's/,//g'> /gscratch/wasser/khan3/elephant_snps/data/gatk/interval_lists/seqstats/${CHR}_seqstats.txt
	done
done

echo "seqkit stats done"

singularity exec --bind /gscratch /gscratch/wasser/containers/R.sif Rscript interval_lists.R

echo "R parsing done"

sed -i 's/ //g' /gscratch/wasser/khan3/elephant_snps/data/gatk/interval_lists/seqstats/*_1kb_intervals.txt

echo "1kb interval lists ready"
