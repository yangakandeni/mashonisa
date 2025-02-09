#!/usr/bin/env perl

use lib 'lib';
use Test::Most;

use_ok('Mashonisa');

no warnings;
*Mashonisa::DB::database_file = sub { './test.db' };
use warnings;

isa_ok( my $Mashonisa = Mashonisa->new, 'Mashonisa' );

eq_or_diff_text
    $Mashonisa->main_menu(),
    menu_options(),
    'Got expected menu options'
;

subtest 'CRUD - agent' => sub {

    subtest 'add new agent' => sub {
        is $Mashonisa->add_agent('Agent1'), 1, "Agent added successfully!";
    };
};

done_testing;

sub menu_options {

    return qq/
    1. Add Agent
    2. View Agents
    3. Update Agent
    4. Delete Agent
    5. Add Client
    6. View Clients
    7. Update Client
    8. Delete Client
    9. Add Loan
    10. View Loans
    11. Update Loan
    12. Delete Loan
    13. Add Loan Repayment
    14. View Loan Repayments
    15. Update Loan Repayment
    16. Delete Loan Repayment
    17. View Active Loans (Grouped by Month)
    18. View Active Loans for a Client
    19. View Client Balance
    20. Exit
    /;
}