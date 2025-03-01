package Mashonisa::Schema::ResultSet::Client;

use strict;
use warnings;

use experimental qw/ signatures /;
use base 'DBIx::Class::ResultSet';

sub by_client_name ($self, $client_name) {

    return $self unless $client_name;
    my $alias = $self->current_source_alias;

    return $self->search_rs({ "$alias.name" => $client_name })
}

sub by_client ($self, $client_id) {

    return $self unless $client_id;
    my $alias = $self->current_source_alias;

    return $self->search_rs({ "$alias.id" => $client_id })
}

sub by_agent ($self, $agent_id){

    return $self unless $agent_id;
    my $alias = $self->current_source_alias;

    return $self->search_rs({ "$alias.agent_id" => $agent_id });
}

1;
