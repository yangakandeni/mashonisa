package Mashonisa::DB;

use strict;
use warnings;
use experimental qw/ say signatures /;

use DBI;
use Mouse;
use lib 'lib';

has driver => (
    is => 'ro',
    isa => 'Str',
    default => 'SQLite',
);

has database_file => (
    is => 'ro',
    isa => 'Str',
    default => '../mashonisa.db',
);

has dsn => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub ($self) {

        my $driver = $self->driver;
        my $database = $self->database_file;
        return "DBI:$driver:dbname=$database";
    }
);

sub connect ($self) {

    # Connect to the database without username/password for SQLite
    my $dbh = DBI->connect($self->dsn, "", "", { RaiseError => 1 }) or die $DBI::errstr;

    say "Opened database successfully";

    return $dbh;
}

sub disconnect ($self,$dbh) {

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