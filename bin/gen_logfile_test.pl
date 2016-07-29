#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  gen_logfile_test.pl
#
#        USAGE:  ./gen_logfile_test.pl 
#
#  DESCRIPTION:  Opens and Lock a fake logfile, periodically writes some small
#  data to it. 
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Ben Lutgens (), <blutgens@mmm.com>
#      COMPANY:  3M Unix Production Support
#      VERSION:  1.0
#      CREATED:  Thu, Nov 15, 2007 08:43:20 AM CST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Fcntl qw( :flock);

open(LOG, ">>", "test.log") or die "Can't open logfile: $!";
#flock(LOG,LOCK_EX);

while (1) {
    print LOG "yipee!\n";
    sleep 5;
}

