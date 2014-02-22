use strict;
use warnings;

package namespace::autoclean;
# ABSTRACT: Keep imports out of your namespace

use B::Hooks::EndOfScope 0.12;
use List::Util qw( first );
use namespace::clean 0.20;

=head1 SYNOPSIS

    package Foo;
    use namespace::autoclean;
    use Some::Package qw/imported_function/;

    sub bar { imported_function('stuff') }

    # later on:
    Foo->bar;               # works
    Foo->imported_function; # will fail. imported_function got cleaned after compilation

=head1 DESCRIPTION

When you import a function into a Perl package, it will naturally also be
available as a method.

The C<namespace::autoclean> pragma will remove all imported symbols at the end
of the current package's compile cycle. Functions called in the package itself
will still be bound by their name, but they won't show up as methods on your
class or instances.

This module is very similar to L<namespace::clean|namespace::clean>, except it
will clean all imported functions, no matter if you imported them before or
after you C<use>d the pragma. It will also not touch anything that looks like a
method.

If you're writing an exporter and you want to clean up after yourself (and your
peers), you can use the C<-cleanee> switch to specify what package to clean:

  package My::MooseX::namespace::autoclean;
  use strict;

  use namespace::autoclean (); # no cleanup, just load

  sub import {
      namespace::autoclean->import(
        -cleanee => scalar(caller),
      );
  }

=head1 WHAT IS AND ISN'T CLEANED

C<namespace::autoclean> will leave behind anything that it deems a method.  For
L<Moose> or L<Mouse> classes, this the based on the C<get_method_list> method
on from the L<Class::MOP::Class|metaclass>.  For non-Moose classes, anything
defined within the package will be identified as a method.  This should match
Moose's definition of a method.  Additionally, the magic subs installed by
L<overload> will not be cleaned.

=head1 PARAMETERS

=head2 -also => [ ITEM | REGEX | SUB, .. ]

=head2 -also => ITEM

=head2 -also => REGEX

=head2 -also => SUB

Sometimes you don't want to clean imports only, but also helper functions
you're using in your methods. The C<-also> switch can be used to declare a list
of functions that should be removed additional to any imports:

    use namespace::autoclean -also => ['some_function', 'another_function'];

If only one function needs to be additionally cleaned the C<-also> switch also
accepts a plain string:

    use namespace::autoclean -also => 'some_function';

In some situations, you may wish for a more I<powerful> cleaning solution.

The C<-also> switch can take a Regex or a CodeRef to match against local
function names to clean.

    use namespace::autoclean -also => qr/^_/

    use namespace::autoclean -also => sub { $_ =~ m{^_} };

    use namespace::autoclean -also => [qr/^_/ , qr/^hidden_/ ];

    use namespace::autoclean -also => [sub { $_ =~ m/^_/ or $_ =~ m/^hidden/ }, sub { uc($_) == $_ } ];

=head1 CAVEATS

When used with L<Moo> classes, the heuristic used to check for methods won't
work correctly for methods from roles consumed at compile time.

  package My::Class;
  use Moo;
  use namespace::autoclean;

  # Bad, any consumed methods will be cleaned
  BEGIN { with 'Some::Role' }

  # Good, methods from role will be maintained
  with 'Some::Role';

=head1 SEE ALSO

L<namespace::clean>

L<B::Hooks::EndOfScope>

=cut

sub import {
    my ($class, %args) = @_;

    my $subcast = sub {
        my $i = shift;
        return $i if ref $i eq 'CODE';
        return sub { $_ =~ $i } if ref $i eq 'Regexp';
        return sub { $_ eq $i };
    };

    my $runtest = sub {
        my ($code, $method_name) = @_;
        local $_ = $method_name;
        return $code->();
    };

    my $cleanee = exists $args{-cleanee} ? $args{-cleanee} : scalar caller;

    my @also = map { $subcast->($_) } (
        exists $args{-also}
        ? (ref $args{-also} eq 'ARRAY' ? @{ $args{-also} } : $args{-also})
        : ()
    );

    on_scope_end {
        my $subs = namespace::clean->get_functions($cleanee);
        my $method_check = _method_check($cleanee);

        my @clean = grep {
          my $method = $_;
          !$method_check->($method)
          || first { $runtest->($_, $method) } @also;
        } keys %$subs;

        namespace::clean->clean_subroutines($cleanee, @clean);
    };
}

sub _method_check {
    my $package = shift;
    my $meta;
    if (
      (defined &Class::MOP::class_of and $meta = Class::MOP::class_of($package))
      or (defined &Mouse::Util::class_of and $meta = Mouse::Util::class_of($package))
    ) {
        my %methods = map { $_ => 1 } $meta->get_method_list;
        $methods{meta} = 1
          if $meta->isa('Moose::Meta::Role') && Moose->VERSION < 0.90;
        return sub { $_[0] =~ /^\(/ || $methods{$_[0]} };
    }
    else {
        require B;
        return sub {
            return 1 if $_[0] =~ /^\(/;
            my $full = "${package}::$_[0]";
            my $coderef = do {
              no strict 'refs';
              return unless defined &$full;
              \&$full;
            };
            my $cv = B::svref_2object($coderef);
            return unless $cv->isa('B::CV');
            return if $cv->GV->isa('B::SPECIAL');
            return $cv->GV->STASH->NAME eq $package;
        };
    }
}

1;
