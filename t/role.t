use strict;
use warnings;
use Test::More 0.88;

BEGIN {
    eval 'use Moose 0.56 ()';
    plan skip_all => 'requires Moose 0.56' if $@;
}

BEGIN {
    diag "Testing with Moose $Moose::VERSION";
}

{
    package Foo;
    use Moose::Role;
    use namespace::autoclean;
}

# meta doesn't get cleaned, although it's not in get_method_list for roles
can_ok('Foo', 'meta');

done_testing;
