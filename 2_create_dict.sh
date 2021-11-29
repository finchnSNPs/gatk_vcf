#!/bin/bash

#SBATCH --job-name=dictionary
#SBATCH --account=wasser
#SBATCH --partition=wasser
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10GB
#SBATCH --time=48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=khan3@uw.edu
#SBATCH -o logfiles/createseqdict.%j.out
#SBATCH -e logfiles/createseqdict.%j.err

pwd; hostname; date

module load contrib/gatk4/4.1.9.0

# gatk CreateSequenceDictionary -R ./data/reference/loxAfr3.fa -O ./data/reference/loxAfr3.dict

gatk CreateSequenceDictionary -R ./data/reference/loxAfr4/loxAfr4.v2.fasta -O ./data/reference/loxAfr4/loxAfr4.v2.dict
