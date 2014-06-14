use strict;
use warnings;
package MouseyRole;

use Mouse::Role;
use File::Spec::Functions 'devnull';
use namespace::autoclean;

sub role_stuff {}

use constant CAN => [ qw(role_stuff meta) ];
use constant CANT => [ qw(has with devnull)];
1;
