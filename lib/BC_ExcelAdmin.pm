package BC_ExcelAdmin;

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
  For print data in a table format, I checked:
    http://perldoc.perl.org/perlform.html
    http://search.cpan.org/~darren/Text-TabularDisplay-1.34/TabularDisplay.pm
    http://search.cpan.org/~sharyanto/Data-Format-Pretty-Console-0.24/lib/Data/Format/Pretty/Console.pm
    http://search.cpan.org/~lunatic/Text-ASCIITable-0.20/lib/Text/ASCIITable.pm
    http://search.cpan.org/~shlomif/Text-Table-1.126/lib/Text/Table.pm
    Finally, I chose Text::ASCIITable for my sake.
  
  1. BC_ExcelAdmin.pm is a Class Package.
  2. Object Methods:
     list_sheet_names
     display_sheet
     display_sheet_header
  3. Class attributes:
     bc_math (BC_Math class)
  4. Object attributes:
     parser             (Spreadsheet::ParseExcel::SaveParser->new())
     workbook_orig      (ref as Spreadsheet::ParseExcel::SaveParser::Workbook, Spreadsheet::ParseExcel::SaveParser->new()->Parse("Your Excel File"))
     target_excel_name  (Excel file name)
     range              (Complex data structure, please find more in code)
     sheet_header       (array)     
  5. Private methods:
     _init
     _format_default    (Used by display_sheet)
     _format_table
     _format_table_with_header_but_no_index
     _format_table_no_header_but_with_index
     _format_table_with_header_and_index
     
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
<B>Revision:</B>&nbsp 1.02                      </br>

=end html

=head2 Revision

=begin html

<pre>
Revision: 1.01 (2013-5-8 21:43:47)
Log:
1. Change Perl from 5.8.8 to 5.16.3.1063.
2. Since cpan install Switch under 5.16.3.1063 failed, abandond using switch.
<br>
Revision: 1.02 (2013-5-12 20:48:34)
Log:
1. Refactor the flow in Class attributes subroutine, to be more clear and reasonable.
2. Now we can change range for the same instance.
   Originally, you can't change the range of an instance after you set it.
3. Now range() can provide more calling format, I appended:
   range(sheet_index)
   range(sheet_index, r_start_number) -- start from row r, all columns
   range(sheet_index, c_start_number) -- start from col c, all rows
   range(sheet_index, r_start_number, c_start_number) -- start from row r and col c, all left
4. Fix bug:
   I forgot to check $href in sub:
   _format_table
   _format_table_with_header_and_index
   _format_table_with_header_but_no_index
</pre>

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

use strict;
use warnings;
use utf8;
use Carp;
use Encode;
use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::SaveParser; # Useful when you want to modify Excel.
use Text::ASCIITable;

use FindBin qw( $RealBin );
use lib "$RealBin/lib";

use BC_Math;
use BC_Constant;

# Class Attributes
my $bc_math;

sub new {
  my ($class_name) = shift;

  my $self = {@_};

  croak "You must provide target_excel_name when you want to new a BC_ExcelAdmin instance.\n"
    unless defined $self->{target_excel_name};

  bless( $self, $class_name );
  $self->_init();
  $bc_math = BC_Math->new();

  return $self;
}

sub _init {
  my $self = shift;
  $self->parser( Spreadsheet::ParseExcel::SaveParser->new() );
  $self->workbook_orig( $self->parser->Parse( $self->target_excel_name ) );

  return 0;
}

sub parser {
  my $self = shift;
  unless ( ref $self eq "BC_ExcelAdmin" ) {
    croak "Should call parser with an object, not a class.";
  }

  # Receive more data
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;

    # Need set hash for $self
    # Here we don't need care whether defined $data
    return $self->{parser} = $data;
  }
  elsif ( defined $self->{parser} ) {
    return $self->{parser};
  }
  else {
    return undef;
  }
}

sub workbook_orig {
  my $self = shift;
  unless ( ref $self eq "BC_ExcelAdmin" ) {
    croak "Should call workbook_orig with an object, not a class.";
  }

  # Receive more data
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{workbook_orig} = $data;
  }
  elsif ( defined $self->{workbook_orig} ) {
    return $self->{workbook_orig};
  }
  else {
    return undef;
  }
}

sub target_excel_name {
  my $self = shift;
  unless ( ref $self eq "BC_ExcelAdmin" ) {
    croak "Should call target_excel_name with an object, not a class.";
  }

  # Receive more data
  my $data = shift;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{target_excel_name} = $data;
  }
  elsif ( defined $self->{target_excel_name} ) {
    return $self->{target_excel_name};
  }
  else {
    return undef;
  }
}

