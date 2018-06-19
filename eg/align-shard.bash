#!/bin/bash

T=$1
for sample in `gsutil ls -l gs://rice-3k/PRJEB6180/primary | perl -ne 'm#.+/(ERS.+?)/#;print "\$1\n"' | grep -E "$T\$" | sort -r`; do	
	echo $sample;
	gsutil -m cp -r gs://rice-3k/PRJEB6180/primary/$sample . ;
	rm -f $sample.fq ;
	for i in $sample/*.bam; do
		samtools bam2fq $i >> $sample.fq ;
		rm -f $i;
	done ;
	rm -rf $sample ;
	cat $sample.fq | bwa mem /align/all.con - -p -t 32 > $sample.sam ;
	rm -f $sample.fq ;
	samtools view -S -@ 32 -b $sample.sam > $sample.pre ;
	rm -f $sample.sam ;
	samtools sort -@ 32 $sample.pre > $sample.bam ;
	rm -f $sample.pre ;
	samtools index $sample.bam $sample.bam.bai ;
	gsutil -m cp $sample.bam gs://rice-3k/PRJEB6180/aligned-Os-Nipponbare-Reference-IRGSP-1.0/ ;
	gsutil -m cp $sample.bam.bai gs://rice-3k/PRJEB6180/aligned-Os-Nipponbare-Reference-IRGSP-1.0/ ;
	rm -rf $sample.* ;
	rm -f /align/*.bam ;
done
