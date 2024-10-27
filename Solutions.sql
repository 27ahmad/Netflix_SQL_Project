-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR (50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)

);

select * from netflix;

SELECT
	COUNT (*) AS total_count
FROM netflix;

SELECT
	DISTINCT type
FROM netflix;

SELECT * FROM netflix;

-- 15 Business Problems
--1. Count the number of movies vs tv shows 

SELECT 
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type;

--2. Find the most common rating for movies and TV shows

SELECT 
	type,
	rating
FROM
(
	SELECT
	type,
	rating,
	COUNT(*),
	RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1,2
) AS t1

WHERE 
	ranking = 1;


--3 List all movies released in 2020
SELECT * FROM NETFLIX
WHERE 
	type = 'Movie' 
	AND 
	release_year = 2020;

--4 Find the top 5 countries with the most content on Netflix
SELECT
	UNNEST(STRING_TO_ARRAY (COUNTRY, ',')) AS new_country,
	COUNT(*) as total_content
FROM NETFLIX
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--5 Find the top 5 longest movies

SELECT 
    title,  
    substring(duration, 1, position('m' in duration) - 1)::int AS duration
FROM 
    Netflix
WHERE 
    type = 'Movie' 
    AND duration IS NOT NULL
ORDER BY 
    duration DESC
LIMIT 5;

--6 Find content added in the last 5 years

SELECT * 
FROM NETFLIX
WHERE
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


--7 Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT * FROM NETFLIX
WHERE 
	DIRECTOR ILIKE '%Rajiv Chilaka%'

--8 List all TV shows with more than 5 seasons

SELECT 
	*
FROM NETFLIX
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::int > 5


--9 Count the number of content in each genre

SELECT
	UNNEST (STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC


--10 Find the top 5 years with the highest number of content releases in India on Netflix. For each of these years, return the year and the total number of content releases. 


SELECT 
    release_year, 
    COUNT(*) AS content_count
FROM 
    Netflix
WHERE 
    country = 'India'
GROUP BY 
    release_year
ORDER BY 
    content_count DESC
LIMIT 5;

--11 List all the movies that are documentaries

SELECT * FROM netflix
WHERE 
	listed_in ILIKE '%documentaries%'


--12 Find all the content without a director
SELECT * FROM netflix
WHERE director IS NULL;

--13 Find the number of movies actor 'Salman Khan' appreaed in the last 10 years

SELECT * FROM NETFLIX
WHERE casts ILIKE '%Salman Khan%'
AND EXTRACT(YEAR FROM CURRENT_DATE)-release_year::int <= 10

-- 14 Find the top 10 actors who have appeared in the highest number of movies produced in the United States

SELECT
UNNEST (STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) as total_content
from netflix
WHERE COUNTRY ILIKE '%United States%' AND type = 'Movie'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--15 Categorize the content based on the presence of keywords
-- 'kill' and 'violence' in the description field. Label such content as
-- 'Bad' and the rest as 'Good'. Count how many items fall into each Category

WITH new_table
AS
(
SELECT 
*,
	CASE
	WHEN
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad'

		ELSE 'Good'
	END category
		
 FROM NETFLIX
 )
SELECT 
	category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1
	