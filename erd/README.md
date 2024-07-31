# Schema Design

## Overview

This project includes ER diagrams for the database schema, showing both the
original design and its BCNF decomposition. The diagrams are available in two
formats: `.erdplus` and `.png`.

## ER Diagram

The `school-db-erd.png` file contains the Entity-Relationship (ER) diagram of
the database schema for this project. This diagram provides a visual
representation of the database structure, including the entities, their
attributes, and the relationships between them. It helps to illustrate how
different parts of the database are interconnected.

### Key Components

- **Entities**: Represented as rectangles, these are the objects or concepts
  about which data is collected.
- **Attributes**: Represented as ovals, these are the data fields associated
  with each entity.
- **Relationships**: Represented as diamonds, these describe how entities are
  related to one another.
- **Primary Keys**: Attributes or sets of attributes that uniquely identify an
  instance of an entity.
- **Foreign Keys**: Attributes that create a link between entities.

## BCNF Decomposition

The `school-db-erd-bcnf.png` file shows the ER diagram decomposed into
Boyce-Codd Normal Form (BCNF). BCNF is a stricter version of the Third Normal
Form (3NF) and aims to eliminate redundancy and ensure that every determinant is
a candidate key.

### BCNF Decomposition Details

- **Normalization Process**: The process of decomposing the original schema into
  BCNF involves ensuring that for every functional dependency `X → Y`, the
  attribute set `X` is a superkey.
- **Decomposition Goals**: The goal is to decompose relations into smaller,
  well-structured relations that minimize redundancy and potential anomalies.

## How to Use This Documentation

1. **ER Diagram**: Refer to the `school-db-erd.png` file to understand the
   original schema design and relationships.
2. **BCNF Diagram**: Use the `school-db-erd-bcnf.png` file to review the
   normalized schema and understand how the original design was improved.
3. **ERDPlus Files**: Use the `.erdplus` files with
   [ERDPlus](https://erdplus.com/) to modify the diagrams.
