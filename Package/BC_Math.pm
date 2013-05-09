package BC_Math;

=pod

=head1 BC_Math.pm

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

BC_Math.pm.

=head2 DESCRIPTION

Encapsulate some math algorithms I met.

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
  To me, those methods in this package should be Class Methods, because they could be called without newing a instance.
  But I didn't know how to implement Class Method in Perl... Wait some time.
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
<B>Created:</B>&nbsp&nbsp 2013-5-4 20:52:10 </br>
<B>Revision:</B>&nbsp 1.0                      </br>

=end html


=head2 Comments in Code

=cut

use strict;
use warnings;
use utf8;
use Carp;

sub new {
  my ($class_name) = shift;

  my $self = {@_};
  bless( $self, $class_name );
  $self->_init();

  return $self;
}

sub _init {

  return 0;
}

sub range_check {
  my $self = shift;
  my ( $arr_given, $arr_target ) = ( shift, shift );

  if ( defined @$arr_given[0] && defined @$arr_given[1] ) {
    # Sort given point to right order    
    @$arr_given = sort {$a <=> $b} (@$arr_given);
    print "after sort:@$arr_given \n";
    
    if ( @$arr_given[0] > @$arr_target[1] || @$arr_given[0] < @$arr_target[0] )
    {
      carp "Range ["
        . @$arr_given[0] . ", "
        . @$arr_given[1]
        . "] out of ["
        . @$arr_target[0] . ", "
        . @$arr_target[1] . "].\n";
    }
  }
  else {
    @$arr_given = @$arr_target;
  }

  return 0;
}

1;

=begin html

</br>
</br>

=end html

