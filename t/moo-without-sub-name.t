use strict;
use warnings;
BEGIN {
  unshift @INC, sub {
    die "Can't locate $_[1]"
      if $_[1] =~ m{^(?:Sub/Name\.pm|Sub/Util\.pm)$};
  };
}
use Test::Requires {
  'Moo' => '1.004000 ()',
};

use Test::More;

use FindBin qw($Bin);

do "$Bin/moo.t";
die $@ if $@;
