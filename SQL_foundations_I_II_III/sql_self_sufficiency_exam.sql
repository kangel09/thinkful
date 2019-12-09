-- SQL self-sufficiency exam
-- In this checkpoint, you'll complete the SQL self-sufficiency exam. The purpose of this exam is for you to demonstrate your mastery of basic SQL skills. This exam is designed with real-world data analytics in mind. To that end, you'll generate realistic SQL queries and work through questions that you might face in your life as a data analyst.

-- First, we'll describe the business scenario that frames this exam. Then, we'll provide the credentials to connect you to the database. Finally, we'll provide a list of prompts that require you to write SQL queries.

-- To complete this exam, you should submit a single text file that contains the queries you generated for each prompt. You can indicate which question each query is for by using a code comment like what you see below.

-- -- 1

-- SELECT....

-- -- 2

-- SELECT....

-- Your answers to the prompts will be evaluated using 2 criteria. First, the grader will look to see that you have created the correct query. For each of the prompts below, there is a single, correct answer. Second, the grader will look at how you've styled your queries. They'll gauge whether you followed the recommended style guidelines for this program. In particular, they'll look at whether you capitalized SQL keywords, used lowercase letters for table and field names, and used multiple lines to make your queries more readable.

-- The scenario
-- You are a data analyst for your state’s department of education. You're given a database containing 2 tables: naep and finance. NAEP is the National Assessment of Educational Progress for states. The naep table contains each state’s average NAEP scores in math and reading for students in grades 4 and 8 for various years between 1992 and 2017. The finance table contains each state’s total K-12 education revenue and expenditures for the years 1992 through 2016.

-- You are tasked with assessing the quality of this data. You must also find useful ways to analyze it.
-- For this exam, you'll need to use the department_of_education database.

-- Query prompts
-- Below, you'll find 9 numbered prompts. Each prompt will require you to write a SQL query. These prompts are split up into 2 distinct sections focusing on data exploration and data analysis.

-- Data exploration
-- You'll begin your analysis with the naep table. It's always a good idea to get a better understanding of your data BEFORE doing any analysis. This allows you to gather key insights before you jump into any complex operations. You'll want to know what columns are reported in your data, what the data types are for each column, and what the first few observations look like.

-- 1. Write a query that allows you to inspect the schema of the naep table.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'naep';

-- 2. Write a query that returns the first 50 records of the naep table.
SELECT *
FROM naep
LIMIT 50;

-- 3. Write a query that returns summary statistics for avg_math_4_score by state. Make sure to sort 
-- the results alphabetically by state name.
SELECT
	ROUND(AVG(avg_math_4_score), 2) AS avg,
	ROUND(MIN(avg_math_4_score), 2) AS min_score,
	ROUND(MAX(avg_math_4_score), 2) AS max_score,
	COUNT(avg_math_4_score) AS count_score
FROM naep
GROUP BY state;

-- When a state has a large gap between the max and min values for a score, that's a good indicator that there may be problems with the education system in that state. You decide that for avg_math_4_score, a gap of more than 30 between max and min values is probably a bad sign.

-- 4. Write a query that alters the previous query so that it returns only the summary statistics for avg_math_4_score by state with differences in max and min values that are greater than 30.
-- Analyzing your data
SELECT
	ROUND(AVG(avg_math_4_score), 2) AS avg,
	ROUND(MIN(avg_math_4_score), 2) AS min_score,
	ROUND(MAX(avg_math_4_score), 2) AS max_score,
	COUNT(avg_math_4_score) AS count_score
FROM naep
GROUP BY state
HAVING (MAX(avg_math_4_score) - MIN(avg_math_4_score)) > 30;

-- Now that you've gathered key insights about your data, you're ready to do some analysis! You want to report the 
-- bottom 10 performing states for avg_math_4_score in the year 2000. You also want to report the states that scored 
-- below the average avg_math_4_score over all states in the year 2000.

-- 5. Write a query that returns a field called bottom_10_states that lists the states in the bottom 10 for 
-- avg_math_4_score in the year 2000.
SELECT
	state AS bottom_10_states,
	avg_math_4_score
FROM naep
WHERE year = 2000
ORDER BY avg_math_4_score
LIMIT 10;

-- 6. Write a query that calculates the average avg_math_4_score rounded to the nearest 2 decimal places over all states 
-- in the year 2000.
SELECT
	ROUND(AVG(avg_math_4_score), 2) AS avg_2000
FROM naep
WHERE year = 2000;

-- 7. Write a query that returns a field called below_average_states_y2000 that lists all states with an avg_math_4_score 
-- less than the average over all states in the year 2000.
SELECT
	state AS below_average_states_y2000,
	avg_math_4_score
FROM naep
WHERE year = 2000
AND avg_math_4_score < (SELECT
							ROUND(AVG(avg_math_4_score), 2) AS avg_2000
						FROM naep
						WHERE year = 2000)
ORDER BY avg_math_4_score DESC;

-- Take a look at your results. Do your above lists overlap? Should they overlap? It's important to remember that if 
-- missing values are not handled properly, you may end up with inaccurate calculations and incorrect conclusions. In 
-- the lists you've created, you would expect some of the states that showed up in the bottom 10 to also show up as 
-- scoring below the average over all states.

-- 8. Write a query that returns a field called scores_missing_y2000 that lists any states with missing values in the 
-- avg_math_4_score column of the naep data table for the year 2000.
SELECT
	state AS scores_missing_y2000
FROM naep
WHERE avg_math_4_score IS NULL
AND year = 2000;

-- After finding out that some states have missing values for avg_math_4_score in the year 2000, you may decide to 
-- alter how you report on the states in the bottom 10. To be clear: we're not asking you to do this for the exam. 
-- But in a real-world scenario, you might do this!

-- Proceeding with your analysis, you suspect that there may be a correlation between avg_math_4_score and 
-- total_expenditure for the year 2000. You hypothesize that where less money is spent, scores will be lower. Rigorously 
-- proving something like this requires some basic statistics knowledge that we haven't covered yet. Nevertheless, 
-- you can write a query that should allow you to "eyeball" this correlation.

-- 9. Write a query that returns for the year 2000 the state, avg_math_4_score, and total_expenditure from the naep 
-- table left outer joined with the finance table, using id as the key and ordered by total_expenditure greatest to 
-- least. Be sure to round avg_math_4_score to the nearest 2 decimal places, and then filter out NULL avg_math_4_scores 
-- in order to see any correlation more clearly.
-- At first glance, you should see that there seems to be a correlation.

SELECT
	n.state,
	ROUND(avg_math_4_score, 2),
	total_expenditure
FROM naep n
LEFT OUTER JOIN finance f
ON n.id = f.id
WHERE avg_math_4_score IS NOT NULL
AND n.year = 2000
ORDER BY total_expenditure DESC;