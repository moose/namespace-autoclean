use strict;
use warnings;

use Test::More;

{
    package Foo;
    use Scalar::Util qw(blessed);
    sub bar { }
    use namespace::autoclean -except => ['blessed'];
}

ok( Foo->can('bar'), 'Foo has bar method' );
ok( Foo->can('blessed'), 'Foo has blessed sub - passed to -except as arrayref' );

{
    package Bar;
    use Scalar::Util qw(blessed);
    sub bar { }
    use namespace::autoclean -except => 'blessed';
}

ok( Bar->can('bar'), 'Bar has bar method' );
ok( Bar->can('blessed'), 'Bar has blessed sub - passed to -except as string' );

done_testing();

