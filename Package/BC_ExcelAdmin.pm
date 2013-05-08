#!/usr/bin/env perl 

=pod

=head1 BC_ExcelAdmin.pm

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

BC_ExcelAdmin.pm.

=head2 DESCRIPTION

Encapsulate Excel file operations for my purpose.

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
  For class implementation for Perl, I learnt a lot from http://www.perl.org/books/beginning-perl/ Chapter 11.
  1. BC_ExcelAdmin.pm is a Class Package.
  2. Object Methods:
     list_sheet_names
     display_sheet
  3. Class attributes:
     bc_math (BC_Math class)
  4. Object attributes:
     parser             (Spreadsheet::ParseExcel::SaveParser->new())
     workbook_orig      (Spreadsheet::ParseExcel::SaveParser->new()->Parse("Your Excel File"))
     target_excel_name  (Excel file name)
     range              (Complex data structure, please find more in code)
  5. Private methods:
     _init
     _format_default    (Used by display_sheet)
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
<B>Created:</B>&nbsp&nbsp&nbsp2013-4-28 15:33:16 </br>
<B>Revision:</B>&nbsp 1.0                      </br>

=end html

=head2 Comments in Code

=head3 Array of hash and Hash of Array

About Array of hash and Hash of Array, I gained a lot from "Programming Perl" 3rd edition by Larry Wall, Tom Christiansen and Jon Orwant
Recommondation.
You can find it online at http://docstore.mik.ua/orelly/perl3/prog/index.htm

=head3 To find a better way to exchange arrays

Please refer to my post at http://bbs.chinaunix.net/thread-4080028-1-1.html.

=head3 How to print Chinese to terminal

A good article can be referred at http://www.jb51.net/article/16041.htm.

=cut

package BC_ExcelAdmin;

use strict;
use warnings;
use utf8;
use Switch;
use Carp;
use Encode;
use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::SaveParser; # Useful when you want to modify Excel.

use FindBin qw( $RealBin );
use lib "$RealBin/Package";

use BC_Math;
use BC_Constant;

# Class Attributes
my $bc_math;

sub new {
  my ($class_name) = shift;

  my $self = {@_};
  bless( $self, $class_name );
  $self->_init();
  $bc_math = BC_Math->new();

  return $self;
}

sub _init {
  my $self = shift;
  $self->parser( Spreadsheet::ParseExcel::SaveParser->new() );
  $self->workbook_orig( $self->parser->Parse( $self->target_excel_name() ) );

  return 0;
}

sub parser {
  my $self = shift;
  unless ( ref $self ) {
    croak "Should call parser with an object, not a class.";
  }

  # Receive more data
  my $data = shift;

  # Set the target_path if there's any data there.
  $self->{parser} = $data if defined $data;

  return $self->{parser};
}

sub workbook_orig {
  my $self = shift;
  unless ( ref $self ) {
    croak "Should call workbook_orig with an object, not a class.";
  }

  # Receive more data
  my $data = shift;

  # Set the target_path if there's any data there.
  $self->{workbook_orig} = $data if defined $data;

  return $self->{workbook_orig};
}

sub target_excel_name {
  my $self = shift;
  unless ( ref $self ) {
    croak "Should call target_excel_name with an object, not a class.";
  }

  # Receive more data
  my $data = shift;

  # Set the target_path if there's any data there.
  $self->{target_excel_name} = $data if defined $data;

  return $self->{target_excel_name};
}

