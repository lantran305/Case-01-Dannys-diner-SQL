# Case Study #1 — Danny's Diner

A PostgreSQL solution for Case Study #1 of the **8 Week SQL Challenge**.

## Project Structure

- `schema.sql`: Creates the `sales`, `menu`, and `members` tables and loads the sample data.
- `solutions.sql`: Contains SQL queries answering the 10 analytical questions in the case study.

## How to Run

Open a terminal in this directory, connect to your PostgreSQL server, and run:

```sh
psql -d your_database -f schema.sql
psql -d your_database -f solutions.sql
```

Replace `your_database` with your database name. Run `schema.sql` before `solutions.sql`.

The data-loading statements use `ON CONFLICT` and checks for existing data to avoid duplicating sample records when the script is rerun.

## Questions Answered

1. How much money has each customer spent in total?
2. How many days has each customer visited the restaurant?
3. What was the first item purchased by each customer?
4. Which item was purchased the most across all transactions?
5. Which item was purchased the most by each customer?
6. What was the first item purchased by each customer after they became a member?
7. Which item was purchased immediately before each customer became a member?
8. How many items and how much money did each customer spend before becoming a member?
9. How many loyalty points did each customer earn by the end of January 2021?
10. How many points did each customer earn by the end of January 2021, applying double points to all items during the first week after becoming a member?

## Notes

- Question 3 uses transaction row order to distinguish purchases made on the same day.
- Question 5 retains all items tied for the highest purchase count.
- For Question 10, the first week includes the membership join date and the following six days.
- The first-week double-points promotion does not stack with the sushi promotion. Each item is awarded points only once at the applicable 2x rate.
