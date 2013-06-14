#!/usr/bin/env perl

=pod

=head1 bc_netadmin_test01.pl

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant Chen (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

Testing BC_NetAdmin class.

=head2 DESCRIPTION

=head2 USAGE        

perl netadmin_test01.pl

=head2 REQUIREMENTS

Need BC_NetAdmin.pm.

=head2 BUGS

=begin html

<B>N/A</B>

=end html

=head2 AUTHOR

=begin html

<B>Author:</B>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Brant Chen (xkdcc@163.com) </br>
<B>Organization: </B>&nbsp     </br>

=end html

=head2 VERSION_INFOR

=begin html

<B>Version:</B>&nbsp&nbsp 1.0                     </br>
<B>Created:</B>&nbsp&nbsp 2013-5-20 9:54:30 </br>
<B>Revision:</B>&nbsp 1.0                         </br>

=end html

=cut

use strict;
use warnings;
use utf8;
use Carp;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib/";

use BC_NetworkAdmin;
use BC_Constant;

BEGIN {
  chdir $RealBin;
}
my $ret;

#"ftpsrv"   => "10.200.108.10",
my $na = BC_NetworkAdmin->new(
  "ftpsrv"   => "10.200.108.10",
  "username" => "ss",
  "password" => "ss",
);

if ( ref $na ne "BC_NetworkAdmin" ) {
  croak "BC_NetworkAdmin->new failed.\n";
}

$na->target_path("/LOC_Machines_List.xls");
$ret = $na->Download();
if ( $ret != 1 ) {
  print "Download successfully.\n";
}
else {
  print "Download failed.\n";
}

END {

}

