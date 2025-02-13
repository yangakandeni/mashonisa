package Mashonisa::Schema::Result::Loan;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components('InflateColumn::DateTime', 'ResultSet::HashRef');

__PACKAGE__->table('loan');

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0,
    },
    client_id => {
        data_type => 'integer',
        is_nullable => 0,
        is_foreign_key => 1,
    },
    amount_borrowed => {
        data_type => 'decimal',
        is_nullable => 0,
        is_numeric => 1,
        size => [ 9, 2 ],
    },
    loan_status => {
        data_type =>'text',
        default_value =>'active',
        extra => { check => "loan_status IN ('active', 'paid')" },
    },
    date_borrowed => {
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
    'client' => 'Mashonisa::Schema::Result::Client',
    { 'foreign.id' => 'self.client_id' },
);

__PACKAGE__->has_many(
    'loan_repayments' => 'Mashonisa::Schema::Result::LoanRepayment',
    { 'foreign.loan_id' => 'self.id' },
);

1;
