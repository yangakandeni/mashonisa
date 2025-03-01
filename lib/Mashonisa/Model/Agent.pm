package Mashonisa::Model::Agent;

use strict;
use warnings;

use Mouse;
with qw/ Mashonisa::Role::DB /;

use lib 'lib';
use Syntax::Keyword::Try;
use experimental qw/ signatures say /;

has name => (is => 'ro', isa => 'Str');
has clients => (is => 'ro', isa => 'Maybe[Mashonisa::Model::Client]');
has interest_rate => (is => 'ro', isa => 'Mashonisa::Model::InterestRate');

# TODO: These CRUD methods should be able to handle bulk operations
sub add_agent ($self, $agent_name, $interest_rate) {

    try {

        die 'agent_name is required' unless $agent_name;
        die 'interest_rate is required' unless $interest_rate;

        my $Schema = $self->db->schema;
        my $TXNScopeGuard = $Schema->txn_scope_guard;

        # TODO: Ensure interest rate is always stored in decimal form
        # regardless of how it is given e.g. could be given as an integer
        my $InterestRateRS = $Schema->resultset('InterestRate')
            ->find_or_create({ amount => $interest_rate })
        ;

        my $AgentRS = $Schema->resultset('Agent')->create(
            {
                name => $agent_name,
                interest_rate_id => $InterestRateRS->id,
            }
        );

        $TXNScopeGuard->commit;

        return $AgentRS;

    } catch ( $error ) {
        warn sprintf("Failed to add agent - %s - on the database: $error", $agent_name);
        return undef;
    }
}

sub find_agents ($self, $agent_name ) {

    try {

        my $Schema = $self->db->schema;
        my $TXNScopeGuard = $Schema->txn_scope_guard;

        my @agents = $Schema->resultset('Agent')
            ->search_rs({ $agent_name ? ( name => { -like => "%". $agent_name ."%" } ) : () })
            ->all
        ;

        $TXNScopeGuard->commit;

        return @agents;

    } catch ( $error ) {
        warn say("\nFailed to find agents on the database: $error\n");
        return undef;
    }
}

sub update_agent ($self, $old_name, $new_name, $new_interest_rate) {

    try {

        die '$old_name is required' unless $old_name;
        die '$new_name OR $new_interest_rate is required' unless $new_name || $new_interest_rate;

        my $Schema = $self->db->schema;
        my $TXNScopeGuard = $Schema->txn_scope_guard;

        my $AgentRS = $Schema->resultset('Agent')
            ->search_rs({ name => { -like => "%". $old_name ."%" }})
            ->single
        ;

        $AgentRS->update({ name => $new_name }) if $new_name;
        $AgentRS->interest_rate->update({ amount => $new_interest_rate }) if $new_interest_rate;

        $TXNScopeGuard->commit;

        return undef;

    } catch ( $error ) {
        warn sprintf("Failed to add agent - %s - on the database: $error", $old_name);
        return undef;
    }
}

sub delete_agent ($self, $agent_name) {

    try {

        die '$agent_name is required' unless $agent_name;

        my $Schema = $self->db->schema;
        my $TXNScopeGuard = $Schema->txn_scope_guard;

        $Schema->resultset('Agent')
            ->search_rs({ name => { -like => "%". $agent_name ."%" }})
            ->single
            ->delete
        ;

        $TXNScopeGuard->commit;

        return undef;

    } catch ( $error ) {
        warn sprintf("Failed to add agent - %s - on the database: $error", $agent_name);
        return undef;
    }
}

1;