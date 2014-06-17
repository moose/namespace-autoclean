$ENV{MOUSE_PUREPERL} = 1;
do 't/mouse.t';
die $@ if $@;
