package Mashonisa::Schema::ResultSet::Client;

use strict;
use warnings;

use experimental qw/ signatures /;
use base 'DBIx::Class::ResultSet';

sub by_name ($self, $name) { return $self->search_rs({ name => $name }) }
sub by_client ($self, $client_id) { return $self->search_rs({ client_id => $client_id }) }

1;
