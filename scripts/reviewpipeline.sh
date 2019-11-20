echo "DOING A PIPELINE REVIEW"
touch log/pipeline.log
for sid in $(ls log/cutadapt/*.log | cut -d"." -f1 | sed 's:log/cutadapt/::' | sort) 
do	
	echo >> log/pipeline.log
	echo "$sid : READS WITH ADAPTERS" >> log/pipeline.log
	cat log/cutadapt/$sid.log | grep "Reads with adapters" >> log/pipeline.log
	echo >> log/pipeline.log
	echo "$sid : TOTAL BASEPAIR FOR" >> log/pipeline.log
	cat log/cutadapt/$sid.log | grep "Total basepair" >> log/pipeline.log
done	
for sid in $(ls out/star | sed 's:out/star/::')
do
	echo >> log/pipeline.log
	echo "$sid : UNIQUELY MAPPED READS" >> log/pipeline.log
	cat out/star/$sid/Log.final.out | grep "Uniquely mapped reads %" >>log/pipeline.log
	echo >> log/pipeline.log
        echo "$sid : PERCENTAGE OF READS MAPPED TO MULTIPLE LOCI" >> log/pipeline.log
        cat out/star/$sid/Log.final.out | grep "% of reads mapped to multiple loci" >>log/pipeline.log
 	echo >> log/pipeline.log
        echo "$sid PERCENTAGE OF READS MAPPET TO TOO MANY LOCI" >> log/pipeline.log
        cat out/star/$sid/Log.final.out | grep "% of reads mapped to too many loci" >>log/pipeline.log  
done
echo "DO YOU WANT TO SEE IN THE SCREEN THE REVIEW?: 1=Yes or 2=NO"
select yn in "Yes" "No"; do
        case $yn in
                Yes ) cat log/pipeline.log; exit;;
                No ) echo "OK, YOU CAN FIND IT IN /decont/log/pipeline.log"; exit;;
        esac
done

