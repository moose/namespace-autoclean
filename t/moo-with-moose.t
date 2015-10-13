use strict;
use warnings;
use Test::Requires {
  'Moose' => '()',
  'Moo' => '1.004000 ()',
};

use FindBin qw($Bin);

do "$Bin/moo.t";
die $@ if $@;
