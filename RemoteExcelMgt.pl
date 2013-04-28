#!/usr/bin/env perl

#!/usr/bin/env perl 

=pod

=head1 RemoteExcelMgt.pl

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant Chen (xkdcc@163.com), All Rights Reserved 

=head2 SYNOPSIS

To remote update team's LOC_Machines_List.xls.

=head2 DESCRIPTION

=begin html

<pre>
1. Telnet to remote system, write down modified date/time.
2. Download the specified Excel.
3. Modify it by specified line.
4. Export this Excel file to a html.
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
1. Input File Format:
              [tab name]
              [line 1]
              [col 1]
              Content Content
              [col 2]
              Content Content
              ...
              [tab name]
              [line 1]
              [col 1]
              Content Content
              [col 2]
              Content Content
</pre>  
 </p>  </td> </tr>
</table>

=end html

=head2 AUTHOR

=begin html

<B>Author:</B>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Brant Chen (xkdcc@163.com) </br>
<B>Organization: </B>&nbsp     </br>

=end html

=head2 VERSION_INFOR

=begin html

<B>Version:</B>&nbsp&nbsp 1.0                     </br>
<B>Created:</B>&nbsp&nbsp 2013-4-27 13:17:27 </br>
<B>Revision:</B>&nbsp 1.0                         </br>

=end html

=cut


use strict;
use warnings;
use utf8;
use Net::Telnet;


#------------------------------------------------------------------------------
# CLASS:       RemoteFileAdmin
# METHOD:      
# PARAMETERS:   
# RETURNS:     
# DESCRIPTION: 
# THROWS:      no exceptions
# COMMENTS:    none
# SEE ALSO:    n/a
#------------------------------------------------------------------------------





