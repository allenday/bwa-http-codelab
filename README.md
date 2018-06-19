# bwa-http-codelab
Build an autoscaling and managed BWA cluster on Google Cloud.

# See also:
* https://github.com/allenday/bwa-http-docker, the Docker configuration upon which this codelab depends, and
* https://hub.docker.com/r/allenday/bwa-http-docker/, the compiled Docker image from the repo linked above.

# Todo:
* Add variable load balancer host and database name to perl script
* Parallelize perl script to demo autoscaling. socket polling?
* Alter MIG configuration to lower CPU utilization - will increase autoscaling sensitivity for demo purpose.
* Add rice sample download URL
* bring in rice yaml file used for rice3k DV alignment. prod example
