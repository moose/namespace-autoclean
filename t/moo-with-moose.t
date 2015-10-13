use strict;
use warnings;
use Test::Requires {
  'Moose' => '()',
};

use FindBin qw($Bin);

do "$Bin/moo.t";
die $@ if $@;
