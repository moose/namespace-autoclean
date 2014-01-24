use strict;
use warnings;
use Test::More eval { require Moo }
  ? (tests => 3)
  : (skip_all => 'Moo required for this test');

{
  package Some::Role;
  use Moo::Role;
  sub role_method { 42 }
}

{
  package Consuming::Class;
  use Moo;
  use namespace::autoclean;
  with 'Some::Role';
}

{
  package Consuming::Class::InBegin;
  use Moo;
  use namespace::autoclean;
  BEGIN { with 'Some::Role' };
}

can_ok('Consuming::Class', 'role_method');
{
  local $TODO = 'Moo::Role consumed in BEGIN is cleared from consumer';
  can_ok('Consuming::Class::InBegin', 'role_method');
}
is $INC{'Class/MOP/Class.pm'}, undef, 'Moose not loaded';
