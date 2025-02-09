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

subtest 'can connect to database' => sub {

    my $dbh = $DB->connect;
    is ref $dbh, 'DBI::db', 'Opened database successfully';
};

subtest 'can disconnect from database' => sub {

    my $dbh = $DB->connect;

    subtest 'can disconnect successfully' => sub {
        is $DB->disconnect($dbh), 1, 'Disconnected successfully';
    };

    subtest '"no active connection found"' => sub {
        is $DB->disconnect(undef), 0, '"No active connection found"';
    };
};

done_testing;