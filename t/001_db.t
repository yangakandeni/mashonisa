#!/usr/bin/env perl

use lib 'lib';
use Test::Most;

use_ok('Mashonisa::DB');

isa_ok( my $DB = Mashonisa::DB->new, 'Mashonisa::DB' );

my $driver = "SQLite";
my $database = "test.db";
my $dsn = "DBI:$driver:dbname=$database";

subtest 'can connect to database' => sub {

    my $dbh = $DB->connect($dsn);
    is ref $dbh, 'DBI::db', 'Opened database successfully';
};

subtest 'can disconnect from database' => sub {

    my $dbh = $DB->connect($dsn);

    subtest 'can disconnect successfully' => sub {
        is $DB->disconnect($dbh), 1, 'Disconnected successfully';
    };

    subtest '"no active connection found"' => sub {
        is $DB->disconnect(undef), 0, '"No active connection found"';
    };
};

done_testing;