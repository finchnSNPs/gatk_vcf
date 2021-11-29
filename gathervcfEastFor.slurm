#! /bin/bash

#SBATCH --job-name=EForGather
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10GB
#SBATCH --time=8:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/EForGatherVCF.%j.out
#SBATCH -e logfiles/EForGatherVCF.%j.err

pwd; hostname; date

source activate snp_env

cd /gscratch/wasser/khan3/elephant_snps/data/gatk/EasternForest

gatk GatherVcfs -I EasternForest_vcflist.txt --CREATE_INDEX -O ../gvcf/EasternForest_paired_aln_sorted_dedup_merged_g.vcf.gz

