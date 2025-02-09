#!/usr/bin/env perl

use lib 'lib';
use Test::Most;

package Test::Module {

    use Mouse;
    with qw/ Mashonisa::Role::DB /;

    1;
};

is ref Test::Module->new->db, 'Mashonisa::DB', 'Can instantiate database via role';


done_testing;
