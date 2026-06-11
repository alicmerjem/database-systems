# VIEW aka a virtual table that consists of a query
# we have both simple views and updateable views

CREATE VIEW student_gpa_view AS 
SELECT first_name, last_name, gpa 
FROM students; 

# and now instead of writing the whole query we can just do this

SELECT * FROM student_gpa_view;

# neat isnt it? 

# now we have an updateable view

CREATE VIEW update_gpa AS
SELECT student_id, gpa 
FROM students;

UPDATE update_gpa 
SET gpa = 3.90
WHERE student_id = 1; 

# or we have a materialized view where we dont need real time updates
CREATE MATERIALIZED VIEW avg_gpa_per_user AS
SELECT program, ROUND(AVG(gpa), 2) AS average_gpa
FROM students
GROUP BY program;

# and to refresh the data after updates just do

REFRESH MATERIALIZED VIEW avg_gpa_per_program; 

# also u can make a view this way as well

CREATE OR REPLACE VIEW student_gpa_view AS 
SELECT firstName, gpa
FROM students; 

----------------------------------------------------------------------------

# ADVANCED TEXT SEARCH 
# BASIC FULL TEXT SEARCH 

SELECT title
FROM articles
WHERE ts_tovector('english', body) @@ ts_toquery('english', 'database & system')

----------------------------------------------------------------------------

# SEARCHING WITH RANKING
# pretty self explainable

SELECT title, 
    ts_rank(ts_tovector('english', body), ts_toquery('english', 'database & systems')) AS rank
FROM articles
WHERE ts_tovector('english', body) @@ ts_toquery('english', 'database & systems')
ORDER BY rank DESC; 

CREATE INDEX idx_articles_fts ON articles USING GIN(search_vector);

----------------------------------------------------------------------------

# CUBE
# this is better than a classical order by because you get a detailed breakdown of all the data
# such as a sub total for each category, plus grand total at the bottom
# instead of running 3/4 separate queries for this paired with a union, you can just use a CUBE
# we do not give a flying fuck about hierarchy or order here

SELECT region, product, SUM(total_amount) AS total
FROM sales
GROUP BY CUBE(region, product)
ORDER BY region, product

----------------------------------------------------------------------------

# also to replace null values, you can ues COALESCE()

SELECT
    COALESCE(region, "All regions") AS regions,
    COALESCE(product, "All products") AS products,
    SUM(total_amount) AS total
FROM sales
GROUP BY CUBE(region, product)
ORDER BY region, product;

----------------------------------------------------------------------------

# ROLLUP 
# this one has actual hierarchy and order
# calculates aggregations from most specific column to the most general one
# very strict, ordered left to right 
# so basically we do not have all combinations here like we have with a cube 

SELECT 
    COALESCE(region, "All regions") AS regions
    COALESCE(product, "All products") AS products
    SUM(total_amount) AS total
FROM sales
GROUP BY ROLLUP(region, product)
ORDER BY region, product; 

----------------------------------------------------------------------------

# IMPORTANT NOTE: BOTH CUBE AND ROLLUP ARE USED ALONGSIDE OF GROUP BY
# do not forget this
# after that we use the order by regulary 

----------------------------------------------------------------------------

