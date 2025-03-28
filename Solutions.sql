-- Netflix project 
DROP TABLE IF EXISTS netflix; 

create table netflix
(
	show_id VARCHAR(7),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country	VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
)

SELECT * FROM netflix;


-- 15 Business Problems --

-- count no. of movies and TV shows 
SELECT 
	type,
	COUNT(*) as total_content
FROM netflix
GROUP BY type;


-- Find the most comman rating for movies and TV shows. 
SELECT 
	type,
	rating
FROM
(
SELECT 
	type,
	rating,
	count(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking 
FROM netflix
GROUP BY type,rating 
) as t1
WHERE ranking = 1


-- list all movies released in a specific year. (eg., 2020)
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND 
	release_year = 2020;


-- Find the top 5 countries which has most content on netflix
SELECT 
	UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;


-- Identify longest movie
SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND 
	duration = (SELECT MAX(duration) FROM netflix)


-- 	Find all the content added last 5 years 
SELECT * FROM netflix 
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - interval '5 years'


-- Find all TV shows/ Movies by director Rajiv Chilaka !
SELECT 
	*
FROM netflix 
WHERE director ILIKE '%Rajiv Chilaka%';  -- ilike is not case sensitive like is  
	

-- List all TV shows more than 5 seasons 
SELECT 
	*
FROM netflix 
WHERE
	type = 'Tv Show'
	AND
	SPLIT_PART(duration, ' ',1):: numeric > 5;


-- Count the number of content items in each genre

SELECT
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(show_id)  
FROM netflix
GROUP BY 1;


-- Find each year and the average number of content release in Indian on netflix.
-- return top 5 year with highest average content release!

select * from netflix;

select 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
	,2) as Avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;


-- List all Movies that are documentaries 
SELECT 
	*
FROM netflix 
WHERE 
	listed_in ILIKE '%documentaries%'


-- 	Find all content without a director
SELECT * FROM netflix
WHERE 
	director IS NULL;


-- Find how many movies actor 'salman khan' appeared in last 5 years.
SELECT * FROM netflix 
WHERE 
	casts ILIKE '%Salman Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- Find the top 10 actors who have appeared in the highest number of movies in India.

SELECT * from netflix

SELECT 
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


-- Categorize the content on the presence of the keywords 'kill' and 'voilance' in the description field.
--  lable this content as 'Bad' and all other content as 'Good'. count how many items fall into each category.
with new_table
AS
(
SELECT *,
	CASE
	WHEN 
		description ilike '%kill%' or
		description ilike '%violence%' THEN 'Bad Content'
		ELSE 'Good Content'
	END category
FROM netflix 
)
SELECT 
	category,
	COUNT(*) as total_content
FROM new_table
GROUP BY 1;



























