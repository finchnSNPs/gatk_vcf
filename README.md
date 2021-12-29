# gatk_vcf
GATK vcf workflow. UW Biology Wasser Lab.
Designed specifically to use UW HYAK Klone and SLURM job scheduler. 

SUMMARY: Following GATK best practices: Sorted, indexed, BAM files (duplicates marked). Haplotype caller - on a per/individual/per/chromosome basis. Individuals merged by chromosome by generating a Genomics Database. GenotypeVCFs run in 1kb genomic sections for each chromosome or unknwon chromosome contig. 

"khan3" indicates a script written by Kin

DETAILED-ISH PROTOCOL:
1. index (1_index_ref.sh; khan3) for the reference as well as a sequence dictionary (2_create_dict.sh; khan3) generated 
2. sequence read files trimmed (3_cut_adapt.sh; khan3) 
3. sequence reads aligned to the v4 elephant genome (4_bsa.sh; khan3), converted to a bam file (5_convertbam.sh; khan3), sorted (6_sortreads.sh; khan3), assessed for mapping quality (7_qualimap.sh; khan3), and duplicated marked (8_dedup.sh; khan3)
4. HaplotypeCaller (hapcallerEastFor.sh; hapcallerEastSav.sh, hapcallerNorthSav1.slurm; hapcallerNorthSav2.slurm; hapcallerSouthSav.slurm, hapcallerWestFor.slurm; khan3) performed for each interval. 
5. Sample maps generated (gnomixdb_mapmaker.sh; finchnSNPs) for each chromosome so that individual gvcfs for each interval can be combined in the GenomicsDB.
6. GenomicsDB generated for each chromosome (gnotpgvcf.sh; finchnSNPs). 
7. The GenotypeVCFs step is computationally intensive (especially with pooled data), so it is recommended to run processed on smaller intervals. To this point, we had been using chromosomes as intervals. For this step, we will use distinct 1kb genomic regions as intervals (interval_makers.sh, which calls interval_lists.R; finchnSNPs)
8. GenotypeVCF on sub-chromosomal intervals at 1kb (gnotpgvcf_chrs.sh; finchnSNPs). This script calls remaining_chr.txt, which was generated with (remaining_chr.sh; finchnSNPs). This step was necessary because some chromosome were complete in development of these scripts, gnotpgvcf_chrs.sh first checks if genotyping has been completed at the chromosome, then the sub chromosome level. The script also calls the intervals file generated with (interval_lists.R; finchnSNPs). chr1_50b_intervals.txt included as an example interval list output. 
8b. GenotypeVCF on sub-chromosomal intervals at 50b (gnotpgvcf_50b.sh; finchnSNPs). This script calls remaining_chr.txt, which was generated with (remaining_chr.sh; finchnSNPs) and some post filtering. This script sends each chromosome to a node and performs GenotypeVCF on each 50b interval sequentially. 
8c. GenotypeVCF on sub-chromosomal intervals at 50b one chromosome at a time (spread_gnotpgvcf_chr.sh; finchnSNPs). This script performd GenotypeVCF on each 50b interval simulatneously for job array volume for one chromosome at a time, sending each interval to a node. 

Next steps: 
1. MergeVCFs intervals to chromosomes
2. poolfstat
