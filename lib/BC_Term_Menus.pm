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

use FindBin qw( $RealBin );
use lib "$RealBin/lib";

use BC_Constant;
use BC_OS_Utility;

sub new {
  my ($class_name) = shift;

  my $self = {@_};
  bless( $self, $class_name );
  
  # Set default value if not defined.
  if ( ! defined $self->banner) {
    $self->banner("");
  }  
  if ( ! defined $self->delimiter) {
    $self->delimiter(")");
  }  
  if ( ! defined $self->ask_hint_text) {
    $self->ask_text("Please choose one of the following options:\n");
  }
  if ( ! defined $self->ask_text) {
    $self->answer_text("Please enter a choice: ");
  }
  if ( ! defined $self->echo_choice_text) {
    $self->echo_choice_text("Your choice: ");
  }
  if ( ! defined $self->try_time) {
    $self->try_time("3");
  }
  if ( ! defined $self->too_many_tries_text) {
    $self->too_many_tries("You've tried too many times.\n");
  }
  if ( ! defined $self->no_option_text) {
    $self->no_option_text("That's not one of the available options.\n");
  }
  $self->tried("0"); 
  if ( ! defined $self->bullet_type) {
    $self->bullet_type = BC_Constant->Term_Menus_Bullet_Numarical;
  }
  
  $self->_init();

  return $self;
}

sub _init {
  return 0;
}

sub banner {
  my $self = shift;  

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call banner with an object, not a class.";
  }
  # Receive more data
  my $data;
  
  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{banner} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{banner} ) {
    return $self->{banner};
  }
  else {
    return $self->{banner}="Welcome to use RemoteExcel.pl written by Brant Chen.\n\n";
  }
}

sub delimiter {
  my $self = shift; 

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call delimiter with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{delimiter} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{delimiter} ) {
    return $self->{delimiter};
  }
  else {
    return $self->{delimiter}=")";
  }
}

sub ask_hint_text {
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call ask_hint_text with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{ask_hint_text} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{ask_hint_text} ) {
    return $self->{ask_hint_text};
  }
  else {
    return $self->{ask_hint_text}="Please choose one of the following options:\n";
  }
}

sub ask_text {
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call ask_text with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{ask_text} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{ask_text} ) {
    return $self->{ask_text};
  }
  else {
    return $self->{ask_text}="Please enter a choice: ";
  }
}

sub echo_choice_text {
  my $self = shift;
  
  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call echo_choice_text with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{echo_choice_text} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{echo_choice_text} ) {
    return $self->{echo_choice_text};
  }
  else {
    return $self->{echo_choice_text}="Your choice: ";
  }
}

sub try_time {
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call try_time with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{try_time} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{try_time} ) {
    return $self->{try_time};
  }
  else {
    return $self->{try_time}=3;
  }
}

sub multi_menu_item {
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call multi_menu_item with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    if ($data != BC_Constant->Term_Menus_Multi_Menu_Items && $data != BC_Constant->Term_Menus_Single_Menu_Items) {
      return $self->{multi_menu_item}=BC_Constant->Term_Menus_Multi_Menu_Items;      
    }
    return $self->{multi_menu_item} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{multi_menu_item} ) {
    return $self->{multi_menu_item};
  }
  else {
    return $self->{multi_menu_item}=BC_Constant->Term_Menus_Multi_Menu_Items;
  }
}

sub prt_control {
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call prt_control with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    if ( ! ref $data eq "HASH") {
      croak "Should be HASH ref.";
    }    
    return $self->{prt_control} = $data;
  }
  elsif ( scalar(@_) == 0 && ref $self->{prt_control} eq "HASH") {
    return $self->{prt_control};
  }
  else {
    return undef;
  }
}

sub too_many_tries_text {
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call too_many_tries_text with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{too_many_tries_text} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{too_many_tries_text} ) {
    return $self->{too_many_tries_text};
  }
  else {
    return $self->{too_many_tries_text}="You've tried too many times.\n";
  }
}

