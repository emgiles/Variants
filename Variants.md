# Population Genomics
### Alignment of resequencing data to genomes
Before starting make sure to install miniconda, bwa-mem2, samtools, and all dependencies. Obtain reference genome and resequencing data. I suggest copying data to a new drive and working from said drive. A huge amount of storage space will be needed for all of the .bam files. Check quality of genome see "Genomes" tutorial. Check quality of resequence data.
```conda activate bwa-mem2```
### Interspecific protocol
First create a new working directory to place all .fq.gz files for all species.
##### Index genome
Index the genome to be used as a reference.
```nohup bwa-mem2 index -p species1 {PWD}/reference.fasta &```
##### Alignment to reference genome
This must be done for each individual including both the forward and reverse Illumina/DNBseq reads. Thus, a .bam file will be created for each individual. This will be done using the loop found in the script bwa_align.sh. Use nano to double check the script. The creation of all of the .bam files took several days.
```nohup ./bwa_align.sh &```
##### Check the alignment mapping %
This will also be done using a loop. Ideally all mapping % is above 90%.
```./samtools_flagstat.sh```
##### Make vcf pileup
Place all .bam files in a subdirectory. With the option -Ov this will create an uncompressed vcf file. The option -q 30 specifies the minimum mapping quality for an alignment to be used. The option -Q specifies the minimum quality for a base to be used.
```nohup bcftools mpileup --threads 20 --skip-indels -q 30 -Q 20 -f {PWD}/reference.fasta -Ov -o species_pileup_date.vcf {PWD}/alignments/*.bam &```
##### Call genotypes
```nohup bcftools call -m -Ov -f GQ -o species_pileup_date_called.vcf species_pileup_date.vcf & ```
##### Filter vcf for data/ mapping quality
```nohup bcftools filter -Ov -o species_pileup_date_called_filtered.vcf -i 'DP>= 4 &MQ >= 40 & QUAL >= 30' species_pileup_date_called.vcf & ```
##### Filter vcf for missing data
```nohup bcftools filter -e 'F_MISSING > 0.5' -Ov -o species_pileup_date_called_filtered_fmiss50.vcf species_pileup_date_called_filtered.vcf &```
##### Create vcf with variants only
```nohup bcftools filter -i 'MAC >= 1' -Ov -o species_pileup_date_called_filtered_fmiss50_variant.vcf species_pileup_date_called_filtered_fmiss50.vcf &```
##### Create vcf with only invariant sites
```nohup bcftools filter -e 'MAF > 0.00' -Ov -o species_date_called_filtered_fmiss50_invariant.vcf species_pileup_date_called_filtered_fmiss50.vcf```

