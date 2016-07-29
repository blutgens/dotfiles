#!/usr/bin/perl 
#==============================================================================
#
#         FILE:  mech_test.pl
#
#        USAGE:  ./mech_test.pl 
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Ben Lutgens (), <blutgens@mmm.com>
#      COMPANY:  3M Unix Production Support
#      VERSION:  1.0
#      CREATED:  11/01/2007 07:10:50 PM CDT
#     REVISION:  ---
#==============================================================================

use strict;
use warnings;
use WWW::Mechanize;
use Data::Dumper;
my $url = 'http://www.cpan.org';
my $searchstring = "WWW::Mechanize";
my $outfile = "out.htm";
my $mech = WWW::Mechanize->new( autocheck => 1);

$mech->get($url);
$mech->follow_link(text => "CPAN modules, distributions, and authors", n => 1);
$mech->form_name("f");
$mech->field(query => "$searchstring");
$mech->click();
my $output_page = $mech->content();
open(OUTFILE, ">", "$outfile") or die $!;
print OUTFILE "$output_page";
close(OUTFILE);
