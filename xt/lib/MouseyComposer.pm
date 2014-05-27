use strict;
use warnings;
package MouseyComposer;

use Mouse;
extends 'MouseyClean';
with 'MouseyRole';
use Scalar::Util 'weaken';
use namespace::autoclean;

sub child_stuff {}

use constant CAN => [ qw(stuff role_stuff child_stuff meta) ];
use constant CANT => [ qw(has with refaddr reftype weaken)];
1;
