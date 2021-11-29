#!/bin/bash

#SBATCH --job-name=WForHap
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --mem=120GB
#SBATCH --time=20-00:00:00
#SBATCH -o logfiles/WForHapCaller.%j.out
#SBATCH -e logfiles/WForHapCaller.%j.err

pwd; hostname; date

source activate snp_env

cat 6crisp/chromosomes.txt | parallel --verbose --joblog data/gatk/Wforgatkparallel.log -j 12 "gatk HaplotypeCaller --java-options -Xmx10g -R ./data/reference/loxAfr4/loxAfr4.v2.fasta -ERC GVCF --input data/dedup/WesternForest_paired_aln_sorted_dedup.bam --sample-ploidy 36 --max-genotype-count 703 --intervals {} --output data//gatk/WesternForest/{}_WesternForest_paired_aln_sorted_dedup_g.vcf.gz"

