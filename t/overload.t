use strict;
use warnings;

use Test::More;

{
    package Overloaded;
    use overload q{""} => '_stringify';
    use namespace::autoclean;

    sub new {
        bless { value => $_[1] }, $_[0];
    }

    sub _stringify { $_[0]->{value} }
}

my $overloaded = Overloaded->new('foo');
is("$overloaded", 'foo', 'Overloaded object still overloads stringification');

done_testing();
