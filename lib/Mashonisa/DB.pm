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

has database => (
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
        my $database = $self->database;
        return "dbi:$driver:dbname=$database";
    }
);

has schema => (
    is => 'ro',
    isa => 'Mashonisa::Schema',
    lazy => 1,
    default => sub ($self) {
        return Mashonisa::Schema->connect($self->dsn);
    }
);

__PACKAGE__->meta->make_immutable;
