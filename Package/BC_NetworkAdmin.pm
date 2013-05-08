#!/usr/bin/env perl 

=pod

=head1 BC_NetworkAdmin.pm

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

BC_NetworkAdmin.pm.

=head2 DESCRIPTION

Encapsulate network operations for my purpose.

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
  Notes here.
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
<B>Created:</B>&nbsp&nbsp 2013-4-28 15:33:16 </br>
<B>Revision:</B>&nbsp 1.0                      </br>

=end html

=cut

package BC_NetworkAdmin;

=head2 Comments in Code

=cut

use strict;
use warnings;
use utf8;
use Carp;
use Net::FTP;

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

sub target_path {
  my $self = shift;
  unless ( ref $self ) {
    croak "Should call target_path with an object, not a class.";
  }

  # Receive more data
  my $data = shift;

  # Set the target_path if there's any data there.
  $self->{target_path} = $data if defined $data;

  return $self->{target_path};
}

sub ftpsrv {
  my $self = shift;
  unless ( ref $self ) {
    croak "Should call target_path with an object, not a class.";
  }

  # Receive more data
  my $data = shift;

  # Set the target_path if there's any data there.
  $self->{ftpsrv} = $data if defined $data;

  return $self->{ftpsrv};
}

sub username {
  my $self = shift;
  unless ( ref $self ) {
    croak "Should call target_path with an object, not a class.";
  }

  # Receive more data
  my $data = shift;

  # Set the target_path if there's any data there.
  $self->{username} = $data if defined $data;

  return $self->{username};
}

sub password {
  my $self = shift;
  unless ( ref $self ) {
    croak "Should call target_path with an object, not a class.";
  }

  # Receive more data
  my $data = shift;

  # Set the target_path if there's any data there.
  $self->{password} = $data if defined $data;

  return $self->{password};
}

sub Download {
  my $self = shift;
  my $ftpobj;

  print 'ftpsrv: ' . $self->ftpsrv() . "\n";
  print 'username: ' . $self->username() . "\n";
  print 'password: ' . $self->password() . "\n";
  print 'target_path: ' . $self->target_path() . "\n";

  $ftpobj = Net::FTP->new($self->ftpsrv(), Debug => 0);
  $ftpobj->login($self->username(), $self->password());
  $ftpobj->binary() or die "Set binary mode failed ", $ftpobj->message;
  #print $ftpobj->dir()  or die "dir failed ", $ftpobj->message;
  # To change to a particular directory on the FTP server, use the cwd method
  # $ftpobj->cwd("/") or die "Change work directory failed ", $ftpobj->message;
  $ftpobj -> get ($self->target_path())  or die "bin failed ", $ftpobj->message;
  $ftpobj -> quit;  
  
  return 0;
}

1;


=begin html

</br>
</br>

=end html
