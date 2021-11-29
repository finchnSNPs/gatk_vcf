#!/bin/bash

#SBATCH --job-name=ESavHap
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=120GB
#SBATCH --time=20-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/ESavHapCaller.%j.out
#SBATCH -e logfiles/ESavHapCaller.%j.err

pwd; hostname; date

source activate snp_env

cat 6crisp/chromosomes.txt | parallel --verbose --joblog data/gatk/Esavgatkparallel.log -j 10 "gatk HaplotypeCaller --java-options -Xmx10g -R ./data/reference/loxAfr4/loxAfr4.v2.fasta -ERC GVCF --input data/dedup/EasternSavanna_paired_aln_sorted_dedup.bam --sample-ploidy 20 --max-genotype-count 231 --intervals {} --output data/gatk/EasternSavanna/{}_EasternSavanna_paired_aln_sorted_dedup_g.vcf.gz"
