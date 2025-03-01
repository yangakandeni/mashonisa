package Mashonisa::Model::Loan;

use strict;
use warnings;

use Mouse;
with qw/ Mashonisa::Role::DB /;

use lib 'lib';
use Syntax::Keyword::Try;
use experimental qw/ signatures say /;

# TODO: These CRUD methods should be able to handle bulk operations
# TODO: Maybe these methods belong in the ClientModel?
sub create_loans ($self, $loans, $agent_id) {

    try {

        die '$loans is required' unless @$loans;
        die '$agent_id is required' unless $agent_id;

        my $Schema = $self->db->schema;
        my $TXNScopeGuard = $Schema->txn_scope_guard;
        my $AgentResult = $Schema->resultset('Agent')->find({ id => $agent_id });

        my @created_loans;
        foreach my $loan ( @$loans ) {

            my $client_interest_rate = $loan->{client_interest_rate} ne '' && $loan->{client_interest_rate} >= 0
                ? $loan->{client_interest_rate}
                : undef
            ;

            my $ClientRS = $Schema->resultset('Client')
                ->find_or_create({ name => $loan->{client_name}, agent_id => $agent_id })
            ;

            $ClientRS->update({ interest_rate => $client_interest_rate }) if defined $client_interest_rate;

            my $LoanRS = $Schema->resultset('Loan')
                ->create({
                    client_id => $ClientRS->id,
                    date_borrowed => $loan->{date_borrowed},
                    amount_borrowed => $loan->{amount_borrowed},
                })
            ;

            push @created_loans, $LoanRS;
        }

        $TXNScopeGuard->commit;

        return @created_loans;

    } catch ( $error ) {
        die ("Failed to create loan on the database: $error");
    }
}

sub find_loans ($self, $agent_id, $client_name, $loan_status ) {

    try {

        my $Schema = $self->db->schema;
        my $TXNScopeGuard = $Schema->txn_scope_guard;

        my @loans = $Schema->resultset('Loan')
            ->by_agent( $agent_id )
            ->by_status( $loan_status )
            ->by_client_name( $client_name )
            ->all
        ;

        $TXNScopeGuard->commit;

        return @loans;

    } catch ( $error ) {
        die "\nFailed to find loans on the database: $error\n";
    }
}

sub get_client_balance ( $class, $agent_id, $client_name ) {

    try {
        my $self = $class->new;
        my $Schema = $self->db->schema;
        my $TXNScopeGuard = $Schema->txn_scope_guard;

        my $ClientBalanceResult = $Schema->resultset('LoanBalance')
            ->by_agent( $agent_id )
            ->by_client_name( $client_name )
            ->single
        ;

        $TXNScopeGuard->commit;

        return $ClientBalanceResult;

    } catch ( $error ) {
        die "\nFailed to get client balance from the database: $error\n";
    };
}

1;