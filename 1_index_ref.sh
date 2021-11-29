#!/bin/bash

#SBATCH --job-name=indexsort
#SBATCH --account=wasser
#SBATCH --partition=wasser
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=8G
#SBATCH --time=12:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/indexsort.%j.out
#SBATCH -e logfiles/indexsort.%j.err

pwd; hostname; date

module load contrib/bwa/0.7.17
module load contrib/samtools-1.11/samtools-1.11

bwa index ./data/reference/loxAfr4/loxAfr4.v2.fasta

samtools faidx ./data/reference/loxAfr4/loxAfr4.v2.fasta
