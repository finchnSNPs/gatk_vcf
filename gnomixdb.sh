#!/bin/bash

#run
#20211020

#SBATCH --job-name=gnomixdb
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --array=0-2302
#SBATCH --mem=40G
#SBATCH --time=4-00:00:00
#SBATCH -o gnomixdb_%A_%a.out
#SBATCH -e gnomixdb_%A_%a.err

module load singularity

cd /gscratch/wasser/khan3/elephant_snps/data/gatk/gvcf

CHRS=($(ls -1 *.map|sed 's/.map//'))

CHR=${CHRS[$SLURM_ARRAY_TASK_ID]}

singularity exec --bind /gscratch /gscratch/wasser/containers/gatk-4.0.2.0.sif gatk --java-options "-Xmx4g -Xms4g" GenomicsDBImport --genomicsdb-workspace-path genomicsdb_$CHR -L $CHR --sample-name-map ${CHR}.map
