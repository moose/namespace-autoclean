use strict;
use warnings;

use Test::More;

{
    package Foo;
    use Sub::Name;
    sub bar { }
    use namespace::autoclean -except => ['subname'];
}

ok( Foo->can('bar'), 'Foo has bar method' );
ok( Foo->can('subname'), 'Foo has subname sub - passed to -except as arrayref' );

{
    package Bar;
    use Sub::Name;
    sub bar { }
    use namespace::autoclean -except => 'subname';
}

ok( Bar->can('bar'), 'Bar has bar method' );
ok( Bar->can('subname'), 'Bar has subname sub - passed to -except as string' );

done_testing();

