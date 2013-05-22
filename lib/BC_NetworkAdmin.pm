package BC_NetworkAdmin; 

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

=head2 Revision

Revision: 1.01 (2013-5-12 20:48:34)
Log:
1. Refactor the flow in Class attributes subroutine, to be more clear and reasonable.

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
  
  if (defined $self->{ftpsrv} && defined $self->{username} && $self->{password}) {
    if ( ! defined $self->ftpobj($self->{ftpsrv}) ) {
      croak "Setup ftpobj failed."
    }
    if ( ref $self->ftp_login($self->{username}, $self->{password}) ne "Net::FTP") {
      print "[" . __FILE__ . " Line:" . __LINE__ . "]\n";
      print "[ERR] BC_NetworkAdmin new failed at \$self->ftp_login.\n" ;
      return 1; 
    }
  }
  
  $self->_init();

  return $self;
}

sub _init {
  return 0;
}

sub target_path {
  my $self = shift;
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( scalar(@_) == 1 ) {
    return $self->{target_path} = shift;
  }
  elsif ( defined $self->{target_path} ) {
    return $self->{target_path};
  }
  else {
    return undef;
  }
}

sub ftpsrv {
  my $self = shift;
  my $data;
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{ftpsrv} = $data;
  }
  elsif ( defined $self->{ftpsrv} ) {
    return $self->{ftpsrv};
  }
  else {
    return undef;
  }
}

sub username {
  my $self = shift;
  my $data;
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{username} = $data;
  }
  elsif ( defined $self->{username} ) {
    return $self->{username};
  }
  else {
    return undef;
  }
}

sub password {
  my $self = shift;
  my $data;
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{password} = $data;
  }
  elsif ( defined $self->{password} ) {
    return $self->{password};
  }
  else {
    return undef;
  }
}

sub ftpobj {
  my $self = shift;
  my $data;
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( scalar(@_) == 1) {
    $data = shift;    
    return $self->{ftpobj} = Net::FTP->new($self->ftpsrv(), Debug => 0);
  }
  elsif ( defined $self->{ftpobj} and ref $self->{ftpobj} eq "Net::FTP") {
    return $self->{ftpobj};
  }
  else {
    return undef;
  }
}

# Instance method
sub ftp_login {
  my $self = shift;
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( scalar(@_) == 2) {   
    $self->username(shift);
    $self->password(shift); 
    if ( ref $self->ftpobj eq "Net::FTP") {
      if ( ! $self->ftpobj->login($self->username, $self->password) ) {
        # Login failed.
        print "[WAR] Validate user name and password failed.\n";
        return 1;
      }
      return $self->ftp_establish_session($self->{ftpobj});
    }
    else {
      croak "Should set $self->ftpobj at first.";
    }
  }
}

# ftp_establish_session is a ref to $self->ftpobj
sub ftp_establish_session {
  my $self = shift;
  my $data;
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( scalar(@_) == 1) {
    $data = shift; 
    if (ref $data eq "Net::FTP") {   
      return $self->{ftp_establish_session} = $data;
    }
    else {
      print "[ERR] This is not a Net::FTP ref.\n";
      return 1;
    }
  }
  elsif ( defined $self->{ftp_establish_session} ) {
    return $self->{ftp_establish_session};
  }
  else {
    print "[ERR] You need specify a var.\n";
    return 1;
  }
}

# Instance method
sub ftp_close {
  my $self = shift;
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( defined $self->ftp_establish_session) {
      $self->ftp_establish_session->quit();
  }
  return 0;
}

# Instance method
sub Download {
  my $self = shift;
  my $ftpobj;

  print 'ftpsrv: '      . $self->ftpsrv      . "\n";
  print 'username: '    . $self->username    . "\n";
  print 'password: '    . $self->password    . "\n";
  print 'target_path: ' . $self->target_path . "\n";

  if (not defined $self->ftp_establish_session) {
    croak "You need set up ftp session before you use any function.";
  }
  $self->ftp_establish_session->binary() or print "[ERR] Set binary mode failed.", $ftpobj->message;
  #print $ftpobj->dir()  or die "dir failed ", $ftpobj->message;
  # To change to a particular directory on the FTP server, use the cwd method
  # $ftpobj->cwd("/") or die "Change work directory failed ", $ftpobj->message;
  $self->ftp_establish_session -> get ($self->target_path())  or print "[ERR] Get failed.", $ftpobj->message;
  
  return 0;
}

1;

