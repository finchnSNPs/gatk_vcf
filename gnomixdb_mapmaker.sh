#!/bin/bash

#run
#20211015

#SBATCH --job-name=sample_maps
#SBATCH --account=wasser
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=40G
#SBATCH --time=20:00:00
#SBATCH -o sample_maps.%j.out
#SBATCH -e sample_maps.%j.err




module load singularity

chrs=$(cat /gscratch/wasser/khan3/elephant_snps/chromosomes.txt)

#dirs=$(ls -1 --hide=archive /gscratch/wasser/khan3/elephant_snps/data/gatk/gvcf/)

#mkdir /gscratch/scrubbed/finchkn/tmp

#for dir in $dirs
#do
#	cd /gscratch/wasser/khan3/elephant_snps/data/gatk/gvcf/
#	cp $dir/*.vcf.gz /gscratch/scrubbed/finchkn/tmp/
#done

for chr in $chrs
do
	files=$(ls -1 /gscratch/scrubbed/finchkn/tmp/*vcf.gz|grep "${chr}_")
	for i in $files
	do
		sampleID=$(singularity exec --bind /gscratch/ /gscratch/wasser/containers/bcftools.sif bcftools query -l $i)
		echo -e "${sampleID}\t${i}">>/gscratch/wasser/khan3/elephant_snps/data/gatk/gvcf/${chr}.map
	done
done

#for chr in $chrs
#do
#	files=$(ls -1 /gscratch/scrubbed/finchkn/tmp/*vcf.gz|grep "${chr}_")
#	for j in $files
#	do
#		sampleID=$(singularity exec --bind /gscratch/ /gscratch/wasser/containers/bcftools.sif bcftools query -l $j)
#		echo -e "${sampleID}\t${j}">/gscratch/wasser/khan3/elephant_snps/data/gatk/gvcf/${chr}.map
#	done
#done


