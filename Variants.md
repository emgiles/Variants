# Population Genomics
### Alignment, Variant calling and filtering
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
Compress this file with bgzip found within bcftools
```nohup bgzip species_pileup_date_called_filtered_fmiss50_variant.vcf &```
##### Create vcf with only invariant sites
```nohup bcftools filter -e 'MAF > 0.00' -Ov -o species_date_called_filtered_fmiss50_invariant.vcf species_pileup_date_called_filtered_fmiss50.vcf```
Compress this file with bgzip found within bcftools
```nohup bgzip species_pileup_date_called_filtered_fmiss50_variant.vcf &```
##### Index variant and invariant vcfs
Index using tabix which is from samtools, found in bcftools env.
```tabix species_pileup_date_called_filtered_fmiss50_variant.vcf.gz```
```tabix species_date_called_filtered_fmiss50_invariant.vcf.gz```
##### Merge the variant and invariant indexed vcfs to create an allsites vcf
```bcftools concat --allow-overlaps species_date_called_filtered_fmiss50_invariant.vcf.gz species_pileup_date_called_filtered_fmiss50_variant.vcf.gz -O z -o species_date_called_filtered_fmiss50_allsites.vcf.gz```

### Uncovering genetic structure
#### Make a PCA of the genetic data with eigensoft
For this, you need a series of files: .ped, .pedind, .map. The .ped file gives your genotypes, the .pedind file gives information about the sample and the population assignment, and the .map file gives information about the position of the loci in the genome. The pedind file is very light and useful for viewing down the line. These files can be generated from your vcf and a chrom-map.
##### Create a chrom-map

```nohup bcftools view -h species_pileup_date_called_filtered_fmiss50_variant.vcf.gz | cut -f 1 | uniq | awk '{print $0"\t"$0}' > species_chrom-map.txt & ```

##### Create a ped file
```nohup vcftools --gzvcf species_pileup_date_called_filtered_fmiss50_variant.vcf.gz --plink --chrom-map species_chrom-map.txt --out species_pileup_date_called_filtered_fmiss50_variant.ped &```

This will also create a *.map file with the snp location information

##### Create a pedind file

```cat species_pileup_date_called_filtered_fmiss50_variant.ped | cut -f1-6 > tmp```
```cat species_pileup_date_called_filtered_fmiss50_variant.ped | cut -c 1,2 | paste tmp -> species_pileup_date_called_filtered_fmiss50_variant.pedind```

The pedind file can be further parsed using sed or awk to modify sample names. Eigensoft does not like long sample names. If you do modify the sample names in the .pedind make sure to also change them in the .ped file. The last column of the pedind file should be 1 and the second to last column gives the population or species assignment. Modify accordingly.

##### Parsing the map file
The map file should have been created when you created the ped file. Parse the map file so that column 1 is not 0. You can set column 1 equal to 1. 

```awk '{$1=1}1' your_file.map > modified_file.map```

Alternatively name chromosomes:

```awk '{ if ($2 ~ /chrm1/) $1 = "1" ; print }' your_file.map > your_new_file.map```



