#!/bin/bash -l
#SBATCH -o out/out-%j.txt
#SBATCH -e error/error-%j.txt
#SBATCH -J qc_ref
set -e
set -u

module load bwa/0.7.9a

# check for reference, if not exit
if [ ! -f data/ref.fasta.gz ]; then
        echo "ERROR: no reference genome"
        exit 1 
fi;

#make index
bwa index data/ref.fasta.gz
