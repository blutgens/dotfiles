#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  depot_grab.pl
#
#        USAGE:  ./depot_grab.pl
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
#      CREATED:  Thu, Nov 1, 2007 02:55:35 PM CDT
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use WWW::Mechanize;
use HTML::Parser ();
use YAML qw(Dump);

my $url         = "https://sduxserv/PassDepot/";
my $mmmid 			= "a1b1mzz";
my $passwd 			= "p8yqoxAS";
my @hosts 			= qw(e1msbe01);

useWebForm();

sub useWebForm {
	my $mech        = WWW::Mechanize->new( autocheck => 1);
	my $host =  "bus277c";;

	$mech->get($url);
	$mech->set_visible( $mmmid, $passwd, $host);
	$mech->submit_form(
		form_name => 'gp',
		button => 'gp_Submit'
	);

	my @mech_output = $mech->content();
	&parseMechRefs(@mech_output);
}

sub parseMechRefs {
  	my @ignore_tags = qw(body);
	my $p = HTML::Parser->new( api_version => 3,
							   marked_sections => 1,
								);
	$p->ignore_tags( @ignore_tags );
	$p->parse(shift);
			
}


# vi: set tabstop=4 shiftwidth=4: 
