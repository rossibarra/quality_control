# quality_control
quality control pipeline for new sequence lanes

## To Run
	sbatch -p <queue> qc.sh <fastq file name>

If you want to run on multiple fastq files, put the list of file names in a text file (for example fastqs.txt) and run:

	for i in $(cat fastqs.txt); do sbatch -p <queue> qc.sh $i; done
