package Mashonisa::Schema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';

our $VERSION = 4;

__PACKAGE__->load_namespaces(
    resultset_namespace => 'ResultSet',
);

1;