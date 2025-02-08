# Mashonisa - Perl Loan Management Application

Welcome to Mashonisa, a user-friendly Perl application designed to streamline the process of managing agents, clients, loans, and loan repayments.
This application provides a robust interface for seamless CRUD operations and detailed loan information access.

## Features

### 1. Welcome and Menu:

* Users are warmly welcomed to the Mashonisa application.
* A menu of available actions is presented, providing an intuitive starting point.

### 2. Agent Management:

* Users can Create, Read, Update, and Delete (CRUD) agent details efficiently.

### 3. Client Management:

* Users can CRUD client information with ease, ensuring all client data is accurate and up-to-date.

### 4. Loan Management:

* Users can CRUD loan details for clients, supporting multiple loans per client.
* Enter loan details either during client creation or at any point in the future.

### 5. Loan Repayment Management:

* Users can CRUD loan repayment details for clients, keeping track of payments accurately.

### 6. Comprehensive Loan Details:

* Retrieve all "active" loan details for all clients, grouped by client and by month (e.g., "JANUARY 2025 LOANS").
* Access specific "active" loan details for individual clients.

### 7. Client Financial Overview:

* View detailed information on how much a specific client owes and how much they have paid so far.

### 8. Graceful Exit:

* Users can exit the application gracefully, with a confirmation message (e.g., "Bye").


## Installation and Usage
### To get started with Mashonisa, follow these steps:

   ```bash
    # Clone the repository
    git clone https://github.com/your-username/mashonisa.git

    # Navigate to the project directory
    cd mashonisa

    # Install dependencies
    carton install

    # Run the application
    perl mashonisa.pl
   ```
## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
