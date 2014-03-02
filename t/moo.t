use strict;
use warnings;
use Test::More 0.88;

BEGIN {
  plan skip_all => 'Moo and Class::MOP required for this test'
    unless eval { require Moo; require Class::MOP };
}

{
    package Class;
    use Scalar::Util qw(blessed);
    use Moo;
    use namespace::autoclean;
    sub bar { }
}

can_ok('Class', 'bar');
ok(!Class->can('blessed'), 'blessed sub was cleaned from Class');
ok(!Class::MOP::class_of('Class'), q{Moo class is not "upgraded" to a Moose class});

done_testing();
