#!/bin/bash -l
#SBATCH -o out/ 
#SBATCH -e error/
#SBATCH -J fastq_QC
set -e
set -u

module load fastqc fastqmcf bwa/0.7.9a samtools/0.1.19

FASTQ=$1


# STEP 1, check quality

fastqc -f fastq file.fastq
	cat summary.txt


#to check the number of read per lib.
	for i in *fastq.gz; do echo $i >>tmp.txt; gunzip -c $i| grep -c '@J00113' >> tmp.txt ; done

gunzip *.gz

	#remove adapter contamination and filter for better quality
	fastq-mcf ~/BWA-mem/adaptor.fa Lo8_S12_L007_R1_001.fastq   -o Lo8_S12_L007_R1_001.fastq_filt.fastq Lo8_S12_L007_R2_001.fastq  -o Lo8_S12_L007_R2_001.fastq_filt.fastq  
fastq-mcf ~/BWA-mem/adaptor.fa Tvid_S11_L006_R1_001.fastq   -o Tvid_S11_L006_R1_001.fastq_filt.fastq Tvid_S11_L006_R2_001.fastq  -o Tvid_S11_L006_R2_001.fastq_filt.fastq 

rezipper les fastq files	
	
	#to construct the reference genome unzip the gz and untar the file
	gunzip file.tar.gz
	tar xvf file.tar
	cat *.fasta > ZmB73_RefGen_v2.fa
	bwa index ZmB73_RefGen_v2.fa
	
bwa mem -t8 /home/alorant/BWA-memGenome2/ZmB73_RefGen_v2.fa Tvid_S11_L006_R1_001.fastq_filt.fastq Tvid_S11_L006_R2_001.fastq_filt.fastq > alignment-Tvid-AGPv2.sam
	
bwa mem -t8 /home/alorant/BWA-mem/Zea_mays.AGPv3.22.dna.genome.fa Lo8_S12_L007_R1_001.fastq_filt.fastq Lo8_S12_L007_R2_001.fastq_filt.fastq > alignment-Lo8-AGPv3.sam


	#change format from .sam to .bam
	samtools view -bS alignment-peTvicAGPv2.sam > alignment-peTvicAGPv2.bam
	
	#remove PCR duplicates
	samtools rmdup alignment-peTvicAGPv2.bam alignment-peTvicAGPv2-rmdup.bam
	
	#sort BAM file
	samtools sort alignment-peTvicAGPv2-rmdup.bam alignment-peTvicAGPv2-rmdup.sorted.bam
	
	#Index the BAM file
	samtools index alignment-peTvicAGPv2-rmdup.sorted.bam
	
	#Mapping stat (open txt file)
	samtools flagstat alignment-peTvicAGPv2-rmdup.sorted.bam > mappingstatsTvicAGPv2.txt
	
	#cleanup
	rm alignment-peTvicAGPv2.bam alignment-pe.sam alignment-pe.rmdup.bam
	
#go to programmes/qualimap
	./qualimap bamqc -bam /home/alorant/BWA-memGenome2/alignment-peTvicAGPv2-rmdup.sorted.bam -outdir qualimapTvicAGPv2_results


compter le nombre de fichier dans le dossier
ls -Al | wc -l
	
