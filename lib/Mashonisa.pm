package Mashonisa;

use strict;
use warnings;

use Mouse;
use lib 'lib';
use experimental qw/ signatures say /;

use Mashonisa::DB;

sub main_menu ($self) {
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

1;