# sheet_header is an array
# it starts from cell(0,0) to cell(0, col_max)
sub sheet_header {
  my $self = shift;
  unless ( ref $self eq "BC_ExcelAdmin" ) {
    croak "Should call sheet_header with an object, not a class.";
  }

  #return $self->{sheet_header} if defined $self->{sheet_header};

  my @sheet_header = ();

  my $sheet_index = shift;

  if ( defined $sheet_index ) {
    my $ws_count = $self->workbook_orig()->worksheet_count();

    # Check index
    if ( $sheet_index < 0
      || ( $sheet_index > $ws_count - 1 ) )
    {
      croak "Your worksheet index["
        . $sheet_index
        . "] out of range [0 ~ "
        . ( $ws_count - 1 ) . "].\n";
    }

    my $ws               = $self->workbook_orig()->worksheet($sheet_index);
    my @target_col_range = $ws->col_range();
    my $i                = 0;

    for my $col ( $target_col_range[0] .. $target_col_range[1] ) {
      my $cell = $ws->get_cell( 0, $col );
      if ( defined $cell ) {
        $sheet_header[ $i++ ] = $cell->value();
      }
      else {
        $sheet_header[ $i++ ] = "No Header";
        next;
      }
    }
    print "col_header:@sheet_header\n";
    print "col_count:" . @sheet_header . "\n";
  }
  else {
    croak "Should set range in advance or give a sheet index.\n";
  }
  $self->{sheet_header} = \@sheet_header;

  return $self->{sheet_header};
}

# Range should be array
# Didn't recommend to set range as all worksheets, it cost too much time and memory
# Usage:
# range(sheet_index)
# range(sheet_index, r_start_number) -- start from row r, all columns
# range(sheet_index, c_start_number) -- start from col c, all rows
# range(sheet_index, r_start_number, c_start_number) -- start from row r and col c, all left
# range(sheet_index, r_start_number, r_end_number)
# range(sheet_index, c_start_number, c_end_number)
# range(sheet_index, r_start_number, r_end_number, c_start_number, c_end_number)
# or
# range(sheet_index, c_start_number, c_end_number, r_start_number, r_end_number)
sub range {
  my $self = shift;
  unless ( ref $self eq "BC_ExcelAdmin" ) {
    croak "Should call range with an object, not a class.";
  }

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

  my $sheet_index;
  my ( @given_row_range, @given_col_range ) = ();
  my $ws_count = $self->workbook_orig()->worksheet_count();
  
  if ( scalar(@_) == 0 && ref $self->{range} ) {
    return $self->{range};
  }
  elsif ( scalar(@_) == 0 && !ref $self->{range} ) {
    croak "You must set range(with sheet_index) before you use it!\n";
  }

  if ( scalar(@_) >= 1 ) {
    $sheet_index = shift;
  }
  else {
    croak "Bad parameters you used! @_\n";
  }

  # Check index
  if ( $sheet_index < 0
    || ( $sheet_index > $ws_count - 1 ) )
  {
    croak "Your worksheet index["
      . $sheet_index
      . "] out of range [0 ~ "
      . ( $ws_count - 1 ) . "].\n";
  }

  # Initiate $sheet_header
  $self->sheet_header($sheet_index);

  my $ws               = $self->workbook_orig()->worksheet($sheet_index);
  my @target_row_range = $ws->row_range();
  my @target_col_range = $ws->col_range();

#  print "get target row:" . "@target_row_range\n";
#  print "get target col:" . "@target_col_range\n";
  
  if (scalar(@_) == 0 ) {
    @given_row_range = @target_row_range;
    @given_col_range = @target_col_range;    
  }
  elsif ( scalar(@_) == 1 ) {
    if ( $_[0] =~ /^r_/ ) {
      @given_row_range = ( shift, $target_row_range[1] );
      @given_col_range = @target_col_range;
    }
    elsif ( $_[0] =~ /^c_/ ) {
      @given_row_range = @target_row_range;
      @given_col_range = ( shift, $target_col_range[1] );
    }
    else {
      croak "Bad parameters you used! @_\n";
    }
  }
  elsif ( scalar(@_) == 2 ) {
    if ( $_[0] =~ /^r_/ && $_[1] =~ /^r_/ ) {
      @given_row_range = ( shift, shift );
      @given_col_range = @target_col_range;
    }
    elsif ( $_[0] =~ /^c_/ && $_[1] =~ /c_/ ) {
      @given_row_range = @target_row_range;
      @given_col_range = ( shift, shift );
    }
    elsif ( $_[0] =~ /^r_/ && $_[1] =~ /c_/ ) {
      @given_row_range = ( shift, $target_row_range[1] );
      @given_col_range = ( shift, $target_col_range[1] );
    }
    elsif ( $_[0] =~ /^c_/ && $_[1] =~ /r_/ ) {
      @given_col_range = ( shift, $target_col_range[1] );
      @given_row_range = ( shift, $target_row_range[1] );
    }
    else {
      croak "Bad parameters format you used! @_\n";
    }
  }
  elsif ( scalar(@_) == 4 ) {
    if ( $_[0] =~ /^r_/ && $_[1] =~ /^r_/ && $_[2] =~ /^c_/ && $_[3] =~ /c_/ ) {
      @given_row_range = ( shift, shift );
      @given_col_range = ( shift, shift );
    }
    elsif ( $_[0] =~ /^c_/
      && $_[1] =~ /^c_/
      && $_[2] =~ /^r_/
      && $_[3] =~ /r_/ )
    {
      @given_col_range = ( shift, shift );
      @given_row_range = ( shift, shift );
    }
    else {
      croak "Bad parameters format you used! @_\n";
    }
  }
  else {
    croak "Bad parameters you used! @_\n";
  }

#  print "get 1:" . "@given_row_range\n";
#  print "get 1:" . "@given_col_range\n";

  # Strip prefix
  if ( $given_row_range[0] =~ /^r_/g ) {
    $given_row_range[0] =~ s/^r_//g;
  }
  if ( $given_row_range[1] =~ /^r_/g ) {
    $given_row_range[1] =~ s/^r_//g;
  }
  if ( $given_col_range[0] =~ /^c_/g ) {
    $given_col_range[0] =~ s/^c_//g;
  }
  if ( $given_col_range[1] =~ /^c_/g ) {
    $given_col_range[1] =~ s/^c_//g;
  }
#  print "Striped:" . "@given_row_range\n";
#  print "Striped:" . "@given_col_range\n";

  BC_ExcelAdmin->get_bc_math()
    ->range_check( \@given_row_range, \@target_row_range );
  BC_ExcelAdmin->get_bc_math()
    ->range_check( \@given_col_range, \@target_col_range );

  $my_range{row_range} = [@given_row_range];
  $my_range{col_range} = [@given_col_range];

  print "row range: @{$my_range{row_range}}\n";
  print "col range: @{$my_range{col_range}}\n";

#  for my $ele ( keys %my_range ) {
#    print "xxx $ele: @{ $my_range{$ele} }\n";
#  }
  
  if ( defined $self->{range}
    && @{ $self->{range}->{row_range} } ~~ @given_row_range
    && @{ $self->{range}->{col_range} } ~~ @given_col_range )
  {
    return $self->{range};
  }

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

  for my $worksheet ( $self->workbook_orig->worksheets ) {
    print "Worksheet name[" . $index++ . "]: " . $worksheet->get_name() . "\n";
  }
  return 0;
}

# Since I didn't find Text::ASCIITable has the ability to print header only.
# Either
# my $t    = Text::ASCIITable->new({hide_FirstLine=>1});
# .-------------------------------------------------.
# +--+----+------------+----+----+---------+--+--+--+
# '--+----+------------+----+----+---------+--+--+--'
# or
# my $t    = Text::ASCIITable->new({hide_LastLine=>1});
# or
# my $t    = Text::ASCIITable->new();
# $t->setCols( $self->sheet_header );
# print $t;
# .-------------------------------------------------.
# |  | SE | hostname01 | ip | ip | PE R720 |  |  |  |
# +--+----+------------+----+----+---------+--+--+--+
# '--+----+------------+----+----+---------+--+--+--'
# I have to write it by myself.
# This is what I want:
# ---------------------------------------------------
# |  | SE | hostname01 | ip | ip | PE R720 |  |  |  |
# ---------------------------------------------------
# Oops:
# Later I found that use $t->draw also could eliminate redundant symbols.
# OK, I removed my own implementation now.
#
sub display_sheet_header {
  my $self        = shift;
  my $sheet_index = shift;

  print "display_sheet_header\n";

#  my ( $top_tableline, $bottom_tableline, $col_seperator ) = ( "-", "-", "|" );
#  my $col_count  = @{ $self->sheet_header };
#  my $row_length = 0;

  #  for my $ele ( @{ $self->sheet_header } ) {
  #    my $len = rindex $ele . "\$", "\$";
  #    $row_length += $len + 2;    # 2 is blank spaces for a element
  #  }
  #  $row_length += $col_count + 1;    # Count col seperators.
  #  print "-" x $row_length . "\n";
  #  print "|";
  #  for my $ele ( @{ $self->sheet_header } ) {
  #    print " " . $ele . " |";
  #  }
  #  print "\n";
  #  print "-" x $row_length . "\n";

  my $t = Text::ASCIITable->new();
  $t->setCols( [ "", @{ $self->sheet_header($sheet_index) } ] );
  $t->setOptions( 'drawRowLine', 1 );

  # Like without header
  print $t->draw(
    [ '--', '--', '-', '-' ],
    [ '|',  '|',  '|' ],
    [ '--', '--', '-', '-' ],
    [ ' ',  ' ',  '|' ],
    [ '  ', '  ', ' ', ' ' ],
    [ '  ', '  ', ' ', ' ' ],
  );

  return 0;
}

