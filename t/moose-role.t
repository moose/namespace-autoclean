use strict;
use warnings;
use Test::More;

BEGIN {
  plan skip_all => 'Moose required for this test'
    unless eval { require Moose };
}

{
  package Some::Role;
  use Moose::Role;
  sub role_method { 42 }
}

{
  package Consuming::Class;
  use Moose;
  use namespace::autoclean;
  with 'Some::Role';
}

{
  package Consuming::Class::InBegin;
  use Moose;
  use namespace::autoclean;
  BEGIN { with 'Some::Role' };
}

can_ok('Consuming::Class', 'role_method');
can_ok('Consuming::Class::InBegin', 'role_method');

done_testing;
