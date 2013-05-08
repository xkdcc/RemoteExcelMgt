#!/usr/bin/env perl

=pod

=head1 RemoteExcelMgt.pl

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant Chen (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

Update team's ml.xls on ftp server remotely.

=head2 DESCRIPTION

=begin html

<pre>
1. FTP to remote system, write down modified date/time.
2. Download the specified Excel.
3. Modify it by specified line.
4. Export this Excel file to a local html copy.
5. Check remote Excel file's modfied date/time:
   <1> If remote one's time is older, update local copy (Excel
       and html) to overwrite the remote ones.
   <2> If remote one's time is newer, give warning and choice.
</pre>

=head2 USAGE        

=begin html

<pre>
USAGE:        ~ -re <Excel file remote path>  -t <sheet name> -n <line number, line number, ...> -o [output file]
              ~ -le <local Excel file path>   -i [input file]
              ~ -u -u1 <Excel file remote path> -u2 <Html file remote path>
  
OPTIONS:      -o: Output the specified line by only two cols to output txt file.
              -i: Update the input file to the local Excle file by specified line;
                  then generate html of this Excel file.
              -u: Sync up local html and Excle file to remote.
</pre>

=end html

=head2 REQUIREMENTS

N/A

=head2 BUGS

=begin html

<B>N/A</B>

=end html

=head2 NOTES

=begin html

<table border=0>
 <tr>  <td width=626 valign=top style='width:469.8pt;border:solid #FFD966 1.0pt;background:#FFF2CC;'>   <p>
<pre>  
Notes here.
</pre>  
 </p>  </td> </tr>
</table>

=end html

=head2 AUTHOR

=begin html

<B>Author:</B>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Brant Chen (xkdcc@163.com) </br>
<B>Organization: </B>&nbsp     </br>

=end html

=head2 SEE ALSO



=head2 VERSION_INFOR

=begin html

<B>Version:</B>&nbsp&nbsp 1.0                     </br>
<B>Created:</B>&nbsp&nbsp 2013-4-27 13:17:27 </br>
<B>Revision:</B>&nbsp 1.0                         </br>

=end html

=head2 Comments in Code

=cut

# TODO: [Brant][2013-5-4 21:03:07]
# 1. Need perl test
# 2. Need exception catch
# 3. Need well-structured log mechanism
#

use strict;
use warnings;
use utf8;
use Carp;
use Net::FTP;

=head3 A proper way of using Perl custom modules inside of other Perl modules

=begin html

<p>
Refer to <a href=http://stackoverflow.com/questions/11687018/a-proper-way-of-using-perl-custom-modules-inside-of-other-perl-modules>here</href>.
</p>

=end html

=cut

use FindBin qw( $RealBin );
use lib "$RealBin/Package";

use BC_NetworkAdmin;
use BC_ExcelAdmin;
use BC_Constant;

BEGIN {

}

my $na = BC_NetworkAdmin->new(
  "ftpsrv"   => "10.200.108.10",
  "username" => "ss",
  "password" => "ss",
);

#$na->target_path("/ml.xls");
#$na->Download();

my $local_excel = BC_ExcelAdmin->new( "target_excel_name" => "./ml.xls" );
$local_excel->list_sheet_names();

#$local_excel->range();
#$local_excel->range(4, "r_-1", "r_-1", "c_2", "c_6");
$local_excel->range( 0, "c_0", "c_3", "r_10", "r_5" );
$local_excel->display_sheet( BC_Constant->Excel_Format_Default );

#$local_excel->range(4, "r_2", "r_6", "c_3", "c_6");
#$local_excel->range(0, 1, 2, 3, 6);

END {

}

=begin html

</br>
</br>

=end html