sub no_option_text {
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call no_option_text with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{no_option_text} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{no_option_text} ) {
    return $self->{no_option_text};
  }
  else {
    return $self->{no_option_text}="That's not one of the available options. Please try again.\n\n";
  }
}

sub tried {
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call tried with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    return $self->{tried} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{tried} ) {
    return $self->{tried};
  }
  else {
    return undef;
  }
}

sub bullet_type {
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call bullet_type with an object, not a class.";
  }
  my $data;
  
  if ( scalar(@_) == 1 ) {
    $data = shift;
    if ($data != BC_Constant->Term_Menus_Bullet_Numarical && $data != BC_Constant->Term_Menus_Bullet_Alpha) {
      croak "Term menus bullet type should only be Term_Menus_Bullet_Numarical(0) or Term_Menus_Bullet_Alpha(1).";    
    }
    return $self->{bullet_type} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{bullet_type} ) {
    return $self->{bullet_type};
  }
  else {
    return $self->{bullet_type} = BC_Constant->Term_Menus_Bullet_Numarical;
  }
}

sub menu_list {  
  my $self = shift;

  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call menu_list with an object, not a class.";
  }
  my $data;

  if ( scalar(@_) == 1 ) {
    $data = shift;
    if ( !defined $data || ref $data ne "ARRAY") {
      croak "You should provide the menu items list and it's an array ref.";
    } 
    return $self->{menu_list} = $data;
  }
  elsif ( scalar(@_) == 0 && defined $self->{menu_list} ) {
    return $self->{menu_list};
  }
  else {
    return undef;
  }
}

# Class method
sub clear_screen {  
  my $cmd;
  
  if (BC_OS_Utility->check_os() eq "Linux") {
    $cmd="clear";
  }
  elsif (BC_OS_Utility->check_os() eq "Windows") {
    $cmd="cls";
  }
  else {
    print "Can't recognize OS.\n";
    $cmd="";
  }
  system $cmd;
}

sub menu {
  my $self = shift;
  my $answer;
  
  unless ( ref $self eq "BC_Term_Menus" ) {
    croak "Should call parser with an object, not a class.";
  }
  
  BC_Term_Menus->clear_screen();
  # Create a default self if we didn't get one
  if(!defined($self) or !ref($self)) {
    $self = BC_Term_Menus->new();
  } 
  
  print $self->banner if $self->prt_control->{banner};
  print $self->ask_hint_text if $self->prt_control->{ask_hint_text};
  
  #print "@{$self->menu_list}\n";
  
  if ($self->bullet_type == BC_Constant->Term_Menus_Bullet_Alpha) {  
  }
  else {
    if ($self->bullet_type != BC_Constant->Term_Menus_Bullet_Numarical) {
      print "Warning: You provide bad bullet type. I will use Term_Menus_Bullet_Numarical by default\n";
    }
    #for my $i (0..$#)
    
    my $i=0;
  
    map {s/(^)(.*)($)/++$i . $self->delimiter . " " . $1 . $2 . $3 . "\n";/ge} @{$self->menu_list};
    {
      local $"='';
      print "@{$self->menu_list}\n";
    }
    while (1) {
      print $self->ask_text();
      $answer = <STDIN>;
      chomp $answer;
      
      # TODO: [Brant][2013-5-22 12:29:37]
      # 1. check Term_Menus_Single_Menu_Item
      #
      if ( $answer =~/[^0-9]+/ || $answer < 1 || $answer > scalar (@{$self->menu_list})) {
        $self->tried($self->tried + 1);
        if ($self->tried >= $self->try_time) {
          print $self->echo_choice_text() . $answer . "\n" if $self->prt_control->{echo_choice_text};
          print $self->too_many_tries_text();
          exit 0;
        }
        print $self->echo_choice_text() . $answer . "\n" if $self->prt_control->{echo_choice_text};
        print $self->no_option_text() if $self->prt_control->{no_option_text};
      }
      else {
        print $self->echo_choice_text() . $answer . "\n" if $self->prt_control->{echo_choice_text};
        $self->tried(0);
        return $answer;
      }
    }    
  }
}


1;

=begin html

</br>
</br>

=end html


