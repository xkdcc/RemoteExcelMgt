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
my $ret;
my $na = BC_NetworkAdmin->new(
  "ftpsrv"   => "10.200.108.10",
  "username" => "ss",
  "password" => "ss",
);

if (ref $na ne "BC_NetworkAdmin"){
  croak "BC_NetworkAdmin->new failed.\n";
}

$na->target_path("/LOC_Machines_List.xls");
$ret = $na->Download();
if ($ret != 1) {
  print "Download successfully.\n";
}
else {
  print "Download failed.\n";
}

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
use File::Basename;
use Net::FTP;
use Encode;

use FindBin qw( $RealBin );

sub new {
  my ($class_name) = shift;

  my $self = {@_};
  bless( $self, $class_name );

  if ( defined $self->{ftpsrv}
    && defined $self->{username}
    && $self->{password} )
  {

    if (
      ref $self->ftp_login(
        BC_Constant->Ftp_Login_Direct, $self->ftpsrv,
        $self->username,               $self->password
      ) ne "Net::FTP"
      )
    {
      print "[" . __FILE__ . " Line:" . __LINE__ . "]\n";
      print "[ERR] BC_NetworkAdmin new failed at \$self->ftp_login.\n";
      return 1;
    }
  }

  $self->_init();

  return $self;
}

sub _init {
  return 0;
}

