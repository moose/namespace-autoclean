use strict;
use warnings;
use Test::More 0.88;
{
  package Temp1;
  use Test::Requires qw(Moo Class::MOP);
}

{
    package Class;
    use Carp qw(cluck);
    use File::Basename qw(fileparse);
    use Moo;
    use namespace::autoclean;
    sub bar { }
    use constant CAT => 'kitten';
}

can_ok('Class', 'bar');
ok(!Class->can('cluck'), 'cluck sub was cleaned from Class');
ok(!Class->can('fileparse'), 'fileparse sub was cleaned from Class');
ok(!Class::MOP::class_of('Class'), q{Moo class is not "upgraded" to a Moose class});
ok(Class->can('CAT'), 'constant sub was not cleaned');

{
    package Role;
    use Carp qw(cluck);
    use File::Basename qw(fileparse);
    use Moo::Role;
    use namespace::autoclean;
    sub bar { }
    use constant CAT => 'kitten';
}

can_ok('Role', 'bar');
ok(!Role->can('cluck'), 'cluck sub was cleaned from Role');
ok(!Role->can('fileparse'), 'fileparse sub was cleaned from Role');
ok(!Class::MOP::class_of('Role'), q{Moo role is not "upgraded" to Moose});
ok(Role->can('CAT'), 'constant sub was not cleaned');

done_testing();
