use strict;
use warnings;
use Test::More 0.88;
{
  package Temp1;
  use Test::Requires {
    'Mouse' => 0,
  };
}

{
    package Class;
    use Carp qw(cluck);
    use File::Basename qw(fileparse);
    use Mouse;
    use namespace::autoclean;
    sub bar { }
    __PACKAGE__->meta->add_method(baz => sub { });
    use constant CAT => 'kitten';
}

can_ok('Class', 'meta');
can_ok('Class', 'bar');
ok(Class->can('baz'), 'Class->baz method added via meta->add_method');
ok(!Class->can('cluck'), 'cluck sub was cleaned from Class');
ok(!Class->can('fileparse'), 'fileparse sub was cleaned from Class');
ok(Class->can('CAT'), 'constant sub was not cleaned');

skip 'meta is not available in older perls?!', 6 if $] < 5.010;

{
    package Role;
    use Carp qw(cluck);
    use File::Basename qw(fileparse);
    use Mouse::Role;
    use namespace::autoclean;
    sub bar { }
    __PACKAGE__->meta->add_method(baz => sub { });
    use constant CAT => 'kitten';
}

# meta doesn't get cleaned, although it's not in get_method_list for roles
can_ok('Role', 'meta');
can_ok('Role', 'bar');
ok(Role->can('baz'), 'Role->baz method added via meta->add_method');
ok(!Role->can('cluck'), 'cluck sub was cleaned from Role');
ok(!Role->can('fileparse'), 'fileparse sub was cleaned from Role');
ok(Role->can('CAT'), 'constant sub was not cleaned');

done_testing();
