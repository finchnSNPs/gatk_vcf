#!/bin/bash

#SBATCH --job-name=NSav2Hap
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=120GB
#SBATCH --time=20-00:00:00
#SBATCH -o logfiles/NSav2HapCaller.%j.out
#SBATCH -e logfiles/NSav2HapCaller.%j.err

pwd; hostname; date

source activate snp_env

cat 6crisp/chromosomes.txt | parallel --verbose --joblog data/gatk/NSav2gatkparallel.log -j 10 "gatk HaplotypeCaller --java-options -Xmx10g -R ./data/reference/loxAfr4/loxAfr4.v2.fasta -ERC GVCF --input data/dedup/NorthernSavanna2_paired_aln_sorted_dedup.bam --sample-ploidy 26 --max-genotype-count 378 --intervals {} --output data/gatk/NorthernSavanna2/{}_NorthernSavanna2_paired_aln_sorted_dedup_g.vcf.gz"

