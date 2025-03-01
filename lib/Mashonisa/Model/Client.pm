package Mashonisa::Model::Client;

use strict;
use warnings;

use Mouse;
with qw/ Mashonisa::Role::DB /;

use lib 'lib';
use Syntax::Keyword::Try;
use experimental qw/ signatures say /;

has name => (is => 'ro', isa => 'Str');

sub get_total_amount_borrowed ($self, $agent_id, $start_date, $end_date ) {

    try {
        my $Schema = $self->db->schema;
        my $total_borrowed_amount = $Schema->resultset('Loan')
            ->by_agent( $agent_id )
            ->by_client_name( $self->name )
            ->by_loan_period( $start_date, $end_date )
            ->get_column('me.amount_borrowed')
            ->sum
        ;

        return $total_borrowed_amount;
    } catch ( $error ) {
        die 'Could not calculate total amount borrowed for client - ' . $error;
    }
}

sub get_total_amount_due ($self, $agent_id, $start_date, $end_date ) {

    try {

        my $Schema = $self->db->schema;
        my $TXNScopeGuard = $Schema->txn_scope_guard;

        my $total_borrowed_amount = $Schema->resultset('Loan')
            ->by_agent( $agent_id )
            ->by_client_name( $self->name )
            ->by_loan_period( $start_date, $end_date )
            ->get_column('me.amount_borrowed')
            ->sum
        ;

        my $client_interest_rate = $Schema->resultset('Client')
            ->by_agent( $agent_id )
            ->by_client_name( $self->name )
            ->get_column('me.interest_rate')
            ->single
        ;

        my $AgentRS = $Schema->resultset('Agent')->find({ id => $agent_id });
        my $interest_rate = defined $client_interest_rate && $client_interest_rate >= 0 ? $client_interest_rate : $AgentRS->interest_rate->amount;

        $TXNScopeGuard->commit;

        return $total_borrowed_amount * ( 1 + $interest_rate );

    } catch ( $error ) {
        die 'Could not calculate total amount due - ' . $error;
    }
}

1;