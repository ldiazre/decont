echo "ANLYSING HAS STARTED"
#Download all the files specified in data/urls
for url in $(cat data/urls) 
do
    bash scripts/download.sh $url data
done

# Download the contaminants fasta file, and uncompress it
bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz res yes
echo "ALL NECESSARY DATA HAVE BEEN DOWNLOADED"
# Index the contaminants file
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx

# Merge the samples into a single file
echo "RUNNING FASTQ"
for sid in $(ls data/*.fastq.gz | cut -d"-" -f1 | sed 's:data/::' | sort | uniq)
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done

# Run cutadapt for all merged files
echo "RUNNING CUTADAPT"
mkdir -p log/cutadapt
mkdir -p out/trimmed 
for sid in $(ls out/merged/*fastq.gz | cut -d"." -f1 | sed 's:out/merged/::' )
do
	cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed -o out/trimmed/$sid.trimmed.fastq.gz  out/merged/$sid.fastq.gz > log/cutadapt/$sid.log
	echo "CUTADAPT DONE FOR $sid"
done
# Run STAR for all trimmed files
echo "RUNNING STAR ALIGNMENT"
for fname in out/trimmed/*.fastq.gz
do
	sid=$(echo $(basename $fname .trimmed.fastq.gz))
	mkdir -p out/star/$sid/
    	STAR --runThreadN 4 --genomeDir res/contaminants_idx --outReadsUnmapped Fastx --readFilesIn $fname --readFilesCommand zcat --outFileNamePrefix out/star/$sid/
	echo "ALIGNMENT DONE FOR $sid"
echo "ANALYSING FOR $sid HAVE FINISHED"
done
# TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
