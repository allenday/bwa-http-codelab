#!/usr/bin/perl
use strict;
use File::Temp qw(tempfile);

my $i = 0;
my $records_per_batch = 1000;
my $lines_per_record = 8;
my @buf = ();
my $args = shift @ARGV;
my $url = "http://HOSTNAME/cgi-bin/bwa.cgi";

while ( my $line = <> ) {
  push @buf, $line;
  if ( $i > 0 && $i % ($records_per_batch * $lines_per_record) == 0 ) {
    flush();
  }
  $i++;
}
flush();

sub flush {
  my ( $fh, $filename ) = tempfile();
  print $fh $_ foreach @buf;
  close( $fh );
  my $sam = undef;
  while ( 1 ) {
    open( $sam, "curl -D - -s --form args='$args' --form database=all.con --form fastq=\@$filename $url | grep -vE '^\@' |" );
    last if $sam;
    print STDERR "failed to connect to server: $!\n";
    sleep(5);
  }
  while ( my $line = <$sam> ) {
    print $line;
  }
  close( $sam );
  @buf = ();
  print STDERR "processed: " . ($i/$lines_per_record) . " records\n";
}
