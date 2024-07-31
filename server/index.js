const express = require('express');
const cors = require('cors');
const pool = require('./db'); // MySQL client

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static('client'));

// Execute query
app.post('/query', async (req, res) => {
  const { table, query } = req.body;
  try {
    if (!query) {
    // Query is empty; do not make a fetch request
      return;
    }

    // Basic validation to prevent queries that will result in error
    if (!/^[a-zA-Z0-9_ ,()]*$/.test(query)) {
      throw new Error('Invalid characters in query!');
    }

    // Use parameterized queries to prevent SQL injection
    const [rows] = await pool.query(`SELECT ?? FROM ??`, [query, table]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: err.message });
  }
});

// Get table names
app.get('/tables', async (req, res) => {
  try {
    const [rows] = await pool.query("SHOW TABLES");
    res.json(rows.map(row => ({ name: Object.values(row)[0] })));
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: err.message });
  }
});

// Get table contents
app.get('/table/:name', async (req, res) => {
  const { name } = req.params;
  try {
    // Use parameterized query to prevent SQL injection
    const [rows] = await pool.query('SELECT * FROM ??', [name]);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: err.message });
  }
});

// Update data in the database
app.post('/update/:table/:column', async (req, res) => {
  const { table, column } = req.params;
  const { value, newValue } = req.body;
  try {
    // Start transaction
    await pool.query('BEGIN');
    // Use parameterized query for delete operation;
    // ?? for identifiers and ? for values
    await pool.query('UPDATE ?? SET ?? = ? WHERE ?? = ?', [table, column, newValue, column, value]);
    // Commit transaction
    await pool.query('COMMIT');
    res.status(200).json({ message: 'Data updated successfully!' });
  } catch (err) {
    // Rollback transaction in case of error
    await pool.query('ROLLBACK');
    console.error(err);
    res.status(400).json({ error: err.message });
  }
});

// Get column names from a table
app.get('/columns/:table', async (req, res) => {
  const { table } = req.params;
  try {
    const [rows] = await pool.query('SHOW COLUMNS FROM ??', [table]);
    const columns = rows.map(row => row.Field);
    res.json(columns);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: err.message });
  }
});

// Add route to fetch distinct values for dropdown
app.get('/values/:table/:column', async (req, res) => {
  const { table, column } = req.params;
  try {
    const [rows] = await pool.query('SELECT DISTINCT ?? FROM ??', [column, table]);
    const values = rows.map(row => row[column]);
    res.json(values);
  } catch (err) {
    console.error(err);
    res.status(400).json({ error: err.message });
  }
});

// Delete data in the database
app.post('/delete/:table/:column', async (req, res) => {
  const { table, column } = req.params;
  const { value } = req.body;
  try {
    // Start transaction
    await pool.query('BEGIN');

    // Use parameterized query for delete operation;
    // ?? for identifiers and ? for values
    await pool.query('DELETE FROM ?? WHERE ?? = ?', [table, column, value]);

    // Commit transaction
    await pool.query('COMMIT');
    res.status(200).json({ message: 'Data deleted successfully!' });
  } catch (err) {
    // Rollback transaction in case of error
    await pool.query('ROLLBACK');
    console.error(err);
    res.status(400).json({ error: err.message });
  }
});

const port = 3000;
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
