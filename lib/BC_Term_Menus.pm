package BC_Term_Menus;

=pod

=head1 BC_Term_Menus.pm

=head2 COPYRIGHT

Copyright 2012 - 2013 Brant (brantchen2008@gmail.com), All Rights Reserved 

=head2 SYNOPSIS

BC_Term_Menus.pm.

=head2 DESCRIPTION

Module to create terminal menu.

=head2 USAGE        

=begin html

<pre>

This module will create menu like this:

Please pick an item: ---- This the banner.

  bullets) Description   ----This is bullets, numeric or alphabet; delimiter; description
  
(Type "quit" to quit)    ---- This is hint, constant string.

Please enter a choice:   ---- This is a constant string.

You can set trys_time. 
The number of tries the user has to enter a possible option, before the module decides
to print a message (see toomanytries) and return undef. A value of 0 means unlimited.
default: 0

toomanytries, This is a constant string.

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
  Before I wrote this package, I did some reviews for others' good Term packages and something like that.
  Including:
  http://search.cpan.org/~jstowe/Term-Screen-1.03/Screen.pm
  http://search.cpan.org/~dazjorz/Term-Menu-0.09/lib/Term/Menu.pm
  http://search.cpan.org/~reedfish/Term-Menus-2.25/lib/Term/Menus.pm
  http://search.cpan.org/~shlomif/Term-Shell-0.03/lib/Term/Shell.pod
  They are all pretty good.
  But at last, I chose to write my own for better understanding Perl programming. 
  Sure, I learnt a lot from them.
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
<B>Created:</B>&nbsp&nbsp 2013-5-11 17:37:39 </br>
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
  
  # Set default value if not defined.
  $self->banner("Welcome to use RemoteExcel.pl written by Brant Chen.\n\n"); 
  if ( ! defined $self->delimiter) {
    $self->delimiter(")");
  }  
  if ( ! defined $self->ask_text) {
    $self->ask_text("Please choose one of the following options:\n");
  }
  if ( ! defined $self->answer_text) {
    $self->answer_text("Please enter a choice: ");
  }
  if ( ! defined $self->echo_answer_text) {
    $self->echo_answer_text("Your choice: ");
  }
  if ( ! defined $self->trys_time) {
    $self->trys_time("3");
  }
  if ( ! defined $self->too_many_tries_text) {
    $self->too_many_tries("You've tried too many times.\n");
  }
  if ( ! defined $self->no_option_text) {
    $self->no_option_text("That's not one of the available options.\n");
  }
  $self->tried("0");
  
  $self->_init();

  return $self;
}

sub _init {
  return 0;
}

sub banner {
  my $self = shift;

  # Receive more data
  my $data = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) != 1 ) {
    croak "Argv count should be 1.";
  }

  if ( !defined $data ) {
    return $self->{banner} = "Welcome to use RemoteExcel.pl written by Brant Chen.\n\n";
  }

  # Set the banner if there's any data there.
  return $self->{banner} = $data;
}

sub delimiter {
  my $self = shift;

  # Receive more data
  my $data = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) != 1 ) {
    croak "Argv count should be 1.";
  }

  if ( !defined $data ) {
    return $self->{delimiter} = ")";
  }

  # Set the delimiter if there's any data there.
  return $self->{delimiter} = $data;
}

sub ask_text {
  my $self = shift;

  # Receive more data
  my $data = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) != 1 ) {
    croak "Argv count should be 1.";
  }

  if ( !defined $data ) {
    return $self->{ask_text} = "Please choose one of the following options:\n";
  }

  # Set the banner if there's any data there.
  return $self->{ask_text} = $data;
}

sub answer_text {
  my $self = shift;

  # Receive more data
  my $data = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) != 1 ) {
    croak "Argv count should be 1.";
  }

  if ( !defined $data ) {
    return $self->{answer_text} = "Please enter a choice: ";
  }

  # Set the banner if there's any data there.
  return $self->{answer_text} = $data;
}

sub echo_answer_text {
  my $self = shift;

  # Receive more data
  my $data = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) != 1 ) {
    croak "Argv count should be 1.";
  }

  if ( !defined $data ) {
    return $self->{echo_answer_text} = "Your choice: ";
  }

  # Set the banner if there's any data there.
  return $self->{echo_answer_text} = $data;
}

sub trys_time {
  my $self = shift;

  # Receive more data
  my $data = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) != 1 ) {
    croak "Argv count should be 1.";
  }

  if ( !defined $data ) {
    return $self->{trys_time} = 3;
  }

  # Set the banner if there's any data there.
  return $self->{trys_time} = $data;
}

sub too_many_tries_text {
  my $self = shift;

  # Receive more data
  my $data = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) != 1 ) {
    croak "Argv count should be 1.";
  }

  if ( !defined $data ) {
    return $self->{too_many_tries_text} = "You've tried too many times.\n";
  }

  # Set the banner if there's any data there.
  return $self->{too_many_tries_text} = $data;
}

sub no_option_text {
  my $self = shift;

  # Receive more data
  my $data = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) != 1 ) {
    croak "Argv count should be 1.";
  }

  if ( !defined $data ) {
    return $self->{no_option_text} = "That's not one of the available options.\n";
  }

  # Set the banner if there's any data there.
  return $self->{no_option_text} = $data;
}

sub tried {
  my $self = shift;

  # Receive more data
  my $data = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call target_path with an object, not a class.";
  }

  if ( scalar(@_) != 1 ) {
    croak "Argv count should be 1.";
  }

  if ( !defined $data ) {
    return $self->{tried} = 0;
  }

  # Set the banner if there's any data there.
  return $self->{tried} = $data;
}

sub menu {
  my $self = shift;
  # Create a default self if we didn't get one
  $self = BC_Term_Menus->new() if(!defined($self) or !ref($self)); 
  
  
  return $self->menu;
}


1;

=begin html

</br>
</br>

=end html


