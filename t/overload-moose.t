use strict;
use warnings;

use Test::Requires {
    Moose => '0.56',
};

use Test::More;

{
    package Overloaded;
    use overload q{""} => '_stringify';
    use namespace::autoclean;
    use Moose;

    has value => ( is => 'ro' );
    sub _stringify { $_[0]->value() }
}

my $overloaded = Overloaded->new(value => 'foo');
is("$overloaded", 'foo', 'Overloaded object still overloads stringification');

done_testing();
