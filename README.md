# NAME

namespace::autoclean - Keep imports out of your namespace

# SYNOPSIS

    package Foo;
    use namespace::autoclean;
    use Some::Package qw/imported_function/;

    sub bar { imported_function('stuff') }

    # later on:
    Foo->bar;               # works
    Foo->imported_function; # will fail. imported_function got cleaned after compilation

# DESCRIPTION

When you import a function into a Perl package, it will naturally also be
available as a method.

The `namespace::autoclean` pragma will remove all imported symbols at the end
of the current package's compile cycle. Functions called in the package itself
will still be bound by their name, but they won't show up as methods on your
class or instances.

This module is very similar to [namespace::clean](https://metacpan.org/pod/namespace::clean), except it
will clean all imported functions, no matter if you imported them before or
after you `use`d the pragma. It will also not touch anything that looks like a
method.

If you're writing an exporter and you want to clean up after yourself (and your
peers), you can use the `-cleanee` switch to specify what package to clean:

    package My::MooseX::namespace::autoclean;
    use strict;

    use namespace::autoclean (); # no cleanup, just load

    sub import {
        namespace::autoclean->import(
          -cleanee => scalar(caller),
        );
    }

# WHAT IS AND ISN'T CLEANED

`namespace::autoclean` will leave behind anything that it deems a method.  For
[Moose](https://metacpan.org/pod/Moose) classes, this the based on the `get_method_list` method
on from the [Class::MOP::Class](https://metacpan.org/pod/metaclass).  For non-Moose classes, anything
defined within the package will be identified as a method.  This should match
Moose's definition of a method.  Additionally, the magic subs installed by
[overload](https://metacpan.org/pod/overload) will not be cleaned.

# PARAMETERS

## -also => \[ ITEM | REGEX | SUB, .. \]

## -also => ITEM

## -also => REGEX

## -also => SUB

Sometimes you don't want to clean imports only, but also helper functions
you're using in your methods. The `-also` switch can be used to declare a list
of functions that should be removed additional to any imports:

    use namespace::autoclean -also => ['some_function', 'another_function'];

If only one function needs to be additionally cleaned the `-also` switch also
accepts a plain string:

    use namespace::autoclean -also => 'some_function';

In some situations, you may wish for a more _powerful_ cleaning solution.

The `-also` switch can take a Regex or a CodeRef to match against local
function names to clean.

    use namespace::autoclean -also => qr/^_/

    use namespace::autoclean -also => sub { $_ =~ m{^_} };

    use namespace::autoclean -also => [qr/^_/ , qr/^hidden_/ ];

    use namespace::autoclean -also => [sub { $_ =~ m/^_/ or $_ =~ m/^hidden/ }, sub { uc($_) == $_ } ];

## -except => \[ ITEM | REGEX | SUB, .. \]

## -except => ITEM

## -except => REGEX

## -except => SUB

This takes exactly the same options as `-also` except that anything this
matches will _not_ be cleaned.

# CAVEATS

When used with [Moo](https://metacpan.org/pod/Moo) classes, the heuristic used to check for methods won't
work correctly for methods from roles consumed at compile time.

    package My::Class;
    use Moo;
    use namespace::autoclean;

    # Bad, any consumed methods will be cleaned
    BEGIN { with 'Some::Role' }

    # Good, methods from role will be maintained
    with 'Some::Role';

# SEE ALSO

[namespace::clean](https://metacpan.org/pod/namespace::clean)

[B::Hooks::EndOfScope](https://metacpan.org/pod/B::Hooks::EndOfScope)

# AUTHOR

Florian Ragwitz <rafl@debian.org>

# CONTRIBUTORS

- Andrew Rodland <andrew@hbslabs.com>
- Chris Prather <cprather@hdpublishing.com>
- Dave Rolsky <autarch@urth.org>
- Felix Ostmann <sadrak@sadrak-laptop.(none)>
- Graham Knop <haarg@haarg.org>
- Karen Etheridge <ether@cpan.org>
- Kent Fredric <kentfredric@gmail.com>
- Shawn M Moore <sartak@gmail.com>
- Tomas Doran <bobtfish@bobtfish.net>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Florian Ragwitz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
