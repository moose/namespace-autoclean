use strict;
use warnings;
use Test::More 0.88;
{
  package Temp1;
  use Test::Requires qw(Moose);
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
