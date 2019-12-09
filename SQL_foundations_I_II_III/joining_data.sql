-- The baseball database
-- The database for this challenge is located on the same server you’ve used in previous 
-- checkpoints in this module. The name of the database is baseball. It contains information 
-- about baseball players who have been nominated for, but not necessarily inducted into, 
-- the Baseball Hall of Fame. There are 4 tables in this database:

-- hof_inducted: This table consists of the voting results for all candidates inducted into 
-- the Baseball Hall of Fame.
-- hof_not_inducted: This table consists of the voting results for all candidates nominated for, 
-- but not inducted into, the Baseball Hall of Fame.
-- people: This table consists of personal and biographical details of every player that appears 
-- in either the hof_inducted table or the hof_not_inducted table. A unique “playerid” field is 
-- assigned to each player.
-- salaries: This table has player salary data since 1985.

-- Questions
-- 2. Write a query that returns the namefirst and namelast fields of the people table, 
-- along with the inducted field from the hof_inducted table. All rows from the people table 
-- should be returned, and NULL values for the fields from hof_inducted should be returned when there is no match found.
SELECT
	namefirst,
	namelast,
	inducted
FROM people AS p
LEFT JOIN hof_inducted AS i
ON p.playerid = i.playerid

-- 3. In 2006, a special Baseball Hall of Fame induction was conducted for players 
-- from the negro baseball leagues of the 20th century. In that induction, 17 players 
-- were posthumously inducted into the Baseball Hall of Fame. Write a query that returns 
-- the first and last names, birth and death dates, and birth countries for these players. 
-- Note that the year of induction was 2006, and the value for votedby will be “Negro League.”
SELECT
	namefirst, 
	namelast,
	birthyear,
	deathyear,
	birthcountry
FROM people AS p
INNER JOIN hof_inducted AS i
ON p.playerid = i.playerid
WHERE votedby = 'Negro League'

-- 4. Write a query that returns the yearid, playerid, teamid, and salary 
-- fields from the salaries table, along with the category field from the 
-- hof_inducted table. Keep only the records that are in both salaries and 
-- hof_inducted. Hint: While a field named yearid is found in both tables, 
-- don’t JOIN by it. You must, however, explicitly name which field to include.
SELECT
	s.yearid,
	s.playerid,
	teamid,
	salary,
	category
FROM salaries AS s
INNER JOIN hof_inducted AS i
ON s.playerid = i.playerid

-- 5. Write a query that returns the playerid, yearid, teamid, lgid, and salary 
-- fields from the salaries table and the inducted field from the hof_inducted 
-- table. Keep all records from both tables.
SELECT
	s.playerid,
	s.yearid,
	teamid,
	lgid,
	salary,
	inducted
FROM salaries AS s
FULL JOIN hof_inducted AS i
ON s.playerid = i.playerid

-- 6. There are 2 tables, hof_inducted and hof_not_inducted, indicating successful 
-- and unsuccessful inductions into the Baseball Hall of Fame, respectively.
-- 	a. Combine these 2 tables by all fields. Keep all records.
SELECT *
FROM hof_inducted AS i
UNION ALL
SELECT *
FROM hof_not_inducted AS n


--  b. Get a distinct list of all player IDs for players who have been put up for HOF induction.
SELECT playerid
FROM hof_inducted
UNION
SELECT playerid
FROM hof_not_inducted


-- 7. Write a query that returns the last name, first name (see people table), 
-- and total recorded salaries for all players found in the salaries table.
SELECT
	namelast,
	namefirst,
	SUM(salary) AS total_salary
FROM salaries AS s
INNER JOIN people AS p
ON s.playerid = p.playerid
GROUP BY namelast, namefirst, playerid

-- 8. Write a query that returns all records from the hof_inducted and 
-- hof_not_inducted tables that include playerid, yearid, namefirst, 
-- and namelast. Hint: Each FROM statement will include a LEFT OUTER JOIN!
SELECT
	p.playerid,
	yearid,
	namelast,
	namefirst
FROM (SELECT 
	  	playerid,
		yearid
	  FROM hof_inducted 
	  UNION
	  SELECT 
	  	playerid,
		yearid
	  FROM hof_not_inducted 
	  ) AS i
