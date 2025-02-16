#!/usr/bin/env perl

use strict;
use warnings;

use DBIx::Class::Migration::RunScript;

migrate {

    my $AgentRS = shift->schema->resultset('InterestRate')
        ->populate([
            [qw/ amount /],
            [qw/ 0.30 /],
            [qw/ 0.40 /],
    ]);
};