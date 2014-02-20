use strict;
use warnings;
use Test::More 0.88;

{
    package Foo;
    use Sub::Name;
    sub bar { }
    use namespace::autoclean;
    sub moo { }
    BEGIN { *kooh = *kooh = do { package Moo; sub { }; }; }
    BEGIN { *affe = *affe = sub { }; }
    BEGIN { *tiger = *tiger = subname tiger => sub { }; }
}

ok( Foo->can('bar'), 'Foo can bar - standard method');
ok( Foo->can('moo'), 'Foo can moo - standard method');
ok(!Foo->can('kooh'), 'Foo cannot kooh - anon sub from another package assigned to glob');
ok( Foo->can('affe'), 'Foo can affe - anon sub assigned to glob in package');
ok( Foo->can('tiger'), 'Foo can tiger - anon sub named with subname assigned to glob');
ok(!Foo->can('subname'), 'Foo cannot subname - sub imported from Sub::Name');

done_testing();
