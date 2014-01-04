use strict;
use warnings;
use Test::More tests => 6;
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

ok( Foo->can('bar'));
ok( Foo->can('moo'));
ok(!Foo->can('kooh'));
ok( Foo->can('affe'));
SKIP: {
    skip 'Sub::Name not available', 2
      unless $have_sub_name;
    ok( Foo->can('tiger'));
    ok(!Foo->can('subname'));
}
