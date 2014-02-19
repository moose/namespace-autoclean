use strict;
use warnings;
use Test::More 0.88;
my $have_sub_name;
BEGIN {
    $have_sub_name = eval { require Sub::Name } ? 1 : 0;
}

{
    package Foo;
    sub bar { }
    use namespace::autoclean;
    sub moo { }
    BEGIN { *kooh = *kooh = do { package Moo; sub { }; }; }
    BEGIN { *affe = *affe = sub { }; }
    BEGIN { $have_sub_name and Sub::Name->import }
    BEGIN { $have_sub_name and *tiger = *tiger = subname tiger => sub { }; }
}

ok( Foo->can('bar'), 'Foo can bar - standard method');
ok( Foo->can('moo'), 'Foo can moo - standard method');
ok(!Foo->can('kooh'), 'Foo cannot kooh - anon sub from another package assigned to glob');
ok( Foo->can('affe'), 'Foo can affe - anon sub assigned to glob in package');
SKIP: {
    skip 'Sub::Name not available', 2
      unless $have_sub_name;
    ok( Foo->can('tiger'), 'Foo can tiger - anon sub named with subname assigned to glob');
    ok(!Foo->can('subname'), 'Foo cannot subname - sub imported from Sub::Name');
}

done_testing();
