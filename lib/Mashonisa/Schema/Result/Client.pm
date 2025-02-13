package Mashonisa::Schema::Result::Client;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('InflateColumn::DateTime', 'ResultSet::HashRef');

__PACKAGE__->table('client');

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0,
    },
    agent_id => {
        data_type => 'integer',
        is_nullable => 0,
        is_foreign_key => 1,
    },
    name => {
        data_type => 'text',
        is_nullable => 0,
        is_unique => 1,
    },
    created_at => {
        type => 'datetime',
        default_value => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['name']);

__PACKAGE__->has_many(
    'loans' => 'Mashonisa::Schema::Result::Loan',
    { 'foreign.client_id' => 'self.id' },
);

__PACKAGE__->belongs_to(
    'agent' => 'Mashonisa::Schema::Result::Agent',
    { 'foreign.id' => 'self.agent_id' },
);

1;
