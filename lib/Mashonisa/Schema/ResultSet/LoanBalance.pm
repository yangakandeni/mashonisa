package Mashonisa::Schema::ResultSet::LoanBalance;

use strict;
use warnings;

use experimental qw/ signatures /;
use base 'DBIx::Class::ResultSet';

sub by_agent ($self, $agent_id){

    return $self unless $agent_id;

    return $self->search_rs(
        {
            'client.agent_id' => { -in => [ $agent_id ] },
        },
        {
            join => [qw/ client /],
        }
    );
}

sub by_client_name ($self, $client_name){

    return $self unless $client_name;

    return $self->search_rs(
        {
            'client.name' => { -like => '%'. $client_name .'%' },
        },
        {
            join => [qw/ client /],
        }
    );
}

1;
