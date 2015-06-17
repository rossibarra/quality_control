# QC pipeline 
Run this pipeline to get initial quality control for new sequence lanes. 

## To Run

#### Download the reference genome. 
This can be done by running

	wget ftp://ftp.ensemblgenomes.org/pub/plants/release-27/fasta/zea_mays/dna//Zea_mays.AGPv3.27.dna.genome.fa.gz

on most unix systems.  You may need to use ``curl`` instead on a OSX. 

Move the reference into the ``data`` directory and rename as ``ref.fasta.gz`` (keep the reference gzipped).
Then run:

	sbatch -p <queue> ref.sh

This will index the reference for you.

#### Quality Control of fastq

For quality control, then run:

	while read r1 r2; do sbatch -p <queue> qc.sh $r1 $r2; done < list.txt

Where ``list.txt`` is a file with the full path to read1 and read2 on a single line separated by white space. 
If you have multiple lanes you want to run simultaneously, then each line of the file should have read1 and read2 separated by white space.

Ideally this should be run on gzipped fastq files. 

The script will create a directory of summaries named after each file in the ``results`` directory, with an html output called ``fastqc_report.html`` in each directory. 
The initial quality report will also list over-represented sequences, which should include adapters if there is considerable adapter contamination.

<!-- ### Adapter and Quality Trimming

The script assumes adapters in ``adapters.fa`` are correct. 
This should be the case from most Illumina libraries, but if in doubt check with the lab manager or facility that made the libraries. 
This produces a file that ends with ``.filter.fq`` for each of your input fastq files. -->

## To test
Run with ``test_r1.fastq.gz`` and ``test_r2.fastq.gz``
