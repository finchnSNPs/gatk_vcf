#!/bin/bash

#SBATCH --job-name=dedup
#SBATCH --account=wasser
#SBATCH --partition=wasser
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=40GB
#SBATCH --time=168:00:00
#SBATCH -o logfiles/dedup.%j.out
#SBATCH -e logfiles/dedupp.%j.err

pwd; hostname; date

module load contrib/gatk4/4.1.9.0

for fn in data/sorted/*_sorted.bam
do
  dir=`dirname $fn`;
  base=`basename $fn`;
  rf=${base%.bam};

	gatk MarkDuplicates --java-options -Xmx32g --CREATE_INDEX true --INPUT ${dir}/${base} --METRICS_FILE data/dedup/${rf}_dedup.metrics --OUTPUT data/dedup/${rf}_dedup.bam
done 
