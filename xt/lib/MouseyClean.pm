use strict;
use warnings;
package MouseyClean;

use Mouse;
use Scalar::Util 'refaddr';
use namespace::autoclean;

sub stuff {}

use constant CAN => [ qw(stuff meta) ];
use constant CANT => [ qw(has with refaddr)];
1;
