#!/usr/bin/env perl

use strict;
use warnings;
use Syntax::Keyword::Try;
use experimental qw/ say signatures /;

use lib 'lib';
use Mashonisa;
use Mashonisa::Model::Agent;

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

sub _display_agents( $MashonisaAgent ) {

    print "\nEnter agent name or skip to view all agents: ";
    chomp(my $name = <STDIN>);

    my @agents = $MashonisaAgent->find_agents($name);
    if ( ! @agents ) {
        say "\nNo agents found" . ( $name ? " with name '$name'.\n" : ".\n" );
        next;
    }

    foreach my $Agent ( @agents ) {
        say "\nAgent name - ". $Agent->name;
        say "Loan interest rate ". $Agent->interest_rate->amount * 100 ."%.";
    }

    print "\n";
}

# TODO: Refactor duplicate code in _display_agents, _update_agents, _delete_agents
sub _update_agents( $MashonisaAgent ) {

    print "\nEnter the name of the agent to UPDATE: ";
    chomp(my $name = <STDIN>);

    my @agents = $MashonisaAgent->find_agents($name);
    if ( ! @agents ) {
        say "\nNo agents found" . ( $name ? " with name '$name'.\n" : ".\n" );
        next;
    }

    say "\nWe found ". scalar @agents ." agents";
    my $count = 1;
    foreach my $Agent ( @agents ) {
        say "\nAgent ($count) - ". $Agent->name;
        $count++;
    }

    print "\nEnter the number for the agent you want to UPDATE: ";
    chomp(my $chosen_agent = <STDIN>);
    # TODO: Handle invalid number choice
    # also handle when entered a number greater than length of the list
    my $ChosenAgent = $agents[$chosen_agent - 1];

    print "\nEnter the NEW name for agent '". $ChosenAgent->name ."' OR skip: ";
    chomp(my $new_name = <STDIN>);

    print "\nChange the current interest rate of '"
        . ( $ChosenAgent->interest_rate->amount * 100 ) ."%'"
        . " for '". $ChosenAgent->name ."' OR skip: "
    ;
    chomp(my $new_interest_rate = <STDIN>);

    $new_interest_rate = _maybe_convert_to_decimal_number($new_interest_rate);
    $MashonisaAgent->update_agent(
        $ChosenAgent->name,
        $new_name,
        $new_interest_rate
    );

    print "\n";
    say "Successfully changed agent name from '". $ChosenAgent->name ."' to - '" . $new_name ."'.\n" if $new_name;
    say "Successfully changed the interest_rate from '"
        . ( $ChosenAgent->interest_rate->amount * 100 )
        ."%' to - '" . ( $new_interest_rate * 100 )
        ."%'.\n"
    if $new_interest_rate;

}

sub _delete_agents( $MashonisaAgent ) {
    print "\nEnter the name of the agent you want to DELETE: ";
    chomp(my $name = <STDIN>);

    my @agents = $MashonisaAgent->find_agents($name);
    if ( ! @agents ) {
        say "\nNo agents found" . ( $name ? " with name '$name'.\n" : ".\n" );
        next;
    }

    say "\nWe found ". scalar @agents ." agents";
    my $count = 1;
    foreach my $Agent ( @agents ) {
        say "\nAgent ($count) - ". $Agent->name;
        $count++;
    }

    print "\nEnter the number for the agent you want to DELETE: ";
    chomp(my $chosen_agent = <STDIN>);
    my $ChosenAgent = $agents[$chosen_agent - 1];

    $MashonisaAgent->delete_agent($ChosenAgent->name);
    say "\nSuccessfully deleted agent '". $ChosenAgent->name ."' from database";
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

sub _maybe_convert_to_decimal_number ($number) {
    try {
       $number && $number =~ m/(0\.)\d+/ ? $number : $number / 100
    } catch( $error ) {
        die $error;
    };
}

1;
