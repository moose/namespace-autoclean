use strict;
use warnings;
use Test::More 0.88;

use namespace::autoclean ();
# hack for running out of a checkout
BEGIN { $namespace::autoclean::VERSION ||= 999 }

use Test::Requires qw(Moose MooseX::MarkAsMethods);

{
    package Foo;
    use Moose;

    # mark overloads as methods and wipe other non-methods
    use MooseX::MarkAsMethods autoclean => 1;

    # define overloads, etc as normal
    use overload '""' => sub { shift->stringify };
    sub stringify { "welp" }

}

{
    package Bar;
    use Moose::Role;
    use MooseX::MarkAsMethods autoclean => 1;

    # overloads defined in a role will "just work" when the role is
    # composed into a class; they MUST use the anon-sub style invocation
    use overload '""' => sub { shift->stringify };
    sub stringify { "welp" }

    # additional methods generated outside Class::MOP/Moose can be marked, too
    use Scalar::Util qw(blessed);
    BEGIN { __PACKAGE__->meta->mark_as_method('blessed') }
}

{
    package Baz;
    use Moose;
    with 'Bar';
}

my $foo = Foo->new;
is "$foo", 'welp', "MarkAsMethods maintains overloads";

my $baz = Baz->new;
is "$baz", "welp", "MarkAsMethods maintains overloads in roles";
can_ok 'Baz', 'blessed';

done_testing;
