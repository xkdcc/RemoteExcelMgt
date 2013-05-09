#!/usr/bin/env perl

=pod

=head1 RemoteExcelMgt.pl

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant Chen (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

Update team's ml.xls on ftp server remotely.

=head2 DESCRIPTION

=begin html

1. FTP to remote system, write down modified date/time.</br>
2. Download the specified Excel.</br>
3. Modify it by specified line.</br>
4. Export this Excel file to a local html copy.</br>
5. Check remote Excel file's modfied date/time:</br>
   <1> If remote one's time is older, update local copy (Excel
       and html) to overwrite the remote ones.</br>
   <2> If remote one's time is newer, give warning and choice.</br>

=end html

=head2 USAGE        

=begin html

<pre>

This perl script will provide a CMD MENU.

</pre>

=end html

=head2 REQUIREMENTS

Need Spreadsheet::ParseExcel, Spreadsheet::WriteExcel

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


$local_excel->range( 0, "c_0", "c_8", "r_2", "r_5" );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Default );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_No_Header_But_With_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_But_No_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_And_Index );
$local_excel->sheet_header(0);
$local_excel->sheet_header(1);
$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);


END {

}

=begin html

</br>
</br>

=end html



