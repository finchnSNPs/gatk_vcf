#! /bin/bash

#SBATCH --job-name=ESavGather
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10GB
#SBATCH --time=8:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/ESavGatherVCF.%j.out
#SBATCH -e logfiles/ESavGatherVCF.%j.err

pwd; hostname; date

source activate snp_env

cd /gscratch/wasser/khan3/elephant_snps/data/gatk/EasternSavanna

gatk GatherVcfs -I EasternSavanna_vcflist.txt --CREATE_INDEX -O ../gvcf/EasternSavanna_paired_aln_sorted_dedup_merged_g.vcf.gz

