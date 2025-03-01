package Mashonisa;

use strict;
use warnings;

use Mouse;
with qw/ Mashonisa::Role::DB /;

use lib 'lib';
use Syntax::Keyword::Try;
use experimental qw/ signatures say /;

sub main_menu ($self) {
    return qq/
    01. Add Agents
    02. View Agents
    03. Update Agents
    04. Delete Agents
    05. Add Loans
    06. View Loans
    07. Add Loan Repayments
    08. View Loan Repayments
    20. Exit
    99. Go Back to Main Menu
    /;
    # 11. Update Loan Repayment
    # 12. Delete Loan Repayment
    # 07. Update Loan
    # 08. Delete Loan
    # 5. Add Client
    # 6. View Clients
    # 7. Update Client
    # 8. Delete Client
    # 17. View Active Loans (Grouped by Month)
    # 18. View Active Loans for a Client
    # 19. View Client Balance
}

1;