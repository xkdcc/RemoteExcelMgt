#!/usr/bin/env perl

=pod

=head1 bc_exceladmin_test01.pl

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant Chen (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

Testing BC_ExcelAdmin class.

=head2 DESCRIPTION

=head2 USAGE        

=begin html

<pre>

perl bc_exceladmin_test01.pl

</pre>

=end html

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
<B>Created:</B>&nbsp&nbsp 2013-5-20 9:48:27 </br>
<B>Revision:</B>&nbsp 1.0                         </br>

=end html

=cut

use strict;
use warnings;
use utf8;
use Carp;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib/";

use BC_ExcelAdmin;
use BC_Constant;

BEGIN {
  chdir $RealBin;
}

my $local_excel = BC_ExcelAdmin->new( "target_excel_name" => "./ml.xls" );
$local_excel->list_sheet_names();
$local_excel->range(0);
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Default );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_No_Header_But_With_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_But_No_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_And_Index );
$local_excel->sheet_header(0);
$local_excel->sheet_header(1);
$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);
$local_excel->range( 0, "r_5" );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Default );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_No_Header_But_With_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_But_No_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_And_Index );
$local_excel->sheet_header(0);
$local_excel->sheet_header(1);
$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);
$local_excel->range( 0, "r_5" );
$local_excel->range( 0, "c_3" );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Default );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_No_Header_But_With_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_But_No_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_And_Index );
$local_excel->sheet_header(0);
$local_excel->sheet_header(1);
$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);
$local_excel->range( 0, "c_1", "c_8" );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Default );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_No_Header_But_With_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_But_No_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_And_Index );
$local_excel->sheet_header(0);
$local_excel->sheet_header(1);
$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);
$local_excel->range( 0, "r_2", "r_5" );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Default );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_No_Header_But_With_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_But_No_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_And_Index );
$local_excel->sheet_header(0);
$local_excel->sheet_header(1);
$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);
$local_excel->range( 0, "r_2", "c_3" );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Default );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_No_Header_But_With_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_But_No_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_And_Index );
$local_excel->sheet_header(0);
$local_excel->sheet_header(1);
$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);
$local_excel->range( 0, "c_2", "r_3" );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Default );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_No_Header_But_With_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_But_No_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_And_Index );
$local_excel->sheet_header(0);
$local_excel->sheet_header(1);
$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);
$local_excel->range( 0, "r_3", "r_6", "c_2", "c_8" );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Default );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_No_Header_But_With_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_But_No_Index );
$local_excel->display_sheet( 0, BC_Constant->Excel_Format_Table_With_Header_And_Index );
$local_excel->sheet_header(0);
$local_excel->sheet_header(1);
$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);
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

$local_excel->display_sheet_header(0);
$local_excel->display_sheet_header(1);


END {

}