# Utility method
# Usage:
# display_sheet()
sub display_sheet {
  my $self        = shift;
  my $sheet_index = shift;
  my $format      = shift;

  if ( $format == BC_Constant->Excel_Format_Default ) {
    $self->_format_default();
  }
  elsif ( $format == BC_Constant->Excel_Format_Table ) {
    $self->_format_table();
  }
  elsif ( $format == BC_Constant->Excel_Format_Table_No_Header_But_With_Index )
  {
    $self->_format_table_no_header_but_with_index();
  }
  elsif ( $format == BC_Constant->Excel_Format_Table_With_Header_But_No_Index )
  {
    $self->_format_table_with_header_but_no_index($sheet_index);
  }
  elsif ( $format == BC_Constant->Excel_Format_Table_With_Header_And_Index ) {
    $self->_format_table_with_header_and_index($sheet_index);
  }
  else {
    print "format[" . $format . "] is wrong.\n";
  }

  return 0;
}

sub _format_table_with_header_and_index {
  my $self            = shift;
  my $sheet_index     = shift;
  my $t               = Text::ASCIITable->new();
  my $i               = 0;
  my $j               = 0;
  my @givin_col_range = ();
  my @col_header      = ();
  my @rows            = ();
  my ( $r_start, $c_start, $c_end ) = ( 0, 0, 0 );

  print "_format_table_with_header_and_index \n";

  if ( defined $self->{range} ) {
    $r_start = $self->{range}->{row_range}[0];
    ( $c_start, $c_end ) = @{ $self->{range}->{col_range} };
    print "rs:$r_start, cs:$c_start, ce:$c_end\n";
  }
  else {
    croak "Should set range in advance.\n";
  }

  # If the range include header (row 0), then skip it.
  if ( $self->{range}->{row_range}[0] != 0 ) {
    $t->setCols(
      [
        "",
        map { $_ . " [" . ( $j++ + $c_start ) . "]" }
          @{ $self->sheet_header($sheet_index) }[ $c_start .. $c_end ]
      ]
    );
  }

  for my $key ( sort ( keys %{ $self->range() } ) ) {
    if ( $key ne "row_range" && $key ne "col_range" ) {
      @rows = ();
      for my $href ( @{ $self->range()->{$key} } ) {
        if ( $i == 0 && $self->{range}->{row_range}[0] == 0 ) {

          # Construct $col_header
          if ( ref($href) eq "Spreadsheet::ParseExcel::Cell" ) {
            push @col_header, $href->value();
          }
          else {
            push @col_header, "";
          }
        }
        else {

          # Construct $rows
          if ( ref($href) eq "Spreadsheet::ParseExcel::Cell" ) {
            push @rows, $href->value();
          }
          else {
            push @rows, "";
          }
        }
      }
      if ( $i == 0 && $self->{range}->{row_range}[0] == 0 ) {
        $t->setCols(
          [ "", map { $_ . " [" . ( $j++ + $c_start ) . "]" } @col_header ] );
      }
      else { $t->addRow( [ "[" . ( $i + $r_start ) . "]", @rows ] ) }

      $i++;
    }
  }
  print $t;

  return 0;
}

