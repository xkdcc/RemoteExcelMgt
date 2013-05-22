package BC_OS_Utility;

=pod

=head1 BC_OS_Utility.pm

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

BC_OS_Utility.pm.

=head2 DESCRIPTION

Encapsulate some OS functions I need.

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
<B>Created:</B>&nbsp&nbsp 2013-5-22 11:11:30 </br>
<B>Revision:</B>&nbsp 1.0                      </br>

=end html

=head2 Revision

Revision: 

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

sub check_os {
  my $os_name;
  
  if ($^O =~ /linux/) {
    $os_name="Linux";
  }
  elsif ($^O =~ /Win32/) {
    $os_name="Windows";    
  }
  elsif ($^O =~ /darwin/) {
    $os_name="MacOS";        
  }
  else {
    $os_name="Unknown";
  }

  return $os_name;
}

1;