# POSTGRES CHEAT SHEET
# Everything you need to know

## Views and Materialized Views
- Saving complex queries so we dont have to write them from scratch

### CREATE VIEW view_name AS ...
- Creates a shortcut query. Recalculates everything from scratch on the go every time. Always 100% up to date automatically. 
- Example: `CREATE VIEW calculate_grand_total AS .....`

### CREATE MATERIALIZED VIEW AS ...
- Computes the query results physically and saves them to disk like a normal table. Blazing fast to read, but data becomes stale if you do not update it. 
- Example: `CREATE MATERIALIZED VIEW game_revenue_summary AS ...`

#### REFRESH MATERIALIZED VIEW view_name
- Forces the view to re run its baseline query and pull the freshest data onto the disk
- Example `REFRESH MATERIALIZED VIEW view_name`

### DROP VIEW IF EXISTS view_name CASCADE
- Drops a view. CASCADE is mandatory if other views or parameters depend on it. 
- Example: `DROP VIEW IF EXISTS game_sales_report CASCADE`

## MULTI-DIMENSIONAL AGGREGATIONS
- Used to quickly generate spreadsheet-like symmary reports with built in subtotals and grand totals

### GROUP BY ROLLUP(col1, col2)
- Cares about hierarchy (ordered from left to right). Drops columns one by one from right to left to create one-way subtotals. 
- Example: `SELECT genre, player_country, ... GROUP BY ROLLUP(genre, player_country)`

### GROUP BY CUBE(col1, col2)
- Does not care about order. A free for all cross tabulation that calculates every single mathematical combo possible. 
- Example: `SELECT studio_country, genre, .... GROUP BY CUBE(genre, player_country)`

### COALESCE (column, fallback)
- Used to clean out the ugly ahh NULL values from CUBE and ROLLUP 
- Example: `SELECT COALESCE(genre, 'All genres')`
- NOTE: if a column is of boolean data type, you must cast it to text, so:
- `COALESCE(premium::text, 'All statuses')`

### COALESCE(SUM(column), 0)
- Used inside math functions on a LEFT JOIN to force items with 0 transactions to show 0 instead of NULL
- Example: `COALESCE(SUM(amount_paid), 0)`

## FULL TEXT SEARCH 
- Used for deep text search instead of using the basic LIKE %WORD% matching.

### to_tsvector('english', column name)
- Parses raw body text or descriptions and extracts a searchable vector array of root words
- Example: `to_tsvector('english', review_body)`

### to_tsquery('english', 'search logic')
- Formats your target search keywords into a strict structural criteria format 
- Example: `to_tsquery('english', 'space & shooter')`

### @@, aka the fts match operator
- Evaluates if a text vector matches your query criteria inside WHERE clause

### ts_rank(vector, query)
- Calculates dynamic relevance score integer based on how frequently or prominently search terms appear in text.
- Used heavily in SELECT and ORDER BY 

### MULTI WORD QUERY CONNECTORS
- & (and) - both terms must exist
- | (or) - either term can exist
- <-> - words must be exactly next to each other in that exact sequence