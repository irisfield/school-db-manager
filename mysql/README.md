# MySQL Schema

## Overview

This project includes a SQL schema and queries for a school management system.
The database schema is designed to handle various aspects of a school system
including departments, courses, instructors, students, and related records. The
schema ensures referential integrity with cascading updates and deletions.

## Project Structure

The project directory contains two main files:

- `create-school-db.sql`: This file contains the SQL commands to create and
  populate the database schema.
- `school-db-queries.sql`: This file includes SQL queries for retrieving and
  manipulating data within the database.

### `create-school-db.sql`

This file defines the structure of the `school_management` database and
populates it with sample data. It includes:

- **Tables**:
  - `department`
  - `course`
  - `postal`
  - `current_member`
  - `instructor`
  - `taught_courses`
  - `teaching_interests`
  - `research_interests`
  - `course_section`
  - `student`
  - `student_major`
  - `cheating_incident`
  - `student_involved`
  - `enrolls`
  - `graduate`
  - `employer`
  - `employment_record`

- **Data**:
  - Sample records for the aforementioned tables.

### `school_db_queries.sql`

This file contains various SQL queries for practicing and retrieving data from
the `school_management` database:

- **Simple SELECT Queries**: Retrieve all records or specific records based on
  conditions.
- **Advanced SELECT Queries**:
  - Retrieve students who have cheated and the details of the incidents.
  - Retrieve instructors and their teaching interests.
  - Find students who have only received "A" grades in all their courses.
  - Retrieve students who have not taken more than two courses.

## Setup Instructions

Please follow the instructions listed [here](../README.md#3).