# Range should be array
# Didn't recommend to set range as all worksheets, it cost too much time and memory
# Usage:
# range(sheet_index, r_start_number, r_end_number)
# range(sheet_index, c_start_number, c_end_number)
# range(sheet_index, r_start_number, r_end_number, c_start_number, c_end_number)
# or
# range(sheet_index, c_start_number, c_end_number, r_start_number, r_end_number)
sub range {
  my $self = shift;
  unless ( ref $self ) {
    croak "Should call target_excel_name with an object, not a class.";
  }

  return $self->{range} if defined $self->{range};
  
  # Hash array
  # %range = ("row_range" => [row_min, row_max],
  #           "col_range" => [col_min, col_max],
  #           "row_number" => cell_object,
  #           "row_number" => cell_object,
  #           ...
  #          )
  # Add more array:
  # %range{new_array} = [asdf, asdf]
  # or
  # %range{new_array} = [@array]
  # So if we want to print range in order, we must sort it in advance!

  my %my_range = (
    row_range => [ 0, 0 ],
    col_range => [ 0, 0 ],
  );

  my $sheet_index     = shift;
  my @given_row_range = ( shift, shift );
  my @given_col_range = ( shift, shift );

  my $ws_count = $self->workbook_orig()->worksheet_count();
  # Check index
  if ( $sheet_index < 0
    || ($sheet_index > $ws_count - 1) )
  {
    croak "Your worksheet index["
      . $sheet_index
      . "] out of range [0 ~ "
      . ($ws_count - 1). "].\n";
  }

  my $ws = $self->workbook_orig()->worksheet($sheet_index);

  my @target_row_range = $ws->row_range();
  my @target_col_range = $ws->col_range();

  print "get:" . "@target_row_range\n";
  print "get:" . "@target_col_range\n";
  print "get:" . "@given_row_range\n";
  print "get:" . "@given_col_range\n";

  # Fix @given_row_rang and @given_col_range
  if ( $given_col_range[0] =~ /^r_/
    && $given_col_range[1] =~ /^r_/
    && $given_row_range[0] =~ /^c_/
    && $given_row_range[1] =~ /^c_/ )
  {
    my @temp = ();
    @temp            = @given_row_range;
    @given_row_range = @given_col_range;
    @given_col_range = @temp;
  }

  print "fixed:" . "@given_row_range\n";
  print "fixed:" . "@given_col_range\n";

  # Strip prefix
  $given_row_range[0] =~ s/r_//g;
  $given_row_range[1] =~ s/r_//g;
  $given_col_range[0] =~ s/c_//g;
  $given_col_range[1] =~ s/c_//g;

  #  print "Striped:" . "@given_row_range\n";
  #  print "Striped:" . "@given_col_range\n";

  BC_ExcelAdmin->get_bc_math()
    ->range_check( \@given_row_range, \@target_row_range );
  BC_ExcelAdmin->get_bc_math()
    ->range_check( \@given_col_range, \@target_col_range );

  $my_range{row_range} = [@given_row_range];
  $my_range{col_range} = [@given_col_range];

  #  print "row range: @{$my_range{row_range}}\n";
  #  print "col range: @{$my_range{col_range}}\n";

  #  for my $ele ( keys %my_range ){
  #        print "xxx $ele: @{ $my_range{$ele} }\n";
  #  }

  # Print by row range as priority
  for my $row ( $given_row_range[0] .. $given_row_range[1] ) {
    my @col_range = ();
    my $i         = 0;

    for my $col ( $given_col_range[0] .. $given_col_range[1] ) {

      my $cell = $ws->get_cell( $row, $col );

      $col_range[ $i++ ] = $cell;

      next unless $cell;

      #print "Row, Col    = ($row, $col)\n";
      #print "Value       = " . encode( 'gb2312', $cell->value() ) . "\n";
    }

    #    for my $href ( @col_range ) {
    #      if (defined $href) {
    #        print "\n{ ";
    #        print "hh value: " . encode( 'gb2312', $href->value()) . "\n" ;
    #        print "hh encoding: " . $href->encoding() . "\n" ;
    #        print "}\n";
    #      }
    #    }

    $my_range{$row} = [@col_range];
  }

  # Set the range now.
  $self->{range} = \%my_range;

#  print "use \%range: {\n";
#  my ($row_start, $col_start) = ($my_range{row_range}[0], $my_range{col_range}[0]);
#  print "r_s, c_s:[" . $row_start . ", " . $col_start . "]\n";
#
#  for my $key ( sort (keys %my_range) ){
#    print "{1 \n";
#    print "ref:" . ref($my_range{$key}) . "\n";
#    if ($key ne "row_range" && $key ne "col_range") {
#      for my $href ( @{ $my_range{$key} } ) {
#        if (defined $href) {
#          print "new ref:" . ref($href) . "\n";
#          if ( ref($href) eq "Spreadsheet::ParseExcel::Cell") {
#            print "key:" . $key . "\n";
#            print "  {2 ";
#            print "[" . $row_start . ", " . $col_start++ . "]" . encode( 'gb2312', $href->value()) . "\n" ;
#            print "   o encoding: " . $href->encoding() . "\n" ;
#            print "   2}\n";
#          }
#        }
#        else {
#          print "[" . $row_start . ", " . $col_start++ . "] NULL \n" ;
#        }
#      }
#    }
#    else{
#      print "$key:@{$my_range{$key}}\n";
#    }
#
#    $row_start++;
#    $col_start = $my_range{col_range}[0];
#
#    print "1}\n";
#  }
#  print "end of use \%range: }\n";

  return $self->{range};
}

# Read-only accessor for Class Attribute $bc_math.
sub get_bc_math {
  return $bc_math;
}

# Utility method
sub list_sheet_names {
  my $self  = shift;
  my $index = 0;

  for my $worksheet ( $self->workbook_orig()->worksheets() ) {
    print "Worksheet name[" . $index++ . "]: " . $worksheet->get_name() . "\n";
  }
  return 0;
}

# Utility method
# Usage:
# display_sheet()
sub display_sheet {
  my $self   = shift;
  my $format = shift;

  switch ($format) {
    case ( BC_Constant->Excel_Format_Default ) {
      $self->_format_default();
    }
    else {
      print "Switch case not true.\n";
    }
  }

  return 0;
}

sub _format_default {
  my $self = shift;
  my ( $row_start, $col_start ) =
    ( $self->range()->{row_range}[0], $self->range()->{col_range}[0] );

  print "row_range:@{$self->range()->{row_range}}\n";
  print "row_start:" . $self->range()->{row_range}[0] . "\n";
  print "col_range:@{$self->range()->{col_range}}\n";
  print "col_start:" . $self->range()->{col_range}[0] . "\n";

  for my $key ( sort ( keys %{ $self->range() } ) ) {

    #print "ref:" . ref($self->range()->{$key}) . "\n";
    if ( $key ne "row_range" && $key ne "col_range" ) {
      for my $href ( @{ $self->range()->{$key} } ) {
        if ( defined $href ) {

          #print "new ref:" . ref($href) . "\n";
          if ( ref($href) eq "Spreadsheet::ParseExcel::Cell" ) {

            #            print "key:" . $key . "\n";
            #            print "  {2 ";
            print "["
              . $row_start . ", "
              . $col_start++ . "]"
              . encode( 'gb2312', $href->value() ) . "\n";

            #            print "   o encoding: " . $href->encoding() . "\n" ;
            #            print "   2}\n";
          }
        }
        else {
          print "[" . $row_start . ", " . $col_start++ . "] NULL \n";
        }
      }
    }
    else {
      print "$key:@{$self->range->{$key}}\n";
    }

    $row_start++;
    $col_start = $self->range->{col_range}[0];
  }

  return 0;
}

1;

=begin html

</br>
</br>

=end html

