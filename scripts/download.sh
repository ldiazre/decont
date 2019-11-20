# This script should download the file specified in the first argument ($1), place it in the directory specified in the second argument, 
# and *optionally* uncompress the downloaded file with gunzip if the third argument contains the word "yes".
url=$1
dir=$2
yes=$3
echo "DOWNLOADING CONTAMINANTS DATA FILES"
wget -P $dir $url -nc $dir/$url
echo
if [ "$yes" == "yes" ]
then
bn=$(basename $url)
gunzip -k $dir/$bn
echo "CONTAMINANTS $bn UNZIP"
fi
