#! /bin/bash

#SBATCH --job-name=NSav1Gather
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10GB
#SBATCH --time=48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/NSav1GatherVCF.%j.out
#SBATCH -e logfiles/NSav1GatherVCF.%j.err

pwd; hostname; date

source activate snp_env

cd /gscratch/wasser/khan3/elephant_snps/data/gatk/NorthernSavanna1

gatk GatherVcfs -I NorthernSavanna1_vcflist.txt --CREATE_INDEX -O ../gvcf/NorthernSavanna1_paired_aln_sorted_dedup_merged_g.vcf.gz

