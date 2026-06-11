# SCENARIO 1
# a new web dashboard is being built for libarians who should not see all details from the books table
# instructions: 
# a) create a view named available_books that shows only title, author and available copies
# b) create another view named recent_books showing title, category, and year published for books published after 2020
# c) query both views
# d) attempt to update the number of available copies using the available books view

CREATE VIEW available_books AS 
SELECT title, author, available_copies 
FROM books;

CREATE VIEW recent_books AS 
SELECT title, category, year_published 
FROM books
WHERE year_published > 2020; 

SELECT * FROM available_books;
SELECT * FROM recent_books; 

UPDATE recent_books
SET available_copies = 20
WHERE title = "Some book";

------------------------------------------------------------------------------------------------------------------------

# SCENARIO 2
# the library manager requires a frequent report on the total number of books and the average number of available copies per category
# since this data is analyzed frequently but does not change by second, a materialized view is perfect
# instructions:
# a) create a materialized view named category_summary that calculates the total number of books and the average available_copies grouped by category
# b) query the view
# c) insert a new book into the base table and query again, see what happens
# d) refresh the view and verify the update

CREATE MATERIALIZED VIEW category_summary AS
SELECT category, COUNT(*) as total_books, ROUND(AVG(available_copies), 2) AS average_copies
FROM books 
GROUP BY category; 

SELECT * FROM category_summary;

INSERT INTO books (title, author, category, available_copies)
VALUES ("sql mastery", "merjem alic", "technology", 10);

SELECT * FROM category_summary;

REFRESH MATERIALIZED VIEW category_summary;

SELECT * FROM category_summary;

------------------------------------------------------------------------------------------------------------------------

# SCENARIO 3
# the libary collects user reviews of books.
# implement a search feature that allows librarioans to find books based on what the readers wrote
# to do:
# a) create a table named reviews with the following columns:

CREATE TABLE reviews (
  review_id   SERIAL PRIMARY KEY,
  book_title  VARCHAR(100) NOT NULL,
  review_text TEXT         NOT NULL
);

# b) insert at least 6 reviews that include words like boring, fascinating, educational, slow-paced, inspiring

INSERT INTO reviews (book_title, review_text) VALUES
('Deep Work',            'Inspiring and focused; highly educational for building long attention.'),
('Sapiens',              'Fascinating narrative, occasionally slow-paced but very insightful.'),
('Meditations',          'Timeless and practical; not boring at all for a philosophy classic.'),
('Clean Architecture',   'Educational and rigorous; design guidance is sometimes dense.'),
('The Pragmatic Programmer','Inspiring, hands-on, occasionally repetitive but rewarding.'),
('Project Hail Mary',    'Fast-paced and exciting; a captivating read that makes science fun.');

# c) write a query that returns all reviews containing both educational and inspiring
# d) write another query that finds reviews containing both boring or slow

SELECT title, description
FROM books
WHERE ts_tovector('english', body) @@ ts_toquery('english', 'educational & inspiring');

SELECT title, description
FROM books
WHERE to_tsvector('english', body) @@ to_tstoquery('english', 'boring | slow');

------------------------------------------------------------------------------------------------------------------------

# SCENARIO 4
# now your library is selling merch online. management wants to see total revenue across different dimensions.
# to do:
# a) create a table named sales with columns:

CREATE TABLE sales (
  sale_id       SERIAL PRIMARY KEY,
  month         VARCHAR(15)  NOT NULL,
  product_type  VARCHAR(30)  NOT NULL, 
  region        VARCHAR(50)  NOT NULL, 
  revenue       NUMERIC(10,2) NOT NULL CHECK (revenue >= 0)
);

# b) insert at least 12 records covering multiple months, regions and product types

INSERT INTO sales (month, product_type, region, revenue) VALUES
('2025-05', 'Mugs',      'Europe',   1450.00),
('2025-05', 'Bookmarks', 'Europe',    520.00),
('2025-05', 'T-shirts',  'Europe',   2100.00),
('2025-05', 'Mugs',      'America',  1880.50),
('2025-05', 'Bookmarks', 'America',   460.00),
('2025-06', 'Mugs',      'Asia',     1210.00),
('2025-06', 'T-shirts',  'Asia',     1765.25),
('2025-06', 'Bookmarks', 'Asia',      390.00),
('2025-06', 'Mugs',      'Europe',   1605.75),
('2025-06', 'T-shirts',  'America',  2322.10),
('2025-07', 'Bookmarks', 'Europe',    610.00),
('2025-07', 'T-shirts',  'Asia',     1945.40),
('2025-07', 'Mugs',      'America',  1722.30),
('2025-07', 'Bookmarks', 'America',   510.00);

# c) write a query to calculate total revenue at all levels 
# d) replace null values in results with meaningful labels
# e) identify which month had the highest total sales across all regions

SELECT month, product_type, region, SUM(revenue) AS total_revenue
FROM sales
GROUP BY ROLLUP(month, product_type, region)

SELECT month, product_type, region, SUM(revenue) AS total_revenue
FROM sales
GROUP BY CUBE (month, product_type, region);
