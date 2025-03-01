#!/usr/bin/env perl

use strict;
use warnings;
use Syntax::Keyword::Try;
use experimental qw/ say signatures /;

use lib 'lib';
use DateTime;
use Mashonisa;
use Mashonisa::Model::Loan;
use Mashonisa::Model::Agent;
use Mashonisa::Model::Client;
use DateTime::Format::Strptime;

run_app();

sub run_app {

    display_greeting_msg();
    display_select_option_message();
    display_menu_options();

    my $MashonisaAgent = Mashonisa::Model::Agent->new;

    while (1) {
        try {
            # TODO: cater for when selection is not numeric.
            my $selection = get_selected_option();
            die "Invalid selection - ". $selection unless $selection && $selection > 0;

            if ($selection == 1) { _create_agent( $MashonisaAgent ) }
            elsif ($selection == 2) { _display_agents( $MashonisaAgent ) }
            elsif ($selection == 3) { _update_agents( $MashonisaAgent ) }
            elsif ($selection == 4) { _delete_agents( $MashonisaAgent ) }
            elsif ($selection == 5) { _create_loans( $MashonisaAgent ) }
            elsif ($selection == 6) { _display_loans( $MashonisaAgent ) }
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
            elsif ( $selection == 99 ) {
                display_menu_options();
            }
            else {
                die "Invalid choice, try again";
            }
        } catch ($error) {
            # TODO: figure out a way to print user friendly errors
            # currently it prints out errors with the line numbers, great for debugging!
            say $error;
        }
    }

}

# TODO: Rename this parameter to $Agent for all subs
sub _create_agent( $MashonisaAgent ) {

    # TODO: handle when no name is given
    print "\nEnter agent name: ";
    chomp(my $name = <STDIN>);

    # TODO: handle when no interest rate is given
    print "\nEnter interest rate: ";
    chomp(my $interest_rate = <STDIN>);
    $interest_rate = _maybe_convert_to_decimal_number( $interest_rate );

    my $AgentRS = $MashonisaAgent->add_agent($name, $interest_rate);

    say "\nSuccessfully added Agent - '". $AgentRS->name ."' - with ". ($AgentRS->interest_rate->amount * 100) ."% interest rate.\n";
}

sub _create_loans( $MashonisaAgent ) {
    # TODO: Figure out a more elegant way to do this
    my $Strptime = _init_strptime(undef);
    my @agents = _prompt_to_find_loan_agents( $MashonisaAgent );

    if ( !@agents ) {
        say "Cannot create loans since there's no agent found.\n";
        return undef;
    }

    my $ChosenLoanAgent = _prompt_to_choose_loan_agent( \@agents );

    my @loans;
    my $client_name;
    my $loan_amount;
    while(1) {

        print "\nEnter the client name: " unless $client_name;
        chomp($client_name = <STDIN>) unless $client_name;

        if ( !$client_name ) {
            say "\nThe client name is required";
            next;
        }

        print "\nEnter the amount borrowed: " unless $loan_amount;
        chomp($loan_amount = <STDIN>) unless $loan_amount;

        if ( !$loan_amount ) {
            say "\nThe loan amount is required";
            next;
        }

        print "\nEnter the date borrowed in (YYYY-MM-DD) format: ";
        chomp(my $date_borrowed = <STDIN>);
        $date_borrowed = DateTime->now->ymd unless $date_borrowed;

        print "\nEnter the client interest rate OR skip to use agent interest rate: ";
        chomp(my $client_interest_rate = <STDIN>);
        $client_interest_rate = _maybe_convert_to_decimal_number( $client_interest_rate ) if $client_interest_rate;

        push @loans, {
            client_name => $client_name,
            date_borrowed => $date_borrowed,
            amount_borrowed => $loan_amount,
            client_interest_rate => $client_interest_rate ne '' ? $client_interest_rate + 0 : '',
        };

        printf("\n%s borrowed R %.2f - DATE: %s\n", ucfirst($client_name), $loan_amount, $date_borrowed);

        # reset loan_amount and client_name
        $loan_amount = '';
        $client_name = '';

        print "\nType q to quit OR add another loan: ";
        chomp(my $exit_code = <STDIN>);

        last if $exit_code && $exit_code eq 'q';
    }

    if ( ! @loans ) {
        say "\nNo loans to create.";
        return undef;
    } else {

        my @loans_created = Mashonisa::Model::Loan
            ->new
            ->create_loans( \@loans, $ChosenLoanAgent->id)
        ;

        say "\nSuccessfully added ". scalar @loans_created ." loans - for agent '". $ChosenLoanAgent->name ."'\n";
    }
}

