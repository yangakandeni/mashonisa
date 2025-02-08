#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/ say signatures /;

use DBI;

# Define database connection parameters
my $driver = "SQLite";
my $database = "mashonisa.db";
my $dsn = "DBI:$driver:dbname=$database";

# Connect to the database without username/password for SQLite
my $dbh = DBI->connect($dsn, "", "", { RaiseError => 1 }) or die $DBI::errstr;

say "Opened database successfully";

# setup database schema
create_agent_table($dbh);
create_client_table($dbh);
create_loan_table($dbh);
create_loan_repayment_table($dbh);

# setup triggers
calculate_amount_due_with_interest_sql_trigger($dbh);
update_loan_status_sql_trigger($dbh);
# prevent_overpayment_sql_trigger($dbh);


$dbh->disconnect();
say "Database connection closed.";

sub create_agent_table ($dbh) {

    $dbh->do("DROP TABLE IF EXISTS agent");

    my $stmt_agent = qq(
        CREATE TABLE agent (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
        )
    );

    $dbh->do($stmt_agent);
}

sub create_client_table ($dbh) {

    $dbh->do("DROP TABLE IF EXISTS client");

    my $stmt_client = qq(
        CREATE TABLE client (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            agent_id INTEGER,
            name TEXT NOT NULL UNIQUE,
            created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (agent_id) REFERENCES agent(id)
        )
    );

    $dbh->do($stmt_client);
}

sub create_loan_table ($dbh) {

    $dbh->do("DROP TABLE IF EXISTS loan");

    my $stmt_loan = qq(
        CREATE TABLE loan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            client_id INTEGER,
            amount_borrowed REAL NOT NULL,
            date_borrowed DATE NOT NULL DEFAULT CURRENT_DATE,
            amount_due REAL DEFAULT 0, -- amount_borrowed * interest_rate
            interest_rate REAL DEFAULT 1.4, -- Percentage as a decimal (e.g., 5% = 0.05)
            loan_status TEXT DEFAULT 'active' CHECK (loan_status IN ('active', 'paid')),
            created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (client_id) REFERENCES client(id)
        )
    );

    $dbh->do($stmt_loan);
}

sub create_loan_repayment_table ($dbh) {

    $dbh->do("DROP TABLE IF EXISTS loan_repayment");

    my $stmt_loan_repayment = qq(
        CREATE TABLE loan_repayment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            client_id INTEGER,
            amount_paid REAL NOT NULL,
            payment_date DATE DEFAULT CURRENT_DATE,
            created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (client_id) REFERENCES client(id)
        )
    );

    $dbh->do($stmt_loan_repayment);
}

sub calculate_amount_due_with_interest_sql_trigger ($dbh) {

    my $stmt_amount_due_trigger = qq(
        CREATE TRIGGER IF NOT EXISTS amount_due
        AFTER INSERT ON loan
        BEGIN
            UPDATE loan
            SET amount_due = NEW.amount_borrowed * (1 + NEW.interest_rate)
            WHERE id = NEW.id;
        END;
    );

    $dbh->do($stmt_amount_due_trigger);
}

sub update_loan_status_sql_trigger ($dbh) {

    my $stmt_update_loan_status_trigger = qq(
        CREATE TRIGGER IF NOT EXISTS update_loan_status
        AFTER INSERT ON loan_repayment
        BEGIN
            -- Check if the total repayments for the loan equal the current balance
            IF (SELECT SUM(amount_paid) FROM loan_repayment WHERE client_id = NEW.client_id) >= (SELECT sum(amount_due) FROM loan WHERE client_id = NEW.client_id) THEN
                UPDATE loan
                SET loan_status = 'paid'
                WHERE client_id = NEW.client_id;
            END IF;
        END;
    );

    $dbh->do($stmt_update_loan_status_trigger);
}

sub prevent_overpayment_sql_trigger ($dbh) {

    my $stmt_prevent_overpayment_trigger = qq(
        CREATE TRIGGER IF NOT EXISTS prevent_overpayment
        BEFORE INSERT ON loan_repayment
        BEGIN
            -- Check if the payment would result in overpayment
            IF (SELECT SUM(amount_paid) FROM loan_repayment WHERE client_id = NEW.client_id) > (SELECT sum(amount_due) FROM loan WHERE client_id = NEW.client_id) THEN
                -- Raise an exception to prevent the insertion
                RAISE(FAIL, 'Payment exceeds the total amount due.');
            END IF;
        END;
    );

    $dbh->do($stmt_prevent_overpayment_trigger);
}
