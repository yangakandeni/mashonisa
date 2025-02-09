#!/usr/bin/env perl

use lib 'lib';
use Test::Most;

use_ok('Mashonisa::DB');

isa_ok( my $DB = Mashonisa::DB->new, 'Mashonisa::DB' );

no warnings;
*Mashonisa::DB::database_file = sub { './test.db' };
use warnings;

is $DB->driver, 'SQLite', 'Got expected database driver';
is $DB->dsn, 'DBI:SQLite:dbname=./test.db', 'Got expected database dsn';
is $DB->database_file, './test.db', 'Got expected path to test database file';
isa_ok $DB->schema, 'Mashonisa::Schema', 'Got Mashonisa::Schema schema ref';

done_testing;