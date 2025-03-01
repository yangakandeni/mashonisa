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
sub create_loans ($self, $loans, $agent_id, $interest_rate_override) {

    try {

        die '$loans is required' unless @$loans;
        die '$agent_id is required' unless $agent_id;

        my $Schema = $self->db->schema;
        my $TXNScopeGuard = $Schema->txn_scope_guard;

        $Schema->storage->debug;

        my @created_loans;
        foreach my $loan ( @$loans ) {
            my $ClientRS = $Schema->resultset('Client')
                ->find_or_create({ name => $loan->{client_name}, agent_id => $agent_id })
            ;

            my $LoanRS = $Schema->resultset('Loan')
                ->create({
                    client_id => $ClientRS->id,
                    date_borrowed => $loan->{date_borrowed},
                    amount_borrowed => $loan->{amount_borrowed},
                })
            ;

            # TODO: Figure out a way to do this better, maybe via OOP?
            my $LoanBalanceRS = $Schema->resultset('LoanBalance')
                ->find_or_create({ client_id => $ClientRS->id, agent_id => $agent_id  })
            ;

            $LoanBalanceRS->update({
                ( $interest_rate_override ? ( interest_rate_override => $interest_rate_override ) : () ),
                total_amount_borrowed => ( $LoanBalanceRS->total_amount_borrowed + $LoanRS->amount_borrowed ),
            });
            # TODO end

            push @created_loans, $LoanRS;
        }

        my $AgentResult = $Schema->resultset('Agent')->find({ id => $agent_id })
        my $interest_rate = $interest_rate_override ? $interest_rate_override : $Agent->interest_rate->amount;

        # TODO: Figure out a way to do this better, maybe via OOP?
        my $LoanBalanceRS = $Schema->resultset('LoanBalance')
            ->find({ client_id => $ClientRS->id, agent_id => $agent_id  })
        ;

        $LoanBalanceRS->update({
            total_amount_due => ( $LoanBalanceRS->total_amount_borrowed * ( 1 + $interest_rate ) ),
        });
        # TODO end

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

        # $Schema->storage->debug(1);
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

sub get_client_balance ( $self, $agent_id, $client_name ) {

    try {
        my $TXNScopeGuard = $Schema->txn_scope_guard;

        # $Schema->storage->debug(1);
        my $ClientBalanceResult = $Schema->resultset('LoanBalance')
            ->by_agent( $agent_id )
            ->client_name( $client_name )
            ->single
        ;

        $TXNScopeGuard->commit;

        return $ClientBalanceResult;

    } catch ( $error ) {
        die "\nFailed to get client balance from the database: $error\n";
    };
}

1;