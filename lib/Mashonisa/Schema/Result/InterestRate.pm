package Mashonisa::Schema::Result::InterestRate;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('InflateColumn::DateTime', 'ResultSet::HashRef');

__PACKAGE__->table('interest_rate');

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0,
    },
    amount => {
        data_type => 'decimal',
        is_nullable => 0,
        is_numeric => 1,
        size => [ 9, 2 ],
        default_value => 1.4,
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    'agent' => 'Mashonisa::Schema::Result::Agent',
    { 'foreign.interest_rate_id' => 'self.id' },
);

1;
