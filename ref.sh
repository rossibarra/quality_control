#!/bin/bash -l
#SBATCH -o out/
#SBATCH -e error/
#SBATCH -J qc_ref
set -e
set -u

# check for reference, if not exit
if [ ! -f data/ref.fasta.gz ]; then
        echo "ERROR: no reference genome"
        exit 1 # terminate and indicate error
fi;

#make index
bwa index data/ref.fasta.gz
