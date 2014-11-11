#!/usr/bin/perl -wT

#--------------------------------------------------#
# check_megaraid
#
# check_megaraid Netsaint plugin.  Checks a Dell PERC 
#	(megaraid driver) card and reports the status of the logical
#	and physical drives.
# 
# Requires that Net::SNMP be installed on the machine performing
#	the monitoring and that the megaraid snmp agent be set up
#	on the machine to be monitored.
#
# Netsaint config example:
#
# command[check_megaraid]=/usr/local/netsaint/libexec/check_megaraid -H $HOSTADDRESS$ -C $ARG1$
# service[target_host]=megaraid;0;24x7;3;10;5;admins;60;24x7;1;1;1;;check_megaraid!public
#
#--------------------------------------------------#
#
# Copyright (C) 2002 ibiblio
# Written by: John Reuning <john@ibiblio.org>
# http://www.ibiblio.org/john/megaraid/
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
#--------------------------------------------------#
my $version = "0.8.3";
# Updated to work with nagios ePN
# last mod: 22-Mar-2007
#--------------------------------------------------#

require 5.004;

use strict;
use lib "/usr/lib/nagios/plugins";
use Net::SNMP qw(oid_lex_sort);
use utils qw($TIMEOUT %ERRORS &usage);
#use vars qw($PROGNAME);
use Getopt::Long;
Getopt::Long::Configure('bundling', 'no_ignore_case');

# variables
my(
$PROGNAME,		# Script Name
$DEBUG,			# print debug messages
%LOGDRV_CODES,
%PHYDRV_CODES,
$session,
$error,
$line,
$foo,			# represents an unused string
$host,
$community,
$port,
$timeout,
$alert,
$logdrv_data_in,
$phydrv_data_in,
$code,			# code value returned by snmp
$logdrv_oid,		# oid
$phydrv_oid,
$logdrv_id,		# drive id
$phydrv_id,
$ok,			# is the status ok?
$opt_H,
$opt_C,
$opt_p,
$opt_t,
$opt_a,
$output_str		# output status string
);

sub help();
sub version();
sub print_help();
sub print_usage();
sub print_version();

#--------------------------------------------------#
# need to manually define some things here

$PROGNAME = "check_snmp_megaraid.pl";
$DEBUG = 0;	# to print debug messages, set this to 1
%LOGDRV_CODES = (
	0=>'offline',
	1=>'degraded',
	2=>'optimal',
	3=>'initialize',
	4=>'checkconsistency'
);

%PHYDRV_CODES = (
	1=>'ready',
	3=>'online',
	4=>'failed',
	5=>'rebuild',
	6=>'hotspare',
	20=>'nondisk'
);

$logdrv_oid = ".1.3.6.1.4.1.3582.1.1.2.1.3";
$phydrv_oid = ".1.3.6.1.4.1.3582.1.1.3.1.4";
#$logdrv_oid = ".1.3.6.1.4.1.3582.1.1.2";
#$phydrv_oid = ".1.3.6.1.4.1.3582.1.1.3";

#--------------------------------------------------#
# parse command line arguments

GetOptions (
	"h|help"		=> \&help,
	"V|version"		=> \&version,
	"H|hostname=s"		=> \$opt_H,
	"C|community=s"		=> \$opt_C,
	"p|port=s"		=> \$opt_p,
	"t|timeout=s"		=> \$opt_t,
	"a|alert=s"		=> \$opt_a,
);

# hostname
($opt_H) || usage("Hostname or IP address not specified\n");
$host = $1 if ($opt_H =~ m/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+|[a-zA-Z][-a-zA-Z0-9]*(\.[a-zA-Z][-a-zA-Z0-9]*)*)$/);
if (!($host)) {
	usage("Invalid hostname: $opt_H\n");
}

# community string - defaults to "public"
($opt_C) || ($opt_C = "public");
$community = $opt_C;

# port number - defaults to 161
($opt_p) || ($opt_p = 161);
($opt_p =~ m/^[0-9]+$/) || usage("Invalid port number: $opt_p\n");
$port = $opt_p;

# timeout - defaults to netsaint timeout
($opt_t) || ($opt_t = $TIMEOUT);
($opt_t =~ m/^[0-9]+$/) || usage("Invalid timeout value: $opt_t\n");
$timeout = $opt_t;

# alert - defaults to "crit"
($opt_a) || ($opt_a = "crit");
if ($opt_a =~ /warn/) {
	$alert = "WARNING";
} elsif ($opt_a =~ /crit/) {
	$alert = "CRITICAL";
} else {
	usage("Invalid alert: $opt_a\n");
	&print_usage;
	$alert = "UNKNOWN";
}

if ($DEBUG) {
	print "hostname: $host >>$opt_H<<\n";
	print "community: $community >>$opt_C<<\n";
	print "port: $port >>$opt_p<<\n";
	print "timeout: $timeout >>$opt_t<<\n";
	print "alert: $alert >>$opt_a<<\n";
}

#--------------------------------------------------#
# open the snmp connection and fetch the data
if ($DEBUG) {
	print "host = $host\n";
	print "community = $community\n\n";
}

