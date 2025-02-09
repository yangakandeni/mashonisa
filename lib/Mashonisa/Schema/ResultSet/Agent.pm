package Mashonisa::Schema::ResultSet::Agent;

use strict;
use warnings;

use experimental qw/ signatures /;
use base 'DBIx::Class::ResultSet';

sub by_name ($self, $name) { return $self->find({ name => $name }) }

1;
