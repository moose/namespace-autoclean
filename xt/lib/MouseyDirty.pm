use strict;
use warnings;
package MouseyDirty;

use Mouse;
use Scalar::Util 'refaddr';

sub stuff {}

use constant CAN => [ qw(stuff has with meta refaddr) ];
use constant CANT => [ ];
1;
