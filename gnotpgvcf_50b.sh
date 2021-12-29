#!/bin/bash

#run

#SBATCH --job-name=50b_gnotpgvcf
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=7G
#SBATCH --time=10-00:00:00
#SBATCH --array=0-99
#SBATCH -o log/50b_gnotpgvcf_%A_%a.out
#SBATCH -e log/50b_gnotpgvcf_%A_%a.err

module load singularity

cd /gscratch/wasser/khan3/elephant_snps/data/gatk/gvcf

CHRS=($(cat ../remaining_chr.txt|head -100))

CHR=${CHRS[$SLURM_ARRAY_TASK_ID]}

echo $CHR

FILE=$(ls -1 /gscratch/wasser/khan3/elephant_snps/data/gatk/interval_lists/seqstats/*_intervals.txt |grep "${CHR}_50b")

$(head $FILE)

INTS=$(cat $FILE)

for INT in $INTS; do
	if test -f "${CHR}/${INT}_merged.vcf.gz.tbi"; then
		echo "${INT} already done"
	elif test ! -f "{CHR}/${INT}_merged.vcf.gz.tbi"; then
		echo "Processing ${INT}"
		singularity exec --bind /gscratch /gscratch/wasser/containers/gatk-4.0.2.0.sif gatk --java-options "-Xmx4g" GenotypeGVCFs -R /gscratch/wasser/khan3/elephant_snps/data/reference/loxAfr4/loxAfr4.v2.fasta -V gendb://genomicsdb_${CHR} -L $INT -O ${CHR}/${INT}_merged.vcf.gz
	fi
done
