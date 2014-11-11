#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  netent_test.pl
#
#        USAGE:  ./netent_test.pl 
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
#      CREATED:  10/25/2007 08:09:42 PM CDT
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Net::SSH::Perl;

my $user = "blutgens";
my $target = "gw";
my $cmd = "ls";
my %ssh_args = ( );
my $ssh = Net::SSH::Perl->new($target, %ssh_args);
$ssh->login($user);
my($stdout, $stderr, $exit) = $ssh->cmd("xterm");
print "$stderr\n" if $stderr;
print "$stdout\n" if $stdout;


