use strict;
use warnings;
use Test::More 0.88;
{
  package Temp1;
  use Test::Requires {
    'Mouse' => 0,
    'Sub::Name' => 0,
  };
}

{
    package Class;
    use Scalar::Util qw(blessed);
    use Mouse;
    use namespace::autoclean;
    sub bar { }
    __PACKAGE__->meta->add_method(baz => sub { });
}

can_ok('Class', 'meta');
can_ok('Class', 'bar');
ok(Class->can('baz'), 'Class->baz method added via meta->add_method');
ok(!Class->can('subname'), 'subname sub was cleaned from Class');

{
    package Role;
    use Scalar::Util qw(blessed);
    use Mouse::Role;
    use namespace::autoclean;
    sub bar { }
    __PACKAGE__->meta->add_method(baz => sub { });
}

# meta doesn't get cleaned, although it's not in get_method_list for roles
can_ok('Role', 'meta');
can_ok('Role', 'bar');
ok(Role->can('baz'), 'Role->baz method added via meta->add_method');
ok(!Class->can('subname'), 'subname sub was cleaned from Role');

done_testing();
