-- Netflix Database

CREATE TABLE netflix (
	show_id	VARCHAR(6),
	type VARCHAR(25),	
	title VARCHAR(150),
	director VARCHAR(250),	
	casts VARCHAR(1000),
	country	VARCHAR(150),
	date_added VARCHAR(20),
	release_year INT,	
	rating VARCHAR(10),
	duration VARCHAR(10),
	listed_in VARCHAR(100),	
	description VARCHAR(250)
);
SELECT * FROM netflix;

       -- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows

SELECT
   TYPE,
   COUNT(*) AS total_content
   FROM netflix
   GROUP BY TYPE;


2. Find the most common rating for movies and TV shows?
select
    type,
	ranking
	FROM
(	
   SELECT 
   TYPE,
   RATING,
   COUNT(*),
   RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
   FROM netflix
   GROUP BY 1,2
)as t1
  where 
     ranking =1
   ;


3. List all movies released in a specific year (e.g., 2020)

   SELECT * FROM netflix
 WHERE 
 TYPE = 'Movie'
 AND
  release_year= 2020;


4. Find the top 5 countries with the most content on Netflix

SELECT
     UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(show_id) as total_content
FROM netflix
GROUP  BY 1
ORDER BY 2
LIMIT 5


5. Identify the longest movie

 SELECT * FROM netflix
 WHERE 
    type = 'Movie'
	AND duration =(SELECT MAX (duration)
	FROM netflix
	
 
6. Find content added in the last 5 years
  --STEP 1 CONVERT date_added column character into date format;

  SELECT
  TO_DATE(date_added,'Month DD, YYYY')
  FROM netflix
  
--STEP2 COMPARE THE CURRENT DATE WITH DATE_ADDED 

 SELECT * FROM netflix
      WHERE 
      TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5YEARS'



7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

   SELECT
     * FROM netflix
       WHERE director ILIKE '%Rajiv Chilaka%'



8. List all TV shows with more than 5 seasons

 -- STEP1: USING SPLIT_PART FUNCTION TO SPLIT TEXT BY DELIMITER
 
   SELECT
   *
   --SPLIT_PART(duration,' ',1) AS seasons
   FROM netflix
  WHERE type = 'TV Show'  
  AND
   SPLIT_PART(duration,' ', 1)::numeric > 5
   

9. Count the number of content items in each genre

--SPLIT MULTIPLE GENRE IN ONE MOVIE
 
SELECT
UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
COUNT(Show_id)
   FROM netflix
GROUP BY 1


10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release

-- step1: Need the "india" data first
 SELECT * FROM netflix
 WHERE country = 'India';

-- step2: Find out release_year
SELECT
TO_DATE(date_added,'month DD,YYYY') as date,
*
FROM netflix
WHERE country = 'India';

--step3: count the movie release in every year
SELECT
    EXTRACT(YEAR from TO_DATE(date_added,'Month DD,YYYY')) as year,
	COUNT(*)
FROM netflix
   WHERE COUNTRY ='India'
   GROUP BY 1;
   
   
11. List all movies that are documentaries

 SELECT * FROM netflix
 WHERE
 listed_in ILIKE '%Documentaries%';
 

12. Find all content without a director

 SELECT * FROM netflix
WHERE 
    director IS NULL;


13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
  WHERE 
  casts ILIKE '%Salman khan%'
AND
   release_year> EXTRACT( year from CURRENT_DATE)- 10
   


14. Find the top 10 actors who have appeared in the highest number of movies
produced in India.

{-- USING STRING_TO_ARRAY FUNCTION TO SPLIT STRING THEN USE COUNT FUNCTION AND WHERE CLAUSE
---FINALLY GROUPBY AND ORDERBY FUNCTION}


SELECT 
--show_id,
--casts,
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
 FROM netflix
   WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

WITH new_table
AS
 (
 SELECT *,
	CASE
	  WHEN description ILIKE'%KILL%' OR
	  description ILIKE '%violence' THEN 'BAD_content'
	     ELSE 'good_content'
END category
FROM netflix
)
  SELECT category,
  COUNT(*) as total_content
  FROM new_table
 GROUP BY 1





