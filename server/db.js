const mysql = require('mysql2');
require('dotenv').config();

// Function to validate required environment variables
function validateEnvVariables() {
  const requiredVars = ['DB_HOST', 'DB_USER', 'DB_NAME', 'DB_PASSWORD'];
  const missingVars = requiredVars.filter(varName => !process.env[varName]);

  if (missingVars.length > 0) {
    console.error('Missing environment variables:');
    missingVars.forEach(varName => console.error(`- ${varName}`));
    console.error('\nPlease make sure you have an .env file in the root directory with these variables set.');
    console.error(`Project root directory: ${process.cwd()}`);
    console.error('\nYour .env should look like this:');
    console.error('DB_HOST="<your_db_host>"');
    console.error('DB_USER="<your_db_user>"');
    console.error('DB_NAME="<your_db_name>"');
    console.error('DB_PASSWORD="<your_db_password>"\n');
    // Exit the process with an error code
    process.exit(1);
  }
}

// Validate environment variables
validateEnvVariables();

// Configuration for the MySQL connection pool
const poolConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD
};

// Create a MySQL connection pool
const pool = mysql.createPool(poolConfig);

// Function to test the database connection
async function testConnection() {
  try {
    // Get a connection from the pool
    const connection = await pool.promise().getConnection();
    console.log('Database connection successful!');
    console.log(`Connected as ${poolConfig.user} to ${poolConfig.database}.`);
    // Release the connection back to the pool
    connection.release();
  } catch (err) {
    console.error('Database connection failed:\n', err.message);
  }
}

// Run the connection test
testConnection();

// Export the pool for use in other parts of the application
module.exports = pool.promise();