sub _format_table_with_header_but_no_index {
  my $self            = shift;
  my $sheet_index     = shift;
  my $t               = Text::ASCIITable->new();
  my $i               = 0;
  my @givin_col_range = ();
  my @col_header      = ();
  my @rows            = ();

  print "_format_table_with_header_but_no_index \n";

  if ( !defined $self->{range} ) {
    croak "Should set range in advance.\n";
  }

  # If the range include header (row 0), then skip it.
  if ( $self->{range}->{row_range}[0] != 0 ) {
    @givin_col_range = @{ $self->range()->{col_range} };
    print "givin_col_range:@givin_col_range\n";
    $t->setCols( @{ $self->sheet_header($sheet_index) }
        [ $givin_col_range[0] .. $givin_col_range[1] ] );
  }

  for my $key ( sort ( keys %{ $self->range() } ) ) {
    if ( $key ne "row_range" && $key ne "col_range" ) {
      @rows = ();
      for my $href ( @{ $self->range()->{$key} } ) {
        if ( $i == 0 && $self->{range}->{row_range}[0] == 0 ) {

          # Construct $col_header
          if ( ref($href) eq "Spreadsheet::ParseExcel::Cell" ) {
            push @col_header, $href->value();
          }
          else {
            push @col_header, "";
          }
        }
        else {

          # Construct $rows
          if ( ref($href) eq "Spreadsheet::ParseExcel::Cell" ) {
            push @rows, $href->value();
          }
          else {
            push @rows, "";
          }
        }
      }
      if ( $i == 0 && $self->{range}->{row_range}[0] == 0 ) {
        $t->setCols(@col_header);
      }
      else { $t->addRow(@rows) }

      $i++;
    }
  }
  print $t;

  return 0;
}

sub _format_table_no_header_but_with_index {
  my $self = shift;
  my $t    = Text::ASCIITable->new();
  my $i    = 0;
  my ( $r_start, $c_start, $c_end ) = ( 0, 0, 0 );

  if ( defined $self->{range} ) {
    $r_start = $self->{range}->{row_range}[0];
    ( $c_start, $c_end ) = @{ $self->{range}->{col_range} };
    print "rs:$r_start, cs:$c_start, ce:$c_end\n";
  }
  else {
    croak "Should set range in advance.\n";
  }

  print "_format_table_no_header_but_with_index \n";

  $t->setCols( [ "", map { "[" . $_ . "]" } ( $c_start .. $c_end ) ] );
  for my $key ( sort ( keys %{ $self->range() } ) ) {
    if ( $key ne "row_range" && $key ne "col_range" ) {
      my @rows = ();
      for my $href ( @{ $self->range()->{$key} } ) {

        # Construct $rows
        if ( ref($href) eq "Spreadsheet::ParseExcel::Cell" ) {
          push @rows, $href->value();
        }
        else {
          push @rows, "";
        }
      }
      $t->addRow( [ "[" . ( $i++ + $r_start ) . "]", @rows ] );
    }
  }
  $t->setOptions( 'drawRowLine', 1 );

  # Like without header
  print $t->draw(
    [ '.-', '-.', '-', '-' ],
    [ '|',  '|',  '|' ],
    [ '| ', ' |', ' ', ' ' ],
    [ '|',  '|',  '|' ],
    [ '.-', '-.', '-', '-' ],
    [ '| ', ' |', ' ', ' ' ],
  );
  return 0;
}

sub _format_table {
  my $self = shift;
  my $t    = Text::ASCIITable->new();
  my $i    = 0;

  print "_format_table \n";

  for my $key ( sort ( keys %{ $self->range() } ) ) {
    if ( $key ne "row_range" && $key ne "col_range" ) {
      my @col_header = ();
      my @rows       = ();
      for my $href ( @{ $self->range()->{$key} } ) {
        if ( $i == 0 ) {

          if ( defined $href && ref($href) eq "Spreadsheet::ParseExcel::Cell" )
          {

            # Construct $col_header
            push @col_header, $href->value();
          }
          else {
            push @col_header, "  ";
          }
        }
        else {
          if ( defined $href && ref($href) eq "Spreadsheet::ParseExcel::Cell" )
          {

            # Construct $col_header
            push @rows, $href->value();
          }
          else {
            push @rows, "  ";
          }

          # Construct $rows

        }
      }
      if   ( $i == 0 ) { $t->setCols(@col_header) }
      else             { $t->addRow(@rows) }

      $i++;
    }
  }
  $t->setOptions( 'drawRowLine', 1 );

  # Like without header
  print $t->draw(
    [ '.-', '-.', '-', '-' ],
    [ '|',  '|',  '|' ],
    [ '| ', ' |', ' ', ' ' ],
    [ '|',  '|',  '|' ],
    [ '.-', '-.', '-', '-' ],
    [ '| ', ' |', ' ', ' ' ],
  );

  return 0;
}

sub _format_default {
  my $self = shift;
  my ( $row_start, $col_start ) =
    ( $self->range()->{row_range}[0], $self->range()->{col_range}[0] );

  #
  #  print "row_range:@{$self->range()->{row_range}}\n";
  #  print "row_start:" . $self->range()->{row_range}[0] . "\n";
  #  print "col_range:@{$self->range()->{col_range}}\n";
  #  print "col_start:" . $self->range()->{col_range}[0] . "\n";

  print "_format_default \n";

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

