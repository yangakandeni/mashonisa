package Mashonisa::DB;

use strict;
use warnings;
use experimental qw/ say signatures /;

use DBI;
use Mouse;
use lib 'lib';

# Define database connection parameters
my $driver = "SQLite";
my $database = "../mashonisa.db";
my $dsn = "DBI:$driver:dbname=$database";

sub connect ($self,$dsn) {

    # Connect to the database without username/password for SQLite
    my $dbh = DBI->connect($dsn, "", "", { RaiseError => 1 }) or die $DBI::errstr;

    say "Opened database successfully";

    return $dbh;
}

sub disconnect {
    my ($self,$dbh) = @_;

    if (defined($dbh)) {

        # Commit any pending transactions if AutoCommit is off
        if (!$dbh->{AutoCommit}) {
            eval {
                # Try committing; ignore errors since we're about to disconnect anyway.
                local ($@);
                $dbh->commit();
            };
        }

        # Disconnect from the database
        eval {
            local ($@);
            undef($dbh);  # Disconnects when handle goes out of scope.
        };

        return 1;

    } else {
        return 0;
    }

    return undef;
}

1;