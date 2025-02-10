#!/usr/bin/env perl

use lib 'lib';
use Test::Most;
use Test::DBIx::Class
    -schema_class=>'Mashonisa::Schema',
    -fixture_class => '::Population',
    qw/ Agent Client /
;

# These only run for version 2 of the schema
plan skip_all => 'not correct schema version'
    if Schema->schema_version != 2;

fixtures_ok ['all_tables'];

is Agent->count, 3, 'got expected number of agents';
is Client->count, 8, 'got expected number of clients';

done_testing;