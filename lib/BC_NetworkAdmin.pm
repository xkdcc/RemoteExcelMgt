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
Example #1:
my $na = BC_NetworkAdmin->new(
  "ftpsrv"   => "10.200.108.10",
  "username" => "ss",
  "password" => "ss",
);

if (ref $na ne "BC_NetworkAdmin"){
  croak "BC_NetworkAdmin->new failed.\n";
}

$na->target_path("/LOC_Machines_List.xls");
$na->Download();

Example #2:
my $na_ftp = BC_NetworkAdmin->new();

print "FTP server ip or host name: ";
$na_ftp->ftpsrv(chomp ($ans=<STDIN>)); 
$na_ftp->ftpobj();

print "FTP user name: ";
$na_ftp->username(chomp ($ans=<STDIN>));
print "FTP password: ";
$na_ftp->password(chomp ($ans=<STDIN>));    

$ret = $na_ftp->ftp_login();
if ($ret == 1) {
  print "[ERR] Login to " . $na_ftp->ftpsrv . " with user name [" .  $na_ftp->username . "] password [" . $na_ftp->password . "] failed.\n";
  print "      Please try again.\n\n";
  exit 1;
}   
print "[INF] Good, log on successfully.\n";

$na_ftp->target_path(chomp ($ans=<STDIN>));
$ret = $na_ftp->Download();
if ($ret == 1) {
  print "[ERR] Get [" . $na_ftp->target_path. "] failed.\n";
  print $na_ftp->ftp_establish_session->message . "\n"; 
  print "      Please try again.\n\n";
  exit 1;
}    
print "[INF] Good, download [" . $na_ftp->target_path . "] to [" . FindBin->RealBin . "] successfully.\n";
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
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( scalar(@_) == 1 ) {
    return $self->{ftpsrv} = shift;
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
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) == 1 ) {
    return $self->{username} = shift;
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
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( scalar(@_) == 1 ) {
    return $self->{password} = shift;
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
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  unless ( defined $self->ftpsrv ) {
    croak "Should set \$self->ftpsrv at first.";
  }
  
  if ( scalar(@_) == 1) {
    return $self->{ftpobj} = Net::FTP->new($self->ftpsrv(), Debug => 0);
  }
  elsif ( defined $self->{ftpobj} and ref $self->{ftpobj} eq "Net::FTP") {
    return $self->{ftpobj};
  }
  elsif ( defined $self->ftpsrv and ! defined $self->{ftpobj}) {
    return $self->{ftpobj} = Net::FTP->new($self->ftpsrv, Debug => 0);
  }
  else {
    return undef;
  }
}

# Instance method
# ftp_login() or ftp_login(username, password)
sub ftp_login {
  my $self = shift;
  
  unless ( ref $self eq "BC_NetworkAdmin") {
    croak "Should call target_path with an object, not a class.";
  }
  
  if ( scalar(@_) == 2) {   
    $self->username(shift);
    $self->password(shift); 
  }
  if (defined $self->username && defined $self->password) {
    if ( defined $self->ftpobj) {
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
  else {
    croak "Should provide username, password at first.";
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
  $self->ftp_establish_session->binary() or print "[ERR] Set binary mode failed.", $self->ftp_establish_session->message;
  #print $ftpobj->dir()  or die "dir failed ", $ftpobj->message;
  # To change to a particular directory on the FTP server, use the cwd method
  # $ftpobj->cwd("/") or die "Change work directory failed ", $ftpobj->message;
  #if ( -e $ENV{'PWD'} . )
  if (! $self->ftp_establish_session -> get ($self->target_path()) ) {
    return 1;
  }
  
  return 0;
}

1;

