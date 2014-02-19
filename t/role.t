use strict;
use warnings;

use Test::Requires {
    Moose => '0.56',
};

use Test::More;

{
    package Foo;
    use Moose::Role;
    use namespace::autoclean;
    sub bar { }
}

# meta doesn't get cleaned, although it's not in get_method_list for roles
can_ok('Foo', 'meta');
can_ok('Foo', 'bar');

done_testing();
