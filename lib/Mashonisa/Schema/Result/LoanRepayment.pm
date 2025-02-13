package Mashonisa::Schema::Result::LoanRepayment;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('InflateColumn::DateTime', 'ResultSet::HashRef');

__PACKAGE__->table('loan_repayment');

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0,
    },
    loan_id => {
        data_type => 'integer',
        is_nullable => 0,
        is_foreign_key => 1,
    },
    amount_paid => {
        data_type => 'decimal',
        is_nullable => 0,
        is_numeric => 1,
        size => [ 9, 2 ],
    },
    payment_date => {
        type => 'datetime',
        is_nullable => 0,
        default_value => \'CURRENT_DATE',
    },
    created_at => {
        type => 'datetime',
        is_nullable => 0,
        default_value => \'CURRENT_TIMESTAMP',
    },
    updated_at => {
        type => 'datetime',
        is_nullable => 0,
        default_value => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    'loan' => 'Mashonisa::Schema::Result::Loan',
    { 'foreign.id' => 'self.loan_id' },
);

1;
