-- Drills
-- In the final checkpoint in this module, you'll complete a challenge. You'll use the ksprojects 
-- table from the kickstarterprojects database in the shared Thinkful server, and you'll write SQL 
-- queries for the following questions.

-- To complete this challenge, you should submit a single text file that contains the SQL query 
-- required for each question. In some cases, you must also provide a specific answer. Plan to spend 
-- some time reviewing your answers with your mentor during your next session.

-- Write a query that returns a list of all the unique values in the 'country' field.
SELECT DISTINCT(country)
FROM ksprojects

-- How many unique values are there for the main_category field? What about for the category field?
SELECT 
	COUNT(DISTINCT(main_category)) AS main_category_count,
	COUNT(DISTINCT(category)) AS category_count
FROM ksprojects

-- Get a list of all the unique combinations of main_category and category fields, sorted A to Z by main_category.
SELECT 
	DISTINCT main_category,
	category
FROM ksprojects
ORDER BY main_category

-- How many unique categories are in each main_category?
SELECT
	main_category,
	COUNT(DISTINCT category)
FROM ksprojects
GROUP BY main_category

-- Write a query that returns the average number of backers per main_category, rounded to the nearest whole number and sorted from high to low.
SELECT
	main_category,
	ROUND(AVG(backers), 0) AS avg_backers
FROM ksprojects
GROUP BY main_category
ORDER BY avg_backers DESC

-- Write a query that shows, for each category, how many campaigns were successful and the average difference per project between dollars pledged and the goal.
SELECT
	category,
	COUNT(*) AS successful,
	AVG(pledged - goal)::integer AS avg_over_goal
FROM ksprojects
WHERE state = 'successful'
GROUP BY category
ORDER BY avg_over_goal DESC

-- Write a query that shows, for each main category, how many projects had zero backers for that category and the largest goal amount for that category (also for projects with zero backers).
SELECT
	main_category,
	COUNT(*) zero_backers,
	MAX(goal)::integer
FROM ksprojects
WHERE backers = 0
GROUP BY main_category

-- For each category, find the average USD per backer, and return only those results for which the average USD per backer is < $50, sorted high to low. Hint: Division by NULL is not possible, so use NULLIF to replace NULLs with 0 in the average calculation.
SELECT
	category,
	ROUND(AVG(usd_pledged::decimal / NULLIF(backers, 0)::decimal), 0) avg_pledged_per_backer
FROM ksprojects
HAVING AVG(usd_pledged / NULLIF(backers, 0)) < 50 
ORDER BY avg_pledged_per_backer DESC

-- Write a query that shows, for each main_category, how many successful projects had between 5 and 10 backers.
SELECT
	main_category,
	SUM(backers) AS n_backers
FROM ksprojects
WHERE state = 'successful'
AND backers BETWEEN 5 and 10
GROUP BY main_category

-- Get a total of the amount ‘pledged’ for each type of currency grouped by its respective currency. Sort by ‘pledged’ from high to low.
SELECT
	SUM(pledged) AS total_pledged,
	currency
FROM ksprojects
GROUP BY currency
ORDER BY total_pledged DESC

-- Excluding Games and Technology records in the main_category field, return the total of all backers for successful projects by main_category where the total was more than 100,000. Sort by main_category from A to Z.
SELECT
	main_category,
	SUM(backers) AS total_backers
FROM ksprojects
WHERE state = 'successful'
GROUP BY main_category
HAVING SUM(backers) > 100000
ORDER BY main_category
