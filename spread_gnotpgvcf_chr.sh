#!/bin/bash

#run

#SBATCH --job-name=spread_50b_gnotpgvcf
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=7G
#SBATCH --time=10-00:00:00
#SBATCH --array=0-4999%50
#SBATCH -o log/spread_50b_gnotpgvcf_%A_%a.out
#SBATCH -e log/spread_50b_gnotpgvcf_%A_%a.err

module load singularity

cd /gscratch/wasser/khan3/elephant_snps/data/gatk/gvcf

if test -d "chr1"; then
	echo "chr1 output directory exists"
elif test ! -d "chr1"; then
	mkdir chr1
fi

INTS=($(cat /gscratch/wasser/khan3/elephant_snps/data/gatk/interval_lists/seqstats/chr1_50b_intervals.txt|head -115000|tail -100000))

INT=${INTS[$SLURM_ARRAY_TASK_ID]}

if test -f "chr1/${INT}_merged.vcf.gz.tbi"; then
	echo "${INT} complete"
elif test ! -f "chr1/${INT}_merged.vcf.gz.tbi"; then
	singularity exec --bind /gscratch /gscratch/wasser/containers/gatk-4.0.2.0.sif gatk --java-options "-Xmx4g" GenotypeGVCFs -R /gscratch/wasser/khan3/elephant_snps/data/reference/loxAfr4/loxAfr4.v2.fasta -V gendb://genomicsdb_chr1 -L $INT -O chr1/${INT}_merged.vcf.gz
	echo "${INT} complete"
	echo "${INT}" >> chr1_50b_intervals_complete.txt
fi

