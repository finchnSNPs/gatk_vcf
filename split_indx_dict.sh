#!/bin/bash

#works
#run: 
#20211014

#SBATCH --job-name=genotypes_by_contig
#SBATCH --account=wasser
#SBATCH --partition=ckpt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2303
#SBATCH --array=0-2302
#SBATCH --mem=40G
#SBATCH --time=4-00:00:00
#SBATCH -o genotypes_by_contig%A_%a.out
#SBATCH -e genotypes_by_contig%A_%a.err

pwd; hostname; date

refs=($(ls -1 /gscratch/wasser/khan3/elephant_snps/data/reference/loxAfr4/loxAfr4.v2.fasta.split/*.fasta))

echo ${refs[${SLURM_ARRAY_TASK_ID}]}

module load singularity

dir=`dirname ${refs[${SLURM_ARRAY_TASK_ID}]}`;
   
# get just the file (without path)
base=`basename ${refs[${SLURM_ARRAY_TASK_ID}]}`;

# the read filename, without the suffix
rf=${base%.fasta};

grep -c "^>" ${refs[${SLURM_ARRAY_TASK_ID}]}

singularity exec --bind /gscratch /gscratch/wasser/containers/seqkit.sif seqkit stats ${refs[${SLURM_ARRAY_TASK_ID}]}

singularity exec --bind /gscratch /gscratch/wasser/containers/bwa.sif/ bwa index ${refs[${SLURM_ARRAY_TASK_ID}]}

singularity exec --bind /gscratch /gscratch/wasser/containers/samtools-1.13.sif samtools faidx ${refs[${SLURM_ARRAY_TASK_ID}]}

singularity exec --bind /gscratch /gscratch/wasser/containers/gatk-4.0.2.0.sif gatk CreateSequenceDictionary -R ${refs[${SLURM_ARRAY_TASK_ID}]} -O ${dir}/${rf}.dict

#singularity exec --bind /gscratch /gscratch/wasser/containers/gatk-4.0.2.0.sif gatk GenotypeGVCFs --java-options -Xmx64g -R ${refs[${SLURM_ARRAY_TASK_ID}]}  -V /gscratch/wasser/khan3/elephant_snps/data/gatk/all_elephant_g.vcf.gz -O /gscratch/wasser/khan3/elephant_snps/data/gatk/vcf/${rf}_vcf.gz