#!/bin/bash

#SBATCH --job-name=NSav1Hap
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=120GB
#SBATCH --time=20-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/NSavHapCaller.%j.out
#SBATCH -e logfiles/NSavHapCaller.%j.err

pwd; hostname; date

source activate snp_env

cat 6crisp/chromosomes.txt | parallel --verbose --joblog data/gatk/NSavgatkparallel.log -j 10 "gatk HaplotypeCaller --java-options -Xmx10g -R ./data/reference/loxAfr4/loxAfr4.v2.fasta -ERC GVCF --input data/dedup/NorthernSavanna1_paired_aln_sorted_dedup.bam --sample-ploidy 14 --max-genotype-count 120 --intervals {} --output data/gatk/NorthernSavanna1/{}_NorthernSavanna1_paired_aln_sorted_dedup_g.vcf.gz"

