# QC pipeline 
Run this pipeline to get initial quality control for new sequence lanes.

## To Run
	while read r1 r2; do sbatch -p <queue> qc.sh $r1 $r2; done < list.txt

Where ``list.txt`` is a file with the full path to read1 and read2 on a single line separated by white space. 
If you have multiple lanes you want to run simultaneously, then each line of the file should have read1 and read2 separated by white space.

Ideally this should be run on gzipped fastq files. 
The script will create a directory of summaries named after each file, with an html output called fastqc_report.html in each directory. 
The script assumes adapters in adapters.fa are correct. 
This should be the case from most Illumina libraries, but if in doubt check with the lab manager or facility that made the libraries. 
The initial quality report will also list over-represented sequences, which should include adapters if there is considerable adapter contamination.
