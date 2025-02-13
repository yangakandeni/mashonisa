package Mashonisa::DB;

use strict;
use warnings;
use experimental qw/ signatures /;

use Mouse;
use lib 'lib';

use Mashonisa::Schema;

has driver => (
    is => 'ro',
    isa => 'Str',
    default => 'SQLite',
);

has database_file => (
    is => 'ro',
    isa => 'Str',
    default => 'share/mashonisa-schema.db',
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

has schema => (
    is => 'ro',
    isa => 'Mashonisa::Schema',
    lazy => 1,
    default => sub ($self) {

        return Mashonisa::Schema->connect($self->dsn, "", "", { RaiseError => 1 })
    }
);

# sub schema ($self) {

#     # Connect to the database without username/password for SQLite
#     my $dbh = Mashonisa::Schema->connect($self->dsn, "", "", { RaiseError => 1 }) or die $DBI::errstr;

#     say "Opened database successfully";

#     return $dbh;
# }

# # sub disconnect ($self,$dbh) {

# #     if (defined($dbh)) {

# #         # Commit any pending transactions if AutoCommit is off
# #         if (!$dbh->{AutoCommit}) {
# #             eval {
# #                 # Try committing; ignore errors since we're about to disconnect anyway.
# #                 local ($@);
# #                 $dbh->commit();
# #             };
# #         }

# #         # Disconnect from the database
# #         eval {
# #             local ($@);
# #             undef($dbh);  # Disconnects when handle goes out of scope.
# #         };

# #         return 1;

# #     } else {
# #         return 0;
# #     }

# #     return undef;
# # }

1;