sub _display_agents( $MashonisaAgent ) {

    print "\nEnter agent name or skip to view all agents: ";
    chomp(my $name = <STDIN>);

    my @agents = $MashonisaAgent->find_agents($name);
    if ( ! @agents ) {
        say "\nNo agents found" . ( $name ? " with name '$name'.\n" : ".\n" );
        return undef;
    }

    foreach my $Agent ( @agents ) {
        say "\nAgent name - ". $Agent->name;
        say "Loan interest rate ". $Agent->interest_rate->amount * 100 ."%.";
    }

    print "\n";
}

sub _display_loans( $MashonisaAgent ) {

    my @agents = _prompt_to_find_loan_agents( $MashonisaAgent );

    if ( !@agents ) {
        say "No loans to display since there are no agents on the database.\n";
        return undef;
    }

    my $ChosenLoanAgent = _prompt_to_choose_loan_agent( \@agents );
    my @active_loans = _prompt_to_find_loans( $ChosenLoanAgent, undef, 'active');

    if ( !@active_loans ) {
        say "\nNo active loans found.\n";
        return undef;
    }

    my %loans_to_display;
    my $Strptime = _init_strptime(undef);

    foreach my $Loan ( @active_loans ) {

        my $DateBorrowedDT = $Strptime->parse_datetime($Loan->date_borrowed);
        my $month_and_year = sprintf "%s %d", $DateBorrowedDT->month_name, $DateBorrowedDT->year;

        push @{ $loans_to_display{ $month_and_year } }, +{
            client_name => $Loan->client->name,
            date_borrowed => $Loan->date_borrowed,
            amount_borrowed => $Loan->amount_borrowed,
        };
    }

    return _format_display( \%loans_to_display, $ChosenLoanAgent->id, $Strptime );

}

# TODO: Refactor duplicate code in _display_agents, _update_agents, _delete_agents
sub _update_agents( $MashonisaAgent ) {

    my @agents = _prompt_to_find_loan_agents( $MashonisaAgent );
    my $ChosenLoanAgent = _prompt_to_choose_loan_agent( \@agents );

    print "\nEnter the NEW name for agent '". $ChosenLoanAgent->name ."' OR skip: ";
    chomp(my $new_name = <STDIN>);

    print "\nChange the current interest rate of '"
        . ( $ChosenLoanAgent->interest_rate->amount * 100 ) ."%'"
        . " for '". $ChosenLoanAgent->name ."' OR skip: "
    ;
    chomp(my $new_interest_rate = <STDIN>);

    $new_interest_rate = _maybe_convert_to_decimal_number($new_interest_rate);
    $MashonisaAgent->update_agent(
        $ChosenLoanAgent->name,
        $new_name,
        $new_interest_rate
    );

    print "\n";
    say "Successfully changed agent name from '". $ChosenLoanAgent->name ."' to - '" . $new_name ."'.\n" if $new_name;
    say "Successfully changed the interest_rate from '"
        . ( $ChosenLoanAgent->interest_rate->amount * 100 )
        ."%' to - '" . ( $new_interest_rate * 100 )
        ."%'.\n"
    if $new_interest_rate;

}

sub _delete_agents( $MashonisaAgent ) {

    my @agents = _prompt_to_find_loan_agents( $MashonisaAgent );
    my $ChosenLoanAgent = _prompt_to_choose_loan_agent( \@agents );

    $MashonisaAgent->delete_agent($ChosenLoanAgent->name);
    say "\nSuccessfully deleted agent '". $ChosenLoanAgent->name ."' from database\n";
}

sub _add_loan_repayments( $AgentModel, $repayment_amount ) {

    my @agents = _prompt_to_find_loan_agents( $AgentModel );
    my $ChosenLoanAgent = _prompt_to_choose_loan_agent( \@agents );

    print "\nEnter the client name: ";
    chomp(my $client_name = <STDIN>);

    die '$client_name is required' unless $client_name;
    my @active_loans = _prompt_to_find_loans( $ChosenLoanAgent, $client_name, 'active');


}

