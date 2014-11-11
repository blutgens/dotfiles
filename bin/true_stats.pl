#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  true_stats.pl
#
#        USAGE:  ./true_stats.pl 
#
#  DESCRIPTION:  Show full modification, access, AND creation time for a file
#
#      OPTIONS:  takes on option, a filename
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Ben Lutgens (), <blutgens@mmm.com>
#      COMPANY:  3M Unix Production Support
#      VERSION:  1.0
#      CREATED:  Wed, Nov 14, 2007 03:28:44 PM CST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

my $thisfile = shift;
my @statbuf = stat("$thisfile");
my($atime, $mtime, $ctime) = ($statbuf[8], $statbuf[9], $statbuf[10]);
print "True stat info for $thisfile:\n";
print "      last accessed on: " . localtime($atime) . "\n";
print "      last modified on: " . localtime($mtime) . "\n";
print "last status change was: " . localtime($ctime)  . "\n";