# File's full path on FTP
# Used for download().
sub target_path {
  my $self = shift;

  unless ( ref $self eq "BC_NetworkAdmin" ) {
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

# Local file's full path
sub local_files {
  my $self = shift;

  unless ( ref $self eq "BC_NetworkAdmin" ) {
    croak "Should call local_files with an object, not a class.";
  }

  if ( scalar(@_) == 1 ) {
    return $self->{local_files} = shift;
  }
  elsif ( defined $self->{local_files} ) {
    return $self->{local_files};
  }
  else {
    return undef;
  }
}

# Target folder on FTP that you want to upload file into.
# We don't check target folder whether exist on FTP.
# Used for Upload().
sub target_folder {
  my $self = shift;

  unless ( ref $self eq "BC_NetworkAdmin" ) {
    croak "Should call target_folder with an object, not a class.";
  }

  if ( scalar(@_) == 1 ) {
    return $self->{target_folder} = shift;
  }
  elsif ( defined $self->{target_folder} ) {
    return $self->{target_folder};
  }
  else {
    return undef;
  }
}

sub ftpsrv {
  my $self = shift;

  unless ( ref $self eq "BC_NetworkAdmin" ) {
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

  unless ( ref $self eq "BC_NetworkAdmin" ) {
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

  unless ( ref $self eq "BC_NetworkAdmin" ) {
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

#------------------------------------------------------------------------------
# Calling format:
# $self->_ftpobj # Return directly if have defined.
# $self->_ftpobj # Return a new if defined $self->ftpsrv and haven't been defined ftpobj
# $self->_ftpobj(ip) # Set $self->ftpsrv and new and return a Net::FTP instance
# Called by:
# $self->ftp_login
#------------------------------------------------------------------------------
sub _ftpobj {
  my $self = shift;
  my $ret;

  unless ( ref $self eq "BC_NetworkAdmin" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) == 1 ) {
    $self->ftpsrv(shift);
    $ret = Net::FTP->new( $self->ftpsrv(), Debug => 0 );
    return $self->{ftpobj} = $ret;
  }
  elsif ( defined $self->{ftpobj} and ref $self->{ftpobj} eq "Net::FTP" ) {
    return $self->{ftpobj};
  }
  elsif ( defined $self->ftpsrv and !defined $self->{ftpobj} ) {
    return $self->{ftpobj} = Net::FTP->new( $self->ftpsrv, Debug => 0 );
  }
  else {
    return undef;
  }
}

# Instance method
# ftp_login() or ftp_login(username, password)
sub ftp_login {
  my $self = shift;
  my $ans;

  unless ( ref $self eq "BC_NetworkAdmin" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) == 4 && $_[0] == BC_Constant->Ftp_Login_Direct ) {
    shift;    # Ignore BC_Constant->Ftp_Login_Direct
    $self->ftpsrv(shift);
    if ( !defined $self->_ftpobj( $self->ftpsrv ) ) {
      croak "Setup ftpobj failed.";
    }
    $self->username(shift);
    $self->password(shift);
  }
  elsif ( scalar(@_) == 1 && $_[0] == BC_Constant->Ftp_Login_Require_STDIN ) {
    print "FTP server ip or host name: ";
    chomp( $ans = <STDIN> );
    if ( !defined $self->_ftpobj($ans) ) {
      croak "Setup ftpobj failed.";
    }
    print "FTP user name: ";
    chomp( $ans = <STDIN> );
    $self->username($ans);
    print "FTP password: ";
    chomp( $ans = <STDIN> );
    $self->password($ans);
  }
  else {
    croak "[ERR] Parameters error.";
  }
  if ( !$self->_ftpobj->login( $self->username, $self->password ) ) {

    # Login failed.
    print "[WAR] Validate user name and password failed.\n";
    return 1;
  }
  return $self->ftp_establish_session( $self->{ftpobj} );
}

# ftp_establish_session is a ref to $self->ftpobj
sub ftp_establish_session {
  my $self = shift;
  my $data;

  unless ( ref $self eq "BC_NetworkAdmin" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) == 1 ) {
    $data = shift;
    if ( ref $data eq "Net::FTP" || !defined $data ) {
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
    return $self->{ftp_establish_session} = undef;
  }
}

# Instance method
sub check_established_session_and_ask_continue {
  my $self = shift;
  my ( $ret, $ans );
  my ( $tries, $tried_ftp_login, $tried_y_n ) = ( 3, 0, 0 );

  while (1) {
    if ( !defined $self->ftp_establish_session ) {
      $ret = $self->ftp_login( BC_Constant->Ftp_Login_Require_STDIN )
        ;    # Verify username and password
      if ( $ret == 1 ) {
        print "[ERR] Login to "
          . $self->ftpsrv
          . " with user name ["
          . $self->username
          . "] password ["
          . $self->password
          . "] failed.\n";
        print "[ERR] You've tried 3 times, exit now.\n"
          if $tried_ftp_login == 3;
        print "      Please try again.\n\n";
        $tried_ftp_login++;
        next;
      }
      print "[INF] Good, log on successfully.\n";
      last;
    }
    else {
      do {
        print "You have logged on [" . $self->ftpsrv . "]. Continue? [Y/N] ";
        chomp( $ans = <STDIN> );
        if ( lc $ans eq "n" ) {
          if ( defined $self->ftp_establish_session ) {
            $self->ftp_close();
          }
          $ret = $self->ftp_login( BC_Constant->Ftp_Login_Require_STDIN )
            ;    # Verify username and password
          if ( $ret == 1 ) {
            print "[ERR] Login to "
              . $self->ftpsrv
              . " with user name ["
              . $self->username
              . "] password ["
              . $self->password
              . "] failed.\n";
            print "[ERR] You've tried 3 times, exit now.\n"
              if $tried_ftp_login == 3;
            print "      Please try again.\n\n";
            $tried_ftp_login++;
            next;
          }
          print "[INF] Good, log on successfully.\n";
          last;
        }
        elsif ( lc $ans eq "y" ) {
          last;
        }
        else {
          print "[INF] Bad answer. Please try again.\n";
          print "[ERR] You've tried 3 times, exit now.\n"
            if $tried_ftp_login++ == 2;
        }
      } while ( lc $ans ne "n" && lc $ans ne "y" );
    }
  }
}

# Instance method
sub ftp_close {
  my $self = shift;

  unless ( ref $self eq "BC_NetworkAdmin" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( defined $self->ftp_establish_session ) {
    $self->ftp_establish_session->quit();
    $self->ftp_establish_session(undef);
  }
  return 0;
}

sub ftp_exists {
  my $self = shift;
  if    ( defined $self->ftp_establish_session->size(@_) ) { return 1; }
  elsif ( $self->ftp_isdir(@_) )                           { return 1; }
  else                                                     { return 0; }
}

sub ftp_isfile {
  my $self = shift;
  return 1 if $self->ftp_exists(@_) && !$self->ftp_isdir(@_);
  0;
}

sub ftp_isdir {
  my $self = shift;
  my $c    = $self->ftp_establish_session->pwd();
  my $r    = $self->ftp_establish_session->cwd(@_);
  my $d    = $self->ftp_establish_session->cwd($c);
  my $e    = $self->ftp_establish_session->pwd();
  print "[WAR] Could not CWD into original directory $c.\n" if $c ne $e || !$d;
  return $r ? 1 : 0;
}

# Instance method
sub ftp_file_dir_exists {
  my $self = shift;

  if ( not defined $self->ftp_establish_session ) {
    croak "You need set up ftp session before you use any function.";
  }

  if    ( defined $self->ftp_establish_session->size(@_) ) { return 1; }
  elsif ( $self->ftp_isdir(@_) )                           { return 1; }
  else                                                     { return 0; }
}

# Instance method
sub Download {
  my $self = shift;
  my $ans;
  my $ret;

  if ( not defined $self->ftp_establish_session ) {
    croak "You need set up ftp session before you use any function.";
  }
  $self->ftp_establish_session->binary()
    or croak "[ERR] Set binary mode failed.";

  #print $ftpobj->dir()  or die "dir failed ", $ftpobj->message;
  # To change to a particular directory on the FTP server, use the cwd method

  # Better to change to / every time.
  $self->ftp_establish_session->cwd("/")
    or croak "Change work directory failed.";

  # Check remote
  $ret = $self->ftp_file_dir_exists( $self->target_path );
  if ( $ret == 0 ) {

    # Not exist
    print "[WAR] File ["
      . $self->target_path
      . "] not exist on "
      . $self->ftpsrv . ".\n";
    return 1;
  }

  # Check local
  if ( -e $RealBin . "/" . basename( $self->target_path ) ) {
    print
"[WAR] Seems you have a local copy with tha same name, do you want to overwrite it? [Y/N] ";
    chomp( $ans = <STDIN> );
    if ( lc $ans eq "n" ) {
      return 1;
    }
  }
  if ( $self->target_path ne "" ) {
    if ( !$self->ftp_establish_session->get( $self->target_path() ) ) {
      return 1;
    }
  }
  else {
    print "[ERR] Please set target_path at first.\n";
    return 1;
  }

  return 0;
}

# Instance method
sub Upload {
  my $self = shift;
  my ( $ans, $ret );
  my $ftp_path;
  my $check_exist;

  if ( $self->local_files eq "" || $self->target_folder eq "" ) {
    croak "[ERR] Please set local_files and target_folder correctly.\n";
  }

  if ( not defined $self->ftp_establish_session ) {
    croak "You need set up ftp session before you use any function.";
  }
  $self->ftp_establish_session->binary()
    or croak "[ERR] Set binary mode failed.";

  # Check remote dir
  $ret = $self->ftp_isdir( $self->target_folder );
  if ( $ret == 0 ) {

    # exist
    print "[WAR] ["
      . $self->target_folder
      . "] not exists on "
      . $self->ftpsrv . ".\n";
    print "      Please try again.\n";
    return 1;
  }

  # Better to change to / every time.
  $self->ftp_establish_session->cwd( $self->target_folder )
    or croak "Change work directory failed.";

# After tried, found we didn't need to conver $self->local_files, it's in gb2312 already.
# print "local:" . $self->local_files . "\n";
#  for my $file ( $self->ftp_establish_session->ls() ) {
#    print encode("gb2312", decode("utf8", $file)) . "\n";
#  }

  # Check local
  if ( !-e $RealBin . "/" . basename( $self->local_files ) ) {
    print "[WAR] Seems local [" 
      . $RealBin . "/"
      . basename( $self->local_files )
      . "] not exist. Please try again.\n";
    return 1;
  }

  # Check remote file
  $ftp_path = $self->target_folder . "/" . basename( $self->local_files );
  $ret      = $self->ftp_isfile($ftp_path);
  if ( $ret == 1 ) {

    # exist
    print "[WAR] ["
      . $self->target_folder . "/"
      . basename( $self->local_files )
      . "] exists on "
      . $self->ftpsrv
      . " already.\n";
    print "[WAR] Do you want to do an overwrite? [Y/N] ";
    chomp( $ans = <STDIN> );
    if ( lc $ans eq "n" ) {
      return 1;
    }
  }

  if ( !$self->ftp_establish_session->put( $self->local_files ) ) {
    return 1;
  }

  return 0;
}

1;