INNER JOIN people AS p
ON i.playerid = p.playerid
ORDER BY p.playerid, yearid

-- 9. Return a table including all records from both hof_inducted and hof_not_inducted, 
-- and include a new field, namefull, which is formatted as namelast , namefirst 
-- (in other words, the last name, followed by a comma, then a space, then the first name). 
-- The query should also return the yearid and inducted fields. Include only records since 
-- 1980 from both tables. Sort the resulting table by yearid, then inducted so that Y comes 
-- before N. Finally, sort by the namefull field, A to Z.SELECT
 	CONCAT(namelast, ', ', namefirst) AS namefull,
	yearid,
	inducted
FROM (SELECT
	 	inducted,
	 	playerid,
	 	yearid
	 FROM hof_inducted
	 UNION
	 SELECT
	 	inducted,
	 	playerid,
	 	yearid
	 FROM hof_not_inducted) AS i
INNER JOIN people AS p
ON i.playerid = p.playerid
WHERE yearid >= 1980
ORDER BY inducted DESC, namefull, yearid

-- 10. Write a query that returns the highest annual salary for each teamid, 
-- ranked from high to low, along with the corresponding playerid. Bonus! 
-- Return namelast and namefirst in the resulting table. (You can find these 
-- in the people table.)
WITH max AS(
	SELECT
		MAX(salary) AS max_salary,
		teamid,
		yearid
	FROM salaries
	GROUP BY teamid,yearid
)
SELECT
	playerid,
	s.yearid,
	s.teamid,
	max_salary
FROM max AS m
LEFT JOIN salaries AS s
ON s.teamid = m.teamid
AND s.yearid = m.yearid
AND s.salary = m.max_salary
ORDER BY s.yearid, max_salary DESC
___________________________
WITH max AS(
	SELECT
		MAX(salary) AS max_salary,
		teamid,
		yearid
	FROM salaries
	GROUP BY teamid,yearid
)
SELECT
	namelast,
	namefirst,
	s.playerid,
	s.yearid,
	s.teamid,
	max_salary
FROM max AS m
LEFT JOIN salaries AS s
ON s.teamid = m.teamid
AND s.yearid = m.yearid
AND s.salary = m.max_salary
INNER JOIN people AS p
ON p.playerid = s.playerid
ORDER BY s.yearid, max_salary DESC

-- 11. Select birthyear, deathyear, namefirst, and namelast of all the players born 
-- since the birth year of Babe Ruth (playerid = ruthba01). Sort the results by birth 
-- year from low to high.
SELECT
	namefirst,
	namelast,
	birthyear,
	deathyear
FROM people
WHERE birthyear >= (SELECT birthyear 
					FROM people 
					WHERE playerid = 'ruthba01')
ORDER BY birthyear 

-- 12. Using the people table, write a query that returns namefirst, namelast, 
-- and a field called usaborn where the usaborn field should show the following: 
-- if the player's birthcountry is the USA, then the record is 'USA.' Otherwise, 
-- it's 'non-USA.' Order the results by 'non-USA' records first.
SELECT
	namefirst,
	namelast,
	CASE 
		WHEN birthcountry = 'USA' THEN 'USA' 
		ELSE 'non-USA' END AS usaborn
FROM people
ORDER BY usaborn


-- 13. Calculate the average height for players throwing with their right hand versus 
-- their left hand. Name these fields right_height and left_height, respectively.
SELECT
	ROUND(AVG(CASE WHEN throws = 'R' THEN height END), 2) AS right_height,
	ROUND(AVG(CASE WHEN throws = 'L' THEN height END) ,2) AS left_height
FROM people

-- 14. Get the average of each team's maximum player salary since 2010. Hint: WHERE 
-- will go inside your CTE.
WITH max_salaries AS(
	SELECT 
		teamid,
		yearid,
		MAX(salary) AS max_salary
	FROM salaries
	WHERE yearid >= 2010
	GROUP BY teamid, yearid
	)
SELECT
	ROUND(AVG(max_salary), 0) AS avg_max_salary,
	teamid 
FROM max_salaries
GROUP BY teamid

