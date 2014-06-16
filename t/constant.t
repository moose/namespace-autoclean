use strict;
use warnings;
use Test::More 0.88;

{
    package Foo;
    use constant CAT => 'kitten';
    use namespace::autoclean;
}

is(Foo->CAT, 'kitten', 'constant sub was not cleaned');

done_testing;

