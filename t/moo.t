use strict;
use warnings;

use Test::Requires {
    'Class::MOP' => '0',
    Moo          => '0',
};

use Test::More;

{
    package Class;
    use Sub::Name;
    use Moo;
    use namespace::autoclean;
    sub bar { }
}

can_ok('Class', 'bar');
ok(!Class->can('subname'), 'subname sub was cleaned from Class');
ok(!Class::MOP::class_of('Class'), q{Moo class is not "upgraded" to a Moose class});

done_testing();
