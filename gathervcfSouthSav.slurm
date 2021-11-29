#! /bin/bash

#SBATCH --job-name=SSavGather
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10GB
#SBATCH --time=48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/SSavGatherVCF.%j.out
#SBATCH -e logfiles/SSavGatherVCF.%j.err

pwd; hostname; date

source activate snp_env

cd /gscratch/wasser/khan3/elephant_snps/data/gatk/SouthernSavanna

gatk GatherVcfs -I SouthernSavanna_vcflist.txt --CREATE_INDEX -O ../gvcf/SouthernSavanna_paired_aln_sorted_dedup_merged_g.vcf.gz

