# Population Genomics
### Alignment of resequencing data to genomes
Before starting make sure to install miniconda, bwa-mem2, samtools, and all dependencies. Obtain reference genome and resequencing data. I suggest copying data to a new drive and working from said drive. A huge amount of storage space will be needed for all of the .bam files. Check quality of genome see "Genomes" tutorial. Check quality of resequence data.
```conda activate bwa-mem2```
### Interspecific protocol
First create a new working directory to place all .fq.gz files for all species. Mine is scur_vir_zeb/reseq_data. In my working directory I have included six individulas of scurra, 70 individuals of viridula, and 50 individuls of zebrina.
##### Index genome
Index the genome to be used as a reference.
```nohup bwa-mem2 index -p scurra /media/pablo/disco1/pablo/scurria_genome_data/HiRise/jasmine-uni1728-mb-hirise-3bs35_08-29-2020__hic_output.fasta &```
##### Alignment to reference genome
This must be done for each individual including both the forward and reverse Illumina/DNBseq reads. Thus, a .bam file will be created for each individual. This will be done using the loop found in the script bwa_align.sh. Use nano to double check the script. The script can be found in ~/scur_vir_zeb/reseq_data. The creation of all of the .bam files took several days.
```nohup ./bwa_align.sh &```
##### Check the alignment mapping %
This will also be done using a loop. The alignment script can also be found in ~/scur_vir_zeb/reseq_data. Ideally all mapping % is above 90%.
```./ samtools_flagstat.sh```
##### Make vcf pileup
All .bam files have been placed in the subdirectory ~/scur_vir_zeb/reseq_data/alignments. With the option -Ov this will create an uncompressed vcf file. The option -q 30 specifies the minimum mapping quality for an alignment to be used. The option -Q specifies the minimum quality for a base to be used.
```nohup bcftools mpileup --threads 20 --skip-indels -q 30 -Q 20 -f /media/pablo/disco1/pablo/scurria_genome_data/HiRise/jasmine-uni1728-mb-hirise-3bs35_08-29-2020__hic_output.fasta -Ov -o scurra_viridula_zebrina_pileup_19may2023.vcf /media/pablo/Seagate/Emily/scur_vir_zeb/reseq_data/alignments/*.bam &```
##### Make bcf pileup
We will use the same script with -Ob to create a compressed bcf file.
```nohup bcftools mpileup --threads 10 --skip-indels -q 30 -Q 20 -f /media/pablo/disco1/pablo/scurria_genome_data/HiRise/jasmine-uni1728-mb-hirise-3bs35_08-29-2020__hic_output.fasta -Ob -o scurra_viridula_zebrina_pileup_22may2023.bcf /media/pablo/Seagate/Emily/scur_vir_zeb/reseq_data/alignments/*.bam &```
##### Check the number of variants
Use ```head``` to check the layout of the vcf file. A VCF file usually has a header line starting with a # followed by one line per variant. 
```head scurra_viridula_zebrina_pileup_19may2023.vcf```

We can use ```grep``` to count the number of # which should be equal to the number of variants.
```grep -c "#" scurra_viridula_zebrina_pileup_19may2023.vcf```
##### 

### Intraspecific protocol
##### Index genome
This must be done for each genome.
```nohup bwa-mem2 index -p viridula /media/pablo/disco1/pablo/scurria_genome_data/emily/viridula/VG2_canu_purged_purged_ragtag.scaffold.fasta &```
##### Alignment to reference genome
This must be done for each individual including both the forward and reverse Illumina/DNBseq reads. Thus, a .bam file will be created for each individual.
```bwa-mem2 mem -t 20 viridula viridula_93_1.fq.gz viridula_93_2.fq.gz | samtools sort -o viridula_93_out_sorted.bam```
##### Check quality of alignments
```conda activate samtools```
```samtools quickcheck -v viridula_91_out_sorted.bam >bad_bams.fofn && echo 'all ok' || echo 'some files failed check, see bad_bams.fofn'```
Use samtools flagstat to check mapping %
```samtools flagstat archivo.bam```