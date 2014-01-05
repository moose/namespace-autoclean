use strict;
use warnings;
use Test::More tests => 3;

{
    package Foo;
    use overload
      'bool' => sub { 0 },
      '0+' => 'numify',
      fallback => 1,
    ;
    use namespace::autoclean;
    sub numify { 219 }
    sub new { bless {}, $_[0] }
}

is sprintf('%d', Foo->new), 219, 'method name overload';
is sprintf('%s', Foo->new), 219, 'fallback overload';
ok !Foo->new, 'subref overload';
