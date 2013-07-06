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
use Cwd 'abs_path';

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
  "Quit",
  "Download files by FTP",
  "Upload files to FTP",
  "Operations on local excel file"
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

my @excel_menu = (
  "Quit",
  "Go back",
  "Print all sheet names in this file",
  ""
);
my $bc_tm_excel = BC_Term_Menus->new(
  banner => "",
  menu_list       => \@excel_menu,
  multi_menu_item => 1,              # 0 means single_menu_item need input.
  prt_control     => {
    banner           => 1,
    ask_hint_text    => 1,
    echo_choice_text => 1,
    no_option_text   => 1,
    clear_screen     => 0,
  }
);

while (1) {

  my $ans = $bc_tm->menu();

  
  if ( $ans == 1 ) {    # Exit
    print "Goodbye.\n";
    exit 0;
  }
  elsif ( $ans == 2 ) {    # Download
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
  elsif ( $ans == 3 ) {    # Upload
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
  elsif ( $ans == 4 ) {    # Excel Operations
    # Draft function Design:
    # Get Excel file path and check exist    
    # 
    # Then Excel operations menu 
    # 1. Exit
    # 2. Go back.
    # 3. Print All Sheet Names In The File
    #    Sub Menu:
    #    1) Type <back To Back Up 
    #    2) Type Index To Print Sheet And Set Focus To Selected Sheet
    #       Common Used Sub Menu: 
    #       1) Type <back1 To Back Up Previous Menu
    #       2) Type <back2 To Back Up Excel Operations Menu
    #       3) Quickly Define A Area With Specifying Sheet Name And Save It To Configuration File.
    #          Refer To Menu 5.
    #          No Sub, Return To This Menu
    #       4) Modify Specified Cells And Save It
    #          No Sub, Return To This Menu
    #    3) Modify Specified Cells And Save It.  
    # 4. Print Sheet With Specified Sheet Name And Set Focus To Selected Sheet
    #    Go To Common Used Sub Menu.
    # 5. Print Sheet With Specified Sheet Index
    #    Go To Common Used Sub Menu.
    # 6. Read Configuration File And Print Area References You Defined If Available.
    # 7. Define Area For Quick Ref And Print If You Know Sheet Name And Accurate Range You Want.
    #    For Example, You Define A Area: Ip_list (r_1, R_5, C_3, C_4) 
    #    Then It Will Save This Conf To File For Later Reference Even You Exit RemoteExcelMgt.pl And Use It Again.
    #    And This Ref Would Be List On The Excel Operations Menu 
    #    The Format To Define A Area Could Be: 
    #      Area_name (sheet_index)
    #      Area_name (sheet_index, R_start_number) -- Start From Row R, All Columns
    #      Area_name (sheet_index, C_start_number) -- Start From Col C, All Rows
    #      Area_name (sheet_index, R_start_number, C_start_number) -- Start From Row R And Col C, All Left
    #      Area_name (sheet_index, R_start_number, R_end_number) -- All Col Between R_start_number And R_end_number
    #      Area_name (sheet_index, C_start_number, C_end_number) -- All Row Between C_start_number And C_end_number
    #      Area_name(sheet_index, R_start_number, R_end_number, C_start_number, C_end_number) 
    # 8. Modify Specified Cells Directly If You Know Sheet Name And Accurate Range You Want..
    #    Refer To Menu 5.
    # 9. List Impacted You-defined Areas That You Have Done Modifications In This Session.
    # 10. Give A Compare View That List Previous Content And Current Content With Section Number.
    #    If Use Want To Change Some Places, He Just Need Type Section Number And Do A Quick Update And Save.
    #    Then Back Up To Previous Menu.
  
    
    # Get Excel file path and check exist    
    do {
      print
"Please input your Excle file path (Type quit to exit or back to up menu): ";
      chomp( $ans = <STDIN> );
      exit 0 if $ans eq "quit";
      last   if $ans eq "back";
      print "[WAR] Your answer is empty. Please try again.\n\n"
        if ( $ans eq "" );
      if (! -e $RealBin . "/" . $ans) {
        print "[WAR] The file [$ans] not exists. Please try again.\n\n";
        $ans=""; 
      }
    } while ( $ans eq "" );          
    
    $bc_tm_excel->banner("\n\nYou are working on [" . abs_path($ans) . "]\n\n");
    $bc_tm_excel->prt_control->{banner}=1;
    my $ans = $bc_tm_excel->menu();
    
    # Excel menu
    while (1) {
      if ($ans==1) {
        print "Goodbye.\n";
        exit 0;
      }
      elsif ($ans==2) {
        last; # Go back
      }
      elsif ($ans==3) {
        
      }
      elsif ($ans==4) {
        
      }
      elsif ($ans==5) {
        
      }
      elsif ($ans==6) {
        
      }
      elsif ($ans==7) {
        
      }
      elsif ($ans==8) {
        
      }
      elsif ($ans==9) {
        last;
      }
      elsif ($ans==10) {
        
      }
    } # while (1) Excel menu
    next;
  }
  last;
}

END {

}

=begin html

</br>
</br>

=end html



