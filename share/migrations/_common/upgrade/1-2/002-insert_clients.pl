#!/usr/bin/env perl

use strict;
use warnings;

use DBIx::Class::Migration::RunScript;

migrate {

    my $ClientRS = shift->schema->resultset('Client')
        ->populate([
            [qw/ agent_id name /],
            [qw/ 1 Client11 /],
            [qw/ 1 Client12 /],
            [qw/ 1 Client13 /],
            [qw/ 2 Client21 /],
            [qw/ 2 Client22 /],
            [qw/ 2 Client23 /],
            [qw/ 3 Client31 /],
            [qw/ 3 Client32 /],
    ]);
};