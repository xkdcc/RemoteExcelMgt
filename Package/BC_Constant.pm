package BC_Constant; 

=pod

=head1 BC_Constant.pm

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

BC_Constant.pm.

=head2 DESCRIPTION

Define my constants.

=head2 USAGE        

=begin html

<pre>

</pre>

=end html

=head2 REQUIREMENTS

N/A

=head2 BUGS

=begin html

<pre>
Bugs: N/A
</pre>

=end html

=head2 NOTES

=begin html

<table border=0>
 <tr>  <td width=626 valign=top style='width:469.8pt;border:solid #FFD966 1.0pt;background:#FFF2CC;'>   <p> 
 <pre>
  I tried to use Readonly for define constant in Perl. But met a problem which raised by other at
  http://stackoverflow.com/questions/736260/how-do-i-export-readonly-variables-with-mod-perl.
  So I have to give it up.
 </pre>
 </p>  </td> </tr>
</table>

=end html

=head2 AUTHOR

=begin html

<B>Author:</B>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Brant </br>
<B>Organization: </B>&nbsp     </br>

=end html

=head2 VERSION_INFOR

=begin html

<B>Version:</B>&nbsp&nbsp 1.0                  </br>
<B>Created:</B>&nbsp&nbsp 2013-5-7 17:43:11 </br>
<B>Revision:</B>&nbsp 1.0                      </br>

=end html


=head2 Comments in Code

=cut


use strict;
use warnings;
use utf8;
use Carp;
use base 'Exporter';

use constant Excel_Format_Default                        => 0;
use constant Excel_Format_Table                          => 1;
use constant Excel_Format_Table_No_Header_But_With_Index => 2;
use constant Excel_Format_Table_With_Header_But_No_Index => 3;
use constant Excel_Format_Table_With_Header_And_Index    => 4;

our @EXPORT_OK = qw($Excel_Format_Default
  $Excel_Format_Table
  $Excel_Format_Table_No_Header_But_With_Index
  $Excel_Format_Table_With_Header_But_No_Index
  $Excel_Format_Table_With_Header_And_Index);

1;

=begin html

</br>
</br>

=end html
