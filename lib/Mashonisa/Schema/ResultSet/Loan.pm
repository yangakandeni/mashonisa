package Mashonisa::Schema::ResultSet::Loan;

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

sub by_status ($self, $loan_status){

    return $self unless $loan_status;
    my $alias = $self->current_resource_alias;

    return $self->search_rs({ "$alias.loan_status" => $loan_status });
}

sub by_loan_period ($self, $start_date, $end_date ) {

    return $self unless $start_date && $end_date;
    my $alias = $self->current_source_alias;

    return $self->search_rs(
        {
            "$alias.date_borrowed" => { -between => [$start_date, $end_date] }
        }
    );
}

1;
