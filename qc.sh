#!/bin/bash -l
#SBATCH -o out/ 
#SBATCH -e error/
#SBATCH -J fastq_QC
#SBATCH -c 4
set -e
set -u

module load fastqc fastqmcf bwa/0.7.9a samtools/0.1.19

# Get read 1 and read 2
fq_r1=$( echo $1 | awk '{gsub(/\/.*\//,"",$1); print}'  )
fq_r2=$( echo $2 | awk '{gsub(/\/.*\//,"",$1); print}'  )

# STEP 1, check quality

fastqc -f fastq -t 4 -o results $fq_r1
fastqc -f fastq -t 4 -o results $fq_r2

# STEP 2, make subset for testing for alignment

seed=$RANDOM
seqtk sample -s$seed $fq_r1 0.02 > data/"$fq_r1".sub.fq
seqtk sample -s$seed $fq_r2 0.02 > data/"$fq_r2".sub.fq

# STEP 3, align 

# check for reference, if not exit
if [ ! -f data/ref.bwt ]; then
	echo "ERROR: no reference genome index. Please run ref.sh (see readme)"
    	exit 1 # terminate and indicate error
fi;

#align
bwa mem -t4 data/ref.fasta data/"$fq_r1".sub.fq data/"$fq_r2".sub.fq  | \
#convert to bam
samtools view -bS - | \
#remove duplicates
samtools rmdup - | \
#sort 
samtools sort -o results/"$fq_r1".sorted.bam - 
	
# STEP 4, QC on alignment

samtools flagstat - > results/"$fq_r1".flagstat

#qualimap bamqc -bam results/"$fq_r1".sorted.bam -outdir results/

