use strict;
use warnings;
use Test::More 0.88;
{
  package Temp1;
  use Test::Requires {
    'Moo'   => 0,
    'Class::MOP' => 0,
  };
}

{
    package Class;
    use Carp qw(cluck);
    use File::Basename qw(fileparse);
    use Moo;
    use namespace::autoclean;
    sub bar { }
    BEGIN { *baz = sub {}; }
}

can_ok('Class', 'bar');
ok(Class->can('baz'), 'Class->baz method added via glob assignment');
ok(!Class->can('cluck'), 'cluck sub was cleaned from Class');
ok(!Class->can('fileparse'), 'fileparse sub was cleaned from Class');
ok(!Class::MOP::class_of('Class'), q{Moo class is not "upgraded" to a Moose class});

{
    package Role;
    use Carp qw(cluck);
    use File::Basename qw(fileparse);
    use Moo::Role;
    use namespace::autoclean;
    sub bar { }
    BEGIN { *baz = sub {}; }
}

can_ok('Role', 'bar');
ok(Role->can('baz'), 'Role->baz method added via glob assignment');
ok(!Role->can('cluck'), 'cluck sub was cleaned from Role');
ok(!Role->can('fileparse'), 'fileparse sub was cleaned from Role');
ok(!Class::MOP::class_of('Role'), q{Moo role is not "upgraded" to Moose});

done_testing();
