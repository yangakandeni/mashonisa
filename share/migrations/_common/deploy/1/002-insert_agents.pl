#!/usr/bin/env perl

use strict;
use warnings;

use DBIx::Class::Migration::RunScript;

migrate {

    my $AgentRS = shift->schema->resultset('Agent')
        ->populate([
            [qw/ name /],
            [qw/ Agent1 /],
            [qw/ Agent2 /],
            [qw/ Agent3 /],
    ]);
};