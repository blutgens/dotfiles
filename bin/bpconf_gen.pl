#!/usr/bin/perl
# really silly perl script to build a bp.conf file that will work
# with our Netbackup Setup
use warnings;
use strict;

print "Enter the client name: ";
chomp(my $clientname = <STDIN>);
my $usemail = "root";
print "Enter Server Location (e.g. 277): ";
chomp(my $bldg = <STDIN>);
my @hosts = ( );
my($master, $suffix, $host) = "";

if ( $bldg == "277" ) {
    @hosts  = qw( bus277a bus277b bus277c);
    $master = "scar";
    $suffix = "pgs";
} elsif ($bldg == "243") {
    @hosts  = qw(carp bus243a bus243b);
    $master = "pointer";
    $suffix = "sgs";
}
open (my $fh, ">>", "bp.conf_$bldg") or die "$!\n";
for my $host (@hosts) {
    for my $x ( 1 .. 25 ) {
        print $fh "SERVER = " . $host . $suffix . $x . "\n";
    }
}
print $fh "SERVER = $master\nSERVER = " . $master . "q\n";
print $fh "CLIENT_NAME = $clientname\nUSEMAIL = $usemail\n";
close $fh && print "All Done!\n";

