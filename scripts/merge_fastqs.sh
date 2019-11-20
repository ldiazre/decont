# This script should merge all files from a given sample (the sample id is provided in the third argument)
# into a single file, which should be stored in the output directory specified by the second argument.
# The directory containing the samples is indicated by the first argument.

dircontaining=$1
outputdir=$2
sid=$3

mkdir -p $outputdir
cat $dircontaining/$sid* > $outputdir/$sid.fastq.gz
echo "MERGIND DONE FOR $sid"
