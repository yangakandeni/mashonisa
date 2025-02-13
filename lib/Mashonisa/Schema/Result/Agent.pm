package Mashonisa::Schema::Result::Agent;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('InflateColumn::DateTime', 'ResultSet::HashRef');

__PACKAGE__->table('agent');

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0,
    },
    name => {
        data_type => 'text',
        is_nullable => 0,
        is_unique => 1,
    },
    interest_rate_id => {
        data_type => 'integer',
        is_foreign_key => 1,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['name']);

__PACKAGE__->has_one(
    'interest_rate' => 'Mashonisa::Schema::Result::InterestRate',
    { 'foreign.id' => 'self.interest_rate_id' },
);

__PACKAGE__->has_many(
    'clients' => 'Mashonisa::Schema::Result::Client',
    { 'foreign.agent_id' => 'self.id' },
);

1;
