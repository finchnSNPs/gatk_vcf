#!/bin/bash

#SBATCH --job-name=sample_maps
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=1G
#SBATCH --time=4:00:00
#SBATCH -o sample_maps.%j.out
#SBATCH -e sample_maps.%j.err

module load singularity

chrs=$(cat /gscratch/wasser/khan3/elephant_snps/chromosomes.txt)

for chr in $chrs
do
	files=$(ls -1 /gscratch/scrubbed/finchkn/tmp/*vcf.gz|grep "${chr}_")
	for i in $files
	do
		sampleID=$(singularity exec --bind /gscratch/ /gscratch/wasser/containers/bcftools.sif bcftools query -l $i)
		echo -e "${sampleID}\t${i}">>/gscratch/wasser/khan3/elephant_snps/data/gatk/gvcf/${chr}.map
	done
done
