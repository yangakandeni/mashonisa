#!/usr/bin/env perl

use strict;
use warnings;
use experimental qw/ say signatures /;

use lib 'lib';
use Mashonisa;

run_app();

sub run_app {

    display_greeting_msg();
    display_select_option_message();
    display_menu_options();

    while (1) {
        my $selection = get_selected_option();
        if ($selection == 1) {
            print "Enter agent name: ";
            chomp(my $name = <STDIN>);
            Mashonisa->add_agent($name);
        }
        # elsif ($selection == 2) { Mashonisa->view_agents(); }
        # elsif ($selection == 3) { Mashonisa->update_agent(); }
        # elsif ($selection == 4) { Mashonisa->delete_agent(); }
        # elsif ($selection == 5) { Mashonisa->add_client(); }
        # elsif ($selection == 6) { Mashonisa->view_clients(); }
        # elsif ($selection == 7) { Mashonisa->update_client(); }
        # elsif ($selection == 8) { Mashonisa->delete_client(); }
        # elsif ($selection == 9) { Mashonisa->add_loan(); }
        # elsif ($selection == 10) { Mashonisa->view_loans(); }
        # elsif ($selection == 11) { Mashonisa->update_loan(); }
        # elsif ($selection == 12) { Mashonisa->delete_loan(); }
        # elsif ($selection == 13) { Mashonisa->add_loan_repayment(); }
        # elsif ($selection == 14) { Mashonisa->view_loan_repayments(); }
        # elsif ($selection == 15) { Mashonisa->update_loan_repayment(); }
        # elsif ($selection == 16) { Mashonisa->delete_loan_repayment(); }
        # elsif ($selection == 17) { Mashonisa->view_active_loans_grouped(); }
        # elsif ($selection == 18) { Mashonisa->view_active_loans_client(); }
        # elsif ($selection == 19) { Mashonisa->view_client_balance(); }
        elsif ($selection == 20) {
            say "Bye!\n";
            last;
        }
        else {
            say "Invalid choice, try again!\n";
        }
    }

}

sub display_greeting_msg {
    say ("*" x 50);
    say uc"\n\tWelcome to the mashonisa app\n";
    say("*" x 50 );
}

sub display_select_option_message {
    say "\nChoose an option from below: ";
}

sub display_menu_options {
    say "\t". Mashonisa->main_menu();
}

sub get_selected_option {
    print "Choose an option: ";
    chomp(my $selection = <STDIN>);
    return $selection;
}


# my $db_file = "mashonisa.db";
# my $dbh = DBI->connect("dbi:SQLite:dbname=$db_file", "", "", { RaiseError => 1, AutoCommit => 1 });

# sub main_menu {
#     print "\nWelcome to Mashonisa!\n";
#     print "1. Add Agent\n";
#     print "2. View Agents\n";
#     print "3. Update Agent\n";
#     print "4. Delete Agent\n";
#     print "5. Add Client\n";
#     print "6. View Clients\n";
#     print "7. Update Client\n";
#     print "8. Delete Client\n";
#     print "9. Add Loan\n";
#     print "10. View Loans\n";
#     print "11. Update Loan\n";
#     print "12. Delete Loan\n";
#     print "13. Add Loan Repayment\n";
#     print "14. View Loan Repayments\n";
#     print "15. Update Loan Repayment\n";
#     print "16. Delete Loan Repayment\n";
#     print "17. View Active Loans (Grouped by Month)\n";
#     print "18. View Active Loans for a Client\n";
#     print "19. View Client Balance\n";
#     print "20. Exit\n";
#     print "Choose an option: ";
#     chomp(my $choice = <STDIN>);
#     return $choice;
# }

# sub add_agent {
#     print "Enter agent name: ";
#     chomp(my $name = <STDIN>);
#     my $sth = $dbh->prepare("INSERT INTO agent (name) VALUES (?)");
#     $sth->execute($name);
#     print "Agent added successfully!\n";
# }

# # sub view_agents {
# #     my $sth = $dbh->prepare("SELECT * FROM agent");
# #     $sth->execute();
# #     while (my $row = $sth->fetchrow_hashref) {
# #         print "ID: $row->{id}, Name: $row->{name}\n";
# #     }
# # }

# # sub update_agent {
# #     print "Enter agent ID to update: ";
# #     chomp(my $id = <STDIN>);
# #     print "Enter new name: ";
# #     chomp(my $name = <STDIN>);
# #     my $sth = $dbh->prepare("UPDATE agent SET name = ? WHERE id = ?");
# #     $sth->execute($name, $id);
# #     print "Agent updated successfully!\n";
# # }

# # sub delete_agent {
# #     print "Enter agent ID to delete: ";
# #     chomp(my $id = <STDIN>);
# #     my $sth = $dbh->prepare("DELETE FROM agent WHERE id = ?");
# #     $sth->execute($id);
# #     print "Agent deleted successfully!\n";
# # }


# while (1) {
#     my $choice = main_menu();
#     if ($choice == 1) { add_agent(); }
#     # elsif ($choice == 2) { view_agents(); }
#     # elsif ($choice == 3) { update_agent(); }
#     # elsif ($choice == 4) { delete_agent(); }
#     # elsif ($choice == 5) { add_client(); }
#     # elsif ($choice == 6) { view_clients(); }
#     # elsif ($choice == 7) { update_client(); }
#     # elsif ($choice == 8) { delete_client(); }
#     # elsif ($choice == 9) { add_loan(); }
#     # elsif ($choice == 10) { view_loans(); }
#     # elsif ($choice == 11) { update_loan(); }
#     # elsif ($choice == 12) { delete_loan(); }
#     # elsif ($choice == 13) { add_loan_repayment(); }
#     # elsif ($choice == 14) { view_loan_repayments(); }
#     # elsif ($choice == 15) { update_loan_repayment(); }
#     # elsif ($choice == 16) { delete_loan_repayment(); }
#     # elsif ($choice == 17) { view_active_loans_grouped(); }
#     # elsif ($choice == 18) { view_active_loans_client(); }
#     # elsif ($choice == 19) { view_client_balance(); }
#     elsif ($choice == 20) {
#         print "Bye!\n";
#         last;
#     }
#     else {
#         print "Invalid choice, try again!\n";
#     }
# }