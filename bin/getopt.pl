#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  getopt.pl
#
#        USAGE:  ./getopt.pl 
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
#      CREATED:  10/21/2007 11:34:24 AM CDT
#     REVISION:  ---
#===============================================================================
=head1 NAME

spyspacelx

=head1 SYNOPSIS

=item USAGE
 spyspacelx [-f] [-m method] [-d <debug level>] [-l <log level>] [ -c <file>]  
			[-m <email address>] 


=head1 DESCRIPTION


spyspacelx is a disk space monitoring and reporting daemon. It figures out what mountpoints the system has configured and keeps an eye on them for use. Based on the configuration file, spyspacelx watches for "W" warning or "C" critical usage levels and will act accordingly. 

spyspacelx accepts the following options:

=over 4

=item -f

Stay in the foreground. Do not fork()

=item -d <level>

Enable debugging. Additional diagnostic output will be printed to the logfiles in C</var/log/spyux/>. A higher number will mean more output.

=item -l <level>

Enable logging. A higher level will mean more output in the logs as above.

=item -c <file>

Specify an alternate configuration file. *note: more code will be added later on for proper config file parsing.

=item -m <email>

Specify an email address in which to send the "W" warning messages to, if configured for the mountpoint.

item -v

Print the version information and exit.

item -h

Print usage message and quit.

=head1 LICENSE


This is released under the Artistic License See L<perlartistic>.


=head1 AUTHOR

Ben Lutgens - L<blutgens@mmm.com>

=head1 SEE ALSO

C</etc/spyspacelx.conf>, C</etc/defaults/spyspace>


=cut
use strict;
use warnings;
use Getopt::Std qw(getopts);
use Smart::Comments;
use Data::Dump qw(dump);

my $VERSION = sprintf("%d.%02d", q$Revision: 1.0 $ =~ /(\d+)\.(\d+)/);
our %opts = ( );
$Getopt::Std::STANDARD_HELP_VERSION = "true";
getopts('vhldfm:c:', \%opts);
our($logging, $debug, $nofork, $adminemail, $configfile);

### if \$opts -- $opts
if (defined($opts{v})) { ### Checking for -v
	die <<"EOT";
This is spyspacelx version $VERSION
EOT
} elsif (defined($opts{h})) { ### Checking for -h
	usage(); 
}

	
$logging 	= $opts{l} 	if ($opts{l});
$debug		= $opts{d} 	if ($opts{d});
$nofork		= $opts{f}	if ($opts{f});
$adminemail	= $opts{m} 	if ($opts{m});
$configfile	= $opts{c} 	if ($opts{f});

sub usage
{ 
	die <<"EOT"; 
Usage: spyspacelx [-options] ...
	-f				Stay in foreground, don't fork()
	-l <level>		Enable logging
	-m <address>	Specify an email address to send warnings to
	-d <level>		Enable debugging
	-c <file>		Specify a configuration file other than the default
	-v 				Show verion info an exit
	-h 				This message
EOT
}
