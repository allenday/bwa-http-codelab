# bwa-http-codelab
Build an autoscaling and managed BWA cluster on Google Cloud.

# See also:
* https://github.com/allenday/bwa-http-docker, the Docker configuration upon which this codelab depends, and
* https://hub.docker.com/r/allenday/bwa-http-docker/, the compiled Docker image from the repo linked above.

# Todo:
* Add variable load balancer host and database name to perl script
* Parallelize perl script to demo autoscaling. socket polling?
* Load testing cmd: `samtools view ERR626448.bam | perl -ne '@F=split/\s+/;print qq(\@$F[0]\n$F[9]\n+\n$F[10]\n)' | perl ./load-test.pl -p > /dev/null` 
* Add rice sample download URL (wget https://storage.googleapis.com/rice-3k/PRJEB6180/primary/ERS467753/ERR626448.bam)
