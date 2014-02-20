use strict;
use warnings;

use Test::More eval { require Moose; require MooseX::Role::WithOverloading }
  ? ()
  : (skip_all => 'Moose and MooseX::Role::WithOverloading required for this test');


{
    package MyRole;
    use MooseX::Role::WithOverloading;

    use overload
        q{""}    => 'as_string',
        fallback => 1;

    has message => (
        is       => 'rw',
        isa      => 'Str',
    );

    sub as_string { shift->message }
}
{
    package MyClass;
    use Moose;
    use namespace::autoclean;

    with 'MyRole';
}

my $i = MyClass->new( message => 'foobar' );
is "$i", 'foobar', 'overload from MooseX::Role::WithOverloading maintained';

done_testing;
