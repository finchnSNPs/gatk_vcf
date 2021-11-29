#!/bin/bash

#SBATCH --job-name=SSavHap
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=120GB
#SBATCH --time=20-00:00:00
#SBATCH -o logfiles/SSavHapCaller.%j.out
#SBATCH -e logfiles/SSavHapCaller.%j.err

pwd; hostname; date

source activate snp_env

cat 6crisp/chromosomes.txt | parallel --verbose --joblog data/gatk/SSavgatkparallel.log -j 10 "gatk HaplotypeCaller --java-options -Xmx10g -R ./data/reference/loxAfr4/loxAfr4.v2.fasta -ERC GVCF --input data/dedup/SouthernSavanna_paired_aln_sorted_dedup.bam --sample-ploidy 20 --max-genotype-count 231 --intervals {} --output data/gatk/SouthernSavanna/{}_SouthernSavanna_paired_aln_sorted_dedup_g.vcf.gz"

