# School Management Database

This project offers a web interface for interacting with a MySQL database,
allowing users to view tables, execute queries, and update or delete records
through a user-friendly web interface. Originally developed as part of my Database Systems class, where I focused on the conceptual design. I extended it beyond the course requirements to further explore the interaction between servers, clients, and Database Management Systems (DBMS) in web environments for learning purposes.

## Prerequisites

1. **Node.js**: Ensure you have Node.js installed. You can download it from
   [nodejs.org](https://nodejs.org/).

2. **MySQL**: Make sure MySQL is installed and running on your machine. You can
   download it from [mysql.com](https://dev.mysql.com/downloads/mysql/).

## Project Setup

### 1. Clone the Repository

Clone this repository to your local machine:

```zsh
git clone https://github.com/irisfield/school-db-manager.git
cd school-db-manager
```

### 2. Install Dependencies

Navigate to the project root directory and install the necessary Node.js
dependencies:

```zsh
npm install
```

### 3. Setup the Database<a id='3'></a>


#### 3.1 Import the Database Schema and Data<a id='3.1'></a>

**On Linux/macOS:**

1. Open a terminal.
2. Navigate to the project root directory (`../school-db-manager`).
3. Import the SQL file:

    ```zsh
    mysql -u root -p < mysql/school_db.sql
    ```

   If you already have a user, replace `root` with your MySQL username. Enter
   your password when prompted.

**On Windows:**

1. Open PowerShell (`powershell.exe`).
2. Navigate to the project root directory (`..\school-db-manager`).
3. Import the SQL file:

    ```powershell
    cmd.exe /c "mysql.exe -u root -p < mysql\create-school-db.sql"
    ```

   If you already have a user, replace `root` with your MySQL username. Enter
   your password when prompted.

   **Note**: You may need to add the the MySQL Server binaries to your PATH.

   If the `mysql.exe` command is not found, add it to your PATH (`$env:PATH`) by
   running:

   ```powershell
   $mysqlPath = "${env:ProgramFiles}\MySQL\MySQL Server 9.0\bin"
   if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force | Out-Null }
   Add-Content -Path $PROFILE -Value "`$env:PATH += `";$mysqlPath`""
   & $PROFILE # reload profile
   ```

   Ensure `$mysqlPath` points to the directory where your MySQL Server `bin`
   folder is located.

### 4. Configure Environment Variables<a id='4'></a>

Ensure that you have a `.env` file in the project root directory. This file
should contain the following environment variables:

```
DB_HOST=localhost
DB_USER=root
DB_NAME=school_management
DB_PASSWORD=<your_password>
```

The `DB_USER` and `DB_PASSWORD` should match the credentials you used when
importing the database schema and data in [step 3.1](#3.1).

### 5. Run the Server

**On Linux/macOS:**

1. Make sure the MySQL service/daemon is running on your machine.
2. Navigate to the project root directory.
3. Start the server and client concurrently:

    ```zsh
    npm run dev
    ```

**On Windows:**

1. Make sure the MySQL Server service is running on your machine.
2. Navigate to the project root directory.
3. Start the server:

    ```zsh
    npm run dev
    ```

The server will start and listen on `http://localhost:3000`.

### 6. Access the Web Interface

Open your web browser and navigate to:

```
http://localhost:3000
```

You should see the web interface where you can:

- **Select a table** from the dropdown menu to view its contents.
- **Execute SQL queries** to retrieve specific data from the database.
- **Update or delete records** using the provided form.

## Troubleshooting

- **Database Connection Issues**: Ensure that your MySQL server is running and
  the credentials in your `.env` file are correct.
- **Missing `.env` File**: If the `.env` file is not found, create one in the
  project root directory (`../school-db-mananger/.env`) and continue from [step 4](#4).
