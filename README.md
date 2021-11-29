# gatk_vcf
GATK vcf workflow. UW Biology Wasser Lab.

Following GATK best practices. 

Sorted, indexed, BAM files (duplicates markered)
Haplotype caller - on a per/individual/per/chromosome basis
Individuals merged by chromosome by generating a Genomics Database
GenotypeVCFs run in 1kb genomic sections for each chromosome or unknwon chromosome contig
"khan3" indicates a script written by Kin

1. index (1_index_ref.sh; khan3) for the reference as well as a sequence dictionary (2_create_dict.sh; khan3) generated 
2. sequence read files trimmed (3_cut_adapt.sh; khan3) 
3. sequence reads aligned to the v4 elephant genome (4_bsa.sh; khan3), converted to a bam file (5_convertbam.sh; khan3), sorted (6_sortreads.sh; khan3), assessed for mapping quality (7_qualimap.sh; khan3), and duplicated marked (8_dedup.sh; khan3)
4. HaplotypeCaller (hapcallerEastFor.sh; hapcallerNorthSav1.slurm; hapcallerNorthSav2.slurm; hapcallerSouthSav.slurm, hapcallerWestFor.slurm; khan3) performed for each interval. 
5. Sample maps generated (gnomixdb_mapmaker.sh; finchnSNPs) for each chromosome so that individual gvcfs for each interval can be combined in the GenomicsDB.
6. GenomicsDB generated for each chromosome (gnotpgvcf.sh; finchnSNPs). 
7. The GenotypeVCFs step is computationally intensive (especially with pooled data), so it is recommended to run processed on smaller intervals. To this point, we had been using chromosomes as intervals. For this step, we will use distinct 1kb genomic regions as intervals (interval_makers.sh, which calls interval_lists.R)