# TODO: Revisit this logic, too many forloops
sub _format_display( $loans, $agent_id, $Strptime ) {

    foreach my $month_and_year ( keys %$loans ) {

        print("\n" ."* " x 23 ."\n");
        printf("\n\t\t" . uc $month_and_year ."\n");
        print("\n" ."* " x 23 ."\n");

        my %loans_per_client;
        foreach my $loan ( @{ $loans->{ $month_and_year } } ) {
            push @{ $loans_per_client{ $loan->{client_name} } }, $loan;
        }

        foreach my $client_name ( keys %loans_per_client ) {

            say "\n\t\t". uc $client_name ."\n";

            my $total_borrowed_amount = 0;
            foreach my $client_loan ( $loans_per_client{ $client_name }->@* ) {

                my $borrowed_amount = $client_loan->{amount_borrowed};
                my $DateBorrowedDT = $Strptime->parse_datetime($client_loan->{date_borrowed});

                printf "Loan\t\t\tR %.2f\n", $borrowed_amount;
                printf "Date\t\t\t%02d %s %d\n", $DateBorrowedDT->day, $DateBorrowedDT->month_name, $DateBorrowedDT->year;
                print "\n";

                $total_borrowed_amount += $borrowed_amount;
            }

            _display_loan_balances( $client_name, $agent_id, $month_and_year  );
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

sub _display_loan_balances ( $client_name, $agent_id, $loan_period ) {

    say "\n". "-" x 44;
    my $Client = Mashonisa::Model::Client->new( name => $client_name );
    my ( $start_date, $end_date ) = _calculate_current_loan_period( $loan_period );
    printf "\nLoan Total\t\tR %.2f\n", $Client->get_total_amount_borrowed( $agent_id, $start_date, $end_date );
    printf "Amount Due\t\tR %.2f %s", $Client->get_total_amount_due( $agent_id, $start_date, $end_date ), "<==";
    say "\n". "-" x 44;

}

sub _calculate_current_loan_period ( $loan_period ) {

    my $Strptime = _init_strptime("%B %Y");
    my $LoanPeriodDT = $Strptime->parse_datetime($loan_period);
    my $end_date = $LoanPeriodDT->clone->set_day( $LoanPeriodDT->month_length );

    return ( $LoanPeriodDT->ymd, $end_date->ymd );
}

sub _maybe_convert_to_decimal_number ($number) {

    try {
        return $number && $number =~ m/(0\.)\d+/ ? $number : $number / 100;
    } catch( $error ) {
        die $error;
    };
}

sub _prompt_to_find_loan_agents( $AgentModel ) {

    # TODO: handle when no name is given
    print "\nEnter agent name: ";
    chomp(my $agent_name = <STDIN>);

    my @agents = $AgentModel->find_agents($agent_name);
    if ( ! @agents ) {
        say "\nNo agents found" . ( $agent_name ? " with name '$agent_name'.\n" : ".\n" );
        return ();
    }

    # FIXME: refactor this please!!!
    say "\nWe found ". scalar @agents ." agents";
    return @agents;
}

sub _prompt_to_find_loans( $ChosenLoanAgent, $client_name, $loan_status ) {

    if ( !$client_name ) {
        print "\nEnter a client name OR skip to display all active loans: ";
        chomp($client_name = <STDIN>);
    }

    my @loans = Mashonisa::Model::Loan
        ->new
        ->find_loans( $ChosenLoanAgent->id, $client_name, $loan_status )
    ;

    return @loans;
}

sub _prompt_to_choose_loan_agent( $agents ) {

    return undef unless @$agents;

    my $count = 1;
    foreach my $Agent ( @$agents ) {
        say "\nAgent ($count) - ". $Agent->name;
        $count++;
    }

    print "\nChoose an agent from above (i.e. enter agent number): ";
    chomp(my $agent_selection = <STDIN>);

    # TODO: Handle invalid number choice
    # also handle when entered a number greater than length of the list
    my $ChosenAgent = $agents->[$agent_selection - 1];

    return $ChosenAgent;

}

sub _init_strptime ($format) { DateTime::Format::Strptime->new(pattern => $format // "%Y-%m-%d") }

1;
