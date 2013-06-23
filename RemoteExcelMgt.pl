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
Q1: Why we seperate "Download files by FTP" and "Upload files to FTP" to two menu items?
A1: Because this script is used to download Excel files at first, then you make your modifications locally, then
upload your local modified copy to overwrite the ones on FTP servers. So we don't have need to bundle "Downlaod" 
and "upload" in a menu item. 
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
# 1. Need perl test module.
# 2. Need well-structured log mechanism
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
use lib "$RealBin/lib/";

use BC_NetworkAdmin;
use BC_ExcelAdmin;
use BC_Term_Menus;
use BC_Constant;

BEGIN {

}

my $ret    = 0;
my $na_ftp = BC_NetworkAdmin->new();

print "\n\n";

my @main_menu = (
  "Download files by FTP",
  "Upload files to FTP",
  "Operations on local excel file",
  "Quit"
);
my $bc_tm = BC_Term_Menus->new(
  banner => "\n\nWelcome to use RemoteExcel.pl written by Brant Chen.\n\n\n\n",
  menu_list       => \@main_menu,
  multi_menu_item => 1,              # 0 means single_menu_item need input.
  prt_control     => {
    banner           => 1,
    ask_hint_text    => 1,
    echo_choice_text => 1,
    no_option_text   => 1,
    clear_screen     => 1,
  }
);

while (1) {

  my $ans = $bc_tm->menu();

  if ( $ans == 1 ) {    # Download
    $na_ftp->check_established_session_and_ask_continue();

    while (1) {
      do {
        print
"Target File path that you want to download (Type quit to exit or back to up menu): ";
        chomp( $ans = <STDIN> );
        exit 0 if $ans eq "quit";
        last   if $ans eq "back";
        print "[WAR] Your answer is empty. Please try again.\n\n"
          if ( $ans eq "" );
      } while ( $ans eq "" );

      $na_ftp->target_path($ans);
      $ret = $na_ftp->Download();
      if ( $ret == 1 ) {
        print "[ERR] Get [" . $na_ftp->target_path . "] failed.\n";
        print "      Please try again.\n\n";
        next;
      }
      print "[INF] Good, download ["
        . $na_ftp->target_path
        . "] to ["
        . $RealBin
        . "] successfully.\n";

      $bc_tm->prt_control->{clear_screen} = 0;
      $bc_tm->prt_control->{banner}       = 0;
      print "Please any key to continue...\n";
      chomp( $ans = <STDIN> );
      last;
    }
    next;
  }
  elsif ( $ans == 2 ) {    # Upload
    $na_ftp->check_established_session_and_ask_continue();
    while (1) {
      do {
        print
"Target folder that you want to upload (Type quit to exit or back to up menu): ";
        chomp( $ans = <STDIN> );
        exit 0 if $ans eq "quit";
        last   if $ans eq "back";
        print "[WAR] Your answer is empty. Please try again.\n\n"
          if ( $ans eq "" );
      } while ( $ans eq "" );
      $na_ftp->target_folder($ans);

      while (1) {
        print
"Local file path that you want to upload (Type quit to exit or back to up menu): ";
        chomp( $ans = <STDIN> );
        exit 0 if $ans eq "quit";
        last   if $ans eq "back";

        # Check relative path and absolute path.
        if ( !-e $ans && !-e $RealBin . "/" . $ans ) {
          print "[ERR] File [" . $ans . "] not exist.\n";
          next;
        }
        $na_ftp->local_files($ans);
        last;
      }

      $ret = $na_ftp->Upload();
      if ( $ret == 1 ) {
        print "[ERR] Upload ["
          . $na_ftp->local_files
          . "] to ["
          . $na_ftp->target_folder
          . "] failed.\n";
        print "      Please try again.\n\n";
        next;
      }
      print "[INF] Good, upload ["
        . $na_ftp->local_files
        . "] to ["
        . $na_ftp->target_folder
        . "] successfully.\n";

      $bc_tm->prt_control->{clear_screen} = 0;
      $bc_tm->prt_control->{banner}       = 0;
      print "Please any key to continue...\n";
      chomp( $ans = <STDIN> );
      last;
    }
    next;
  }
  elsif ( $ans == 3 ) {    # Operations
    # Draft function Design:
    # Get Excel file path and check exist    
    # 
    # Then Excel operations menu 
    # 1. Print all sheet names in the file
    #    Sub menu:
    #    1) Type <back to back up 
    #    2) Type index to print sheet and set focus to selected sheet
    #       common used sub menu: 
    #       1) Type <back1 to back up previous menu
    #       2) Type <back2 to back up Excel operations menu
    #       3) quickly define a area with specifying sheet name and save it to configuration file.
    #          Refer to menu 5.
    #          no sub, return to this menu
    #       4) modify specified cells and save it
    #          no sub, return to this menu
    #    3) modify specified cells and save it.  
    # 2. Print sheet with specified sheet name and set focus to selected sheet
    #    Go to common used sub menu.
    # 3. Print sheet with specified sheet index
    #    Go to common used sub menu.
    # 4. Read configuration file and print area references you defined if available.
    # 5. Define area for quick ref and print if you know sheet name and accurate range you want.
    #    For example, you define a area: ip_list (r_1, r_5, c_3, c_4) 
    #    Then it will save this conf to file for later reference even you exit RemoteExcelMgt.pl and use it again.
    #    And this ref would be list on the Excel operations menu 
    #    The format to define a area could be: 
    #      area_name (sheet_index)
    #      area_name (sheet_index, r_start_number) -- start from row r, all columns
    #      area_name (sheet_index, c_start_number) -- start from col c, all rows
    #      area_name (sheet_index, r_start_number, c_start_number) -- start from row r and col c, all left
    #      area_name (sheet_index, r_start_number, r_end_number) -- all col between r_start_number and r_end_number
    #      area_name (sheet_index, c_start_number, c_end_number) -- all row between c_start_number and c_end_number
    #      area_name(sheet_index, r_start_number, r_end_number, c_start_number, c_end_number) 
    # 6. Modify specified cells directly if you know sheet name and accurate range you want..
    #    Refer to menu 5.
    # 7. List impacted you-defined areas that you have done modifications in this session.
    # 8. Give a compare view that list previous content and current content with section number.
    #    If use want to change some places, he just need type section number and do a quick update and save.
    #    Then back up to previous menu.
    # 9. Back up to previous menu.
    

  }
  elsif ( $ans == 4 ) {    # Operations
    print "Goodbye.\n";
    exit 0;
  }

  last;
}

END {

}

=begin html

</br>
</br>

=end html



