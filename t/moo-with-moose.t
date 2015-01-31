use strict;
use warnings;
use Test::Requires {
  'Moose' => '()',
};
do 't/moo.t';
die $@ if $@;
