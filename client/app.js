document.addEventListener('DOMContentLoaded', () => {
  const queryForm = document.getElementById('query-form');
  const updateForm = document.getElementById('update-form');
  const deleteForm = document.getElementById('delete-form');
  const tabButtons = document.querySelectorAll('.tab-button');
  const tabContents = document.querySelectorAll('.tab-content');
  const dataContainer = document.getElementById('data-container');
  const valueInputQuery = document.getElementById('value-input-query');
  const valueInputUpdate = document.getElementById('value-input-update');
  const tableSelectQuery = document.getElementById('table-select-query');
  const tableSelectUpdate = document.getElementById('table-select-update');
  const tableSelectDelete = document.getElementById('table-select-delete');
  const valueSelectUpdate = document.getElementById('value-select-update');
  const valueSelectDelete = document.getElementById('value-select-delete');
  const columnSelectUpdate = document.getElementById('column-select-update');
  const columnSelectDelete = document.getElementById('column-select-delete');

  // Fetch tables from the server
  function fetchTables() {
    fetch('http://localhost:3000/tables')
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then(tables => populateTableDropdowns(tables))
      .catch(error => {
        dataContainer.innerHTML = `<p class="error">Error fetching tables: ${error.message}</p>`;
        console.error('Error fetching tables:', error);
      });
  }

  // Populate table dropdowns
  function populateTableDropdowns(tables) {
    const allSelects = [tableSelectQuery, tableSelectUpdate, tableSelectDelete];
    allSelects.forEach(select => {
      // Clear previous options
      select.innerHTML = '<option value="">Select a table</option>';
      tables.forEach(table => {
        const option = document.createElement('option');
        option.value = table.name;
        option.textContent = table.name;
        select.appendChild(option.cloneNode(true));
      });
    });
  }

  // Fetch columns and update dropdowns
  function fetchColumns(table, tabType) {
    // Do not make a fetch request if table is not selected
    if (!table) return;

    fetch(`http://localhost:3000/columns/${table}`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then(columns => {
        if (tabType === 'update') {
          populateColumnDropdown(columnSelectUpdate, valueSelectUpdate, table, columns);
          columnSelectUpdate.disabled = false;
        } else if (tabType === 'delete') {
          populateColumnDropdown(columnSelectDelete, valueSelectDelete, table, columns);
          columnSelectDelete.disabled = false;
        }
        // Refresh table contents
        fetchTableContents(table);
      })
      .catch(error => {
        if (tabType === 'update') {
          columnSelectUpdate.innerHTML = `<option value="">Error fetching columns</option>`;
        } else if (tabType === 'delete') {
          columnSelectDelete.innerHTML = `<option value="">Error fetching columns</option>`;
        }
        console.error('Error fetching columns:', error);
      });
  }

  // Populate column dropdown
  function populateColumnDropdown(columnSelectX, valueSelectX, table, columns) {
    // Clear previous options
    columnSelectX.innerHTML = '';
    columns.forEach((column, index) => {
      const option = document.createElement('option');
      option.value = column;
      option.textContent = column;
      if (index === 0) {
        // Automatically select the first column
        option.selected = true;
        // Fetch table contents with highlighted first column
        fetchTableContents(table, column);
        // Fetch values for the selected column
        fetchValues(valueSelectX, table, column);
      }
      columnSelectX.appendChild(option);
    });
    // Enable column dropdown
    columnSelectX.disabled = false;
  }

  // Fetch table contents with optional highlight for selected column
  function fetchTableContents(table, highlightColumn = null) {
    // Do not make a fetch request if table is not selected
    if (!table) return;

    fetch(`http://localhost:3000/table/${table}`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        dataContainer.innerHTML = createTableHTML(data, highlightColumn);
        document.querySelectorAll('.error').forEach(error => error.remove());
      })
      .catch(error => {
        dataContainer.innerHTML = `<p class="error">Error fetching table data: ${error.message}</p>`;
        console.error('Error fetching table data:', error);
      });
  }

  // Handle table selection for querying
  tableSelectQuery.addEventListener('change', event => {
    const table = event.target.value;
    fetchTableContents(table);
  });

  // Handle table selection for updating
  tableSelectUpdate.addEventListener('change', event => {
    const table = event.target.value;
    // Fetch columns when table is selected
    fetchColumns(table, 'update');
  });

  // Handle table selection for deleting
  tableSelectDelete.addEventListener('change', event => {
    const table = event.target.value;
    // Fetch columns when table is selected
    fetchColumns(table, 'delete');
  });

  // Handle column selection for updating
  columnSelectUpdate.addEventListener('change', event => {
    const table = tableSelectUpdate.value;
    const column = event.target.value;
    // Fetch table contents and highlight selected column
    fetchTableContents(table, column);
    // Fetch values for the selected column
    fetchValues(valueSelectUpdate, table, column);
  });

  // Fetch distinct values for the selected column
  function fetchValues(valueSelectX, table, column) {
    // Do not make a fetch request if a field is empty
    if (!table || !column) return;

    fetch(`http://localhost:3000/values/${table}/${column}`)
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then(values => {
        populateValueDropdown(valueSelectX, values);
      })
      .catch(error => {
        valueSelectX.innerHTML = `<option value="">Error fetching values</option>`;
        console.error('Error fetching values:', error);
      });
  }

  // Populate value dropdown
  function populateValueDropdown(valueSelectX, values) {
    // Clear previous options
    valueSelectX.innerHTML = '';
    values.forEach(value => {
      const option = document.createElement('option');
      option.value = value;
      option.textContent = value;
      valueSelectX.appendChild(option);
    });
    // Enable value dropdown
    valueSelectX.disabled = false;
  }

  // Handle form submissions
  queryForm.addEventListener('submit', event => {
    event.preventDefault();
    const table = tableSelectQuery.value;
    const query = valueInputQuery.value;

    // Do not make a fetch request if a field is empty
    if (!table || !query ) return;

    fetch('http://localhost:3000/query', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ table, query })
    })
    .then(response => {
      if (!response.ok) {
        return response.json().then(error => { throw new Error(error.error); });
      }
      return response.json();
    })
    .then(result => {
      dataContainer.innerHTML = createTableHTML(result);
      document.querySelectorAll('.error').forEach(error => error.remove());
    })
    .catch(error => {
      document.querySelectorAll('.error').forEach(error => error.remove());
      const errorHTML = `<p class="error">${error.message}</p>`;
      dataContainer.innerHTML = errorHTML + dataContainer.innerHTML;
    });
  });

  // Handle update form submission
  updateForm.addEventListener('submit', event => {
    event.preventDefault();
    const table = tableSelectUpdate.value;
    const column = columnSelectUpdate.value;
    const value = valueSelectUpdate.value;
    const newValue = valueInputUpdate.value;

    // Do not make a fetch request if a field is empty
    if (!table || !column || !value || !newValue ) return;

    fetch(`http://localhost:3000/update/${table}/${column}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ value, newValue })
    })
    .then(response => {
      if (!response.ok) {
        return response.json().then(error => { throw new Error(error.error); });
      }
      return response.json();
    })
    .then(result => {
      // Refresh value dropdown
      fetchValues(valueSelectUpdate, table, column);
      // Refresh table contents
      fetchTableContents(table);
      // Remove previously displayed errors if any
      document.querySelectorAll('.error').forEach(error => error.remove());
    })
    .catch(error => {
      // Remove previously displayed errors if any
      document.querySelectorAll('.error').forEach(error => error.remove());
      const errorHTML = `<p class="error">${error.message}</p>`;
      dataContainer.innerHTML = errorHTML + dataContainer.innerHTML;
    });
  });

  // Handle delete form submission
  deleteForm.addEventListener('submit', event => {
    event.preventDefault();
    const table = tableSelectDelete.value;
    const column = columnSelectDelete.value;
    const value = valueSelectDelete.value;

    // Do not make a fetch request if a field is empty
    if (!table || !column || !value ) return;

    fetch(`http://localhost:3000/delete/${table}/${column}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ value })
    })
    .then(response => {
      if (!response.ok) {
        return response.json().then(error => { throw new Error(error.error); });
      }
      return response.json();
    })
    .then(result => {
      // Refresh value dropdown
      fetchValues(valueSelectDelete, table, column);
      // Refresh table contents
      fetchTableContents(table);
      document.querySelectorAll('.error').forEach(error => error.remove());
    })
    .catch(error => {
      document.querySelectorAll('.error').forEach(error => error.remove());
      const errorHTML = `<p class="error">${error.message}</p>`;
      dataContainer.innerHTML = errorHTML + dataContainer.innerHTML;
    });
  });

  // Create HTML table from JSON data
  function createTableHTML(data, highlightColumn = null) {
    let html = '<table><thead><tr>';
    if (data.length > 0) {
      Object.keys(data[0]).forEach(key => {
        html += `<th>${key}</th>`;
      });
      html += '</tr></thead><tbody>';
      data.forEach(row => {
        html += '<tr>';
        Object.keys(row).forEach(key => {
          html += `<td ${highlightColumn === key ? 'class="highlight"' : ''}>${row[key]}</td>`;
        });
        html += '</tr>';
      });
      html += '</tbody></table>';
    } else {
      html = '<p>No data available.</p>';
    }
    return html;
  }

  // Initialize by fetching the tables and showing the first tab
  fetchTables();
  // Default tab
  showTab('query');

  // Tab switching functionality
  tabButtons.forEach(button => {
    button.addEventListener('click', () => {
      const tabId = button.getAttribute('data-tab');
      showTab(tabId);
    });
  });

  // Function to show tab content based on tabId
  function showTab(tabId) {
    tabButtons.forEach(button => {
      button.classList.toggle('active', button.getAttribute('data-tab') === tabId);
    });

    tabContents.forEach(content => {
      if (content.id === tabId) {
        content.classList.add('active');
        // Clear previous table data when switching tabs
        dataContainer.innerHTML = '';
      } else {
        content.classList.remove('active');
      }
    });

    resetForms();
  }

  // Function to reset form inputs
  function resetForms() {
    queryForm.reset();
    updateForm.reset();
    deleteForm.reset();
    columnSelectUpdate.innerHTML = '<option value="">Select a column</option>';
    columnSelectUpdate.disabled = true; // Initially disabled
    valueSelectUpdate.innerHTML = '<option value="">Select a value</option>';
    valueSelectUpdate.disabled = true; // Initially disabled
    columnSelectDelete.innerHTML = '<option value="">Select a column</option>';
    columnSelectDelete.disabled = true; // Initially disabled
    valueSelectDelete.innerHTML = '<option value="">Select a value</option>';
    valueSelectDelete.disabled = true; // Initially disabled
  }

  // Automatically reset the table when the query text box is cleared
  valueInputQuery.addEventListener('input', () => {
    const selectedTable = tableSelectQuery.value;
    if (selectedTable && valueInputQuery.value === '') {
      // Refresh table contents when query input is cleared
      fetchTableContents(selectedTable);
    }
  });

});