# set the timeout
$SIG{'ALRM'} = sub {
	$output_str = "megaraid UNKNOWN - snmp query timed out\n";
	print $output_str;
	if(defined($session)) {
		$session->close;
	}
	exit $ERRORS{"UNKNOWN"};
};
alarm($timeout);

# open the snmp connection
($session, $error) = Net::SNMP->session(
	-hostname  => $host,
	-community => $community,
	-port      => $port,
	-version   => 'snmpv2c'
);

if (!defined($session)) {
	$output_str = "megaraid UNKNOWN - no data received\n";
	if ($DEBUG) {
		print("snmp connection error: %s.\n", $error);
	}
	print $output_str;
	exit $ERRORS{"UNKNOWN"};
}

# fetch snmp data
$logdrv_data_in = $session->get_table(-baseoid => $logdrv_oid);
$phydrv_data_in = $session->get_table(-baseoid => $phydrv_oid);

if (!($logdrv_data_in) || !($phydrv_data_in)) {
	$output_str = "megaraid UNKNOWN - no data received\n";
	if ($DEBUG) {
		printf("snmp error: %s\n", $session->error());
	}
	print $output_str;
	if(defined($session)) {
		$session->close;
	}
	exit $ERRORS{'UNKNOWN'};
}

# close the snmp connection
$session->close;

#--------------------------------------------------#
# parse the data and determine status

# set the initial output string and ok status
$output_str = "";
$ok = 1;

# logical drive status
foreach $line (oid_lex_sort(keys(%{$logdrv_data_in}))) {
	if ($DEBUG) {
		print "line = $line\t";
	}

	# parse the input line
	$code = $logdrv_data_in->{$line};
	
	$line = substr($line,length($logdrv_oid)+1);
	($foo,$logdrv_id) = split(/\./,$line,2);
	if ($DEBUG) {
		print "logdrv_id = $logdrv_id, code = $code\n";
	}

	# check status (catch if status is not "optimal" (2))
	if ($code != 2) {
		if ($output_str !~ m/megaraid/) {
			$output_str .= "megaraid $alert - ";
		}
		if (!$ok) {
			$output_str .= ", ";
		}
		$output_str .= "log drv($logdrv_id) $LOGDRV_CODES{$code}";
		$ok = 0;
	}
}

# physical drive states
foreach $line (oid_lex_sort(keys(%{$phydrv_data_in}))) {
	if ($DEBUG) {
		print "line = $line\n";
	}

	# parse the input line
	$code = $phydrv_data_in->{$line};
	$line = substr($line,length($phydrv_oid)+1);
	($foo,$foo,$phydrv_id) = split(/\./,$line,3);
	if ($DEBUG) {
		print "phydrv_id = $phydrv_id, code = $code\n";
	}

	# check status (catch if state is either "failed" (4) or "rebuild" (5))
	if (($code == 4) || ($code == 5)) {
		if ($output_str !~ m/megaraid/) {
			$output_str .= "megaraid $alert - ";
		}
		if (!$ok) {
			$output_str .= ", ";
		}
		$output_str .= "phy drv($phydrv_id) $PHYDRV_CODES{$code}";
		$ok = 0;
	}
}

#--------------------------------------------------#
# return status and output string

# check if errors were found
if ($ok == 1) {
	$output_str = "megaraid OK";
	$alert = "OK";
}

# netsaint doesn't like output strings larger than 256 chars
if (length($output_str) > 256) {
	$output_str = substr($output_str,0,256);
}
print "$output_str\n";
exit $ERRORS{"$alert"};

#--------------------------------------------------#
# help flag function
sub help () {
	print_help();
	exit $ERRORS{'UNKNOWN'};
}

#--------------------------------------------------#
# version flag function
sub version () {
	print_version();
	exit $ERRORS{'UNKNOWN'};
}

#--------------------------------------------------#
# display help information
sub print_help() {
        print "Checks logical and physical drive status of a Dell PERC controller.\n";
	print "\n";
        print_usage();
        print "\n";
	print "Options:\n";
	print "  -h, --help\n";
	print "    Display help\n";
	print "  -V, --version\n";
	print "    Display version\n";
        print "  -H, --hostname <host>\n";
	print "    Hostname or IP address of target to check\n";
	print "  -C, --community <community>\n";
	print "    SNMP community string (defaults to \"public\")\n";
	print "  -p, --port <port>\n";
	print "    SNMP port (defaults to 161)\n";
	print "  -t, --timeout <timeout>\n";
	print "    Seconds before timing out (defaults to Netsaint timeout value)\n";
	print "  -a, --alert <alert level>\n";
	print "    Alert status to use if an error condition is found\n";
	print "    Accepted values are: \"crit\" and \"warn\" (defaults to crit)\n";
	print "\n";
}

#--------------------------------------------------#
# display usage information
sub print_usage () {
        print "Usage:\n";
        print "$PROGNAME -H <host> -C <community> [-p <port>] [-t <timeout>]\n";
        print "\t[-a <alert level>]\n";
        print "$PROGNAME --help\n";
        print "$PROGNAME --version\n";
}

#--------------------------------------------------#
# display usage information
sub print_version () {
	print "$PROGNAME version $version\n";
}

