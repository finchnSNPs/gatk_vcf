#!/bin/bash

#SBATCH --job-name=EForHap
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --mem=120GB
#SBATCH --time=20-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/EForHapCaller.%j.out
#SBATCH -e logfiles/EForHapCaller.%j.err

pwd; hostname; date

source activate snp_env

cat 6crisp/chromosomes.txt | parallel --verbose --joblog data/gatk/Eforgatkparallel.log -j 10 "gatk HaplotypeCaller --java-options -Xmx10g -R ./data/reference/loxAfr4/loxAfr4.v2.fasta -ERC GVCF --input data/dedup/EasternForest_paired_aln_sorted_dedup.bam --sample-ploidy 20 --max-genotype-count 231 --intervals {} --output data/gatk/EasternForest/{}_EasternForest_paired_aln_sorted_dedup_g.vcf.gz"

