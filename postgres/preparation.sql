# TASK 1
# for every game, show its studio name, title, genre and total revenue (sum of amount_paid from purchases)
# include games that have never been purchased
# their revenue should show as 0, not be dropped
# order by studio name, then by revenue (highest first)

SELECT 
    s.name AS studio_name,
    g.title,
    g.genre,
    COALESCE(SUM(p.amount_paid), 0) AS total_revenue
FROM studios s
JOIN games g on s.studio_id = g.studio_id
LEFT JOIN purchases p on g.game_id = p.game_id
GROUP BY s.name, g.title, g.genre
ORDER BY s.name ASC, total_revenue DESC

----------------------------------------------------------------------------------------------------------------

# TASK 2
# search the review body text for reviews that mention both space and shooter
# for each match, return the game title, rating, a relevance rank, and the review body
# order by relevance, most relevant first

SELECT
    g.title,
    g.rating,
    ts_rank(to_tsvector('english', r.body), to_tsquery('english', 'space & shoooter')) AS relevance,
    r.body
FROM games g
JOIN reviews r ON g.game_id = r.game_id
WHERE to_tsvector('english', r.body) @@ to_tsquery('english', 'space $ shooter')
ORDER BY relevance DESC;

----------------------------------------------------------------------------------------------------------------

# TASK 3
# using the game_sales_report view, report the total revenue broken down by genre and by genre + player_country
# include a subtotal for each genre and a grand total
# order so that genre subtotals and the grand total appear in a readable position
# group rows by genre, subtotal / total rows within their group

SELECT 
    COALESCE(genre, "All Genres") as genre,
    COALESCE(player_country, "All countries") AS player_country,
    SUM(amount_paid) AS total_revenue
FROM game_sales_report
GROUP BY ROLLUP(genre, player_country)
ORDER BY genre, player_country;

----------------------------------------------------------------------------------------------------------------

# TASK 4
# using the same view again, produce a full cross tabulation of total revenue across studio country and premium stauts
# we want every combination, the subtotals for each studio_country alone, the subtotals for premium values alone and the grand total

SELECT 
    COALESCE(studio_country, "All countries") AS studio_country,
    COALESCE(premium::text, "All statuses") AS premium_status,
    SUM(amount_paid) AS total_revenue
FROM game_sales_report
GROUP BY CUBE(studio_country, premium)
ORDER BY studio_country, premium