-- NETFLIX PROJECT
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
  show_id VARCHAR(6),
  type VARCHAR(10),
  title VARCHAR(150),
  director VARCHAR(210),
  casts VARCHAR(1000),
  country VARCHAR(150),
  date_added  VARCHAR(50),
  release_year INT,
  rating VARCHAR(10),
  duration VARCHAR(15),
  listed_in VARCHAR (100),
  description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT(*)
FROM netflix as TOTAL_COLUMN;

SELECT DISTINCT(type)
FROM netflix;

-- 15 BUSINESS PROBLEMS

1. COUNT THE NUMBER OF MOVIES VS TV SHOWS

SELECT type, COUNT(*)
FROM netflix
GROUP BY type;


2. FIND THE MOST COMMON MOVIE RATING FOR MOVIES AND TV SHOWS
 
SELECT
     type,
	 rating
FROM

(
     SELECT
	 type,
	 rating,
	 COUNT(*),
	 RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
	 FROM netflix
	 GROUP BY 1, 2
) AS T1
WHERE
    ranking = 1;

3.LIST ALL MOVIES RELEASED IN A SPECIFIC YEAR (E.G. 2021 )

SELECT * FROM netflix
WHERE type = 'Movie'
AND
release_year = 2021;

4. FIND THE TOP 5 COUNTRIES WITH THE MOST CONTENT ON NETFLIX


SELECT
     UNNEST(STRING_TO_ARRAY(country, ',' )) AS new_country,
	 COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

5.IDENTIFY THE LONGEST MOVIE

SELECT * FROM netflix
WHERE
type = 'Movie'
AND 
duration = (SELECT MAX(duration) FROM netflix);

6. FIND CONTENT ADDED IN LAST 5 YEARS

SELECT * FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


7.FIND ALL THE MOVIE/TV SHOWS BY DIRECTOR 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

8.LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS

SELECT * FROM netflix
WHERE 
type = 'TV Show'
AND
SPLIT_PART(duration, ' ', 1):: numeric > 5;

9. COUNT THE NUMBERE OF CONTENT ITEMS IN GENRE

SELECT 
UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS GENRE,
COUNT(show_id) AS TOTAL_CONTENT
FROM netflix
GROUP BY 1;

10. FIND EACH YEARS AND THE AVERAGE NUMBERS OF CONTENT RELEASED BY INDIA ON NETFLIX , RETURN TOP 5 YEARS WITH THE HIGHEST AVG CONTENT RELEASED 

SELECT 
 EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS YEAR,
 COUNT(*) AS yearly_content,
 ROUND(
 COUNT(*) ::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
 ,2) AS avg_content_per_year
 FROM netflix
 WHERE country = 'India'
 GROUP BY 1;

11. LIST ALL MOVIES THAT ARE DOCUMENTARIES

SELECT * FROM netflix
WHERE listed_in ILIKE '%Documentaries%';


12. FIND ALL CONTENT WITHOUT DIRECTOR

SELECT * FROM netflix
WHERE director IS NULL;

13. FIND HOW MANY MOVIES ACTORS 'SALMAN KHAN' APPEARED IN LAST 10 YEARS

SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

14. FIND THE TOP 10 ACTORS WHO HAVE APPEARED IN THE HIGHEST NUMBER OF MOVIES PRODUCED IN INDIA 

SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) AS ACTORS,
COUNT(*) AS TOTAL_CONTENT
FROM netflix
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


15. CATEGORIZE THE CONTENT BASED ON THE PRESENCE OF THE KEYWORD 'kill' AND 'violence' IN THE DESCRIPTION FIELD.
LABEL CONTENT CONTAINING THESE KEYWORD AS 'Bad' AND ALL OTHER CONTEN AS 'Good' . COUNT HOW MANY ITEMS FALL INTO EACH CATEGORY.

WITH new_table
AS
(
SELECT *,
CASE WHEN
description ILIKE '%kill%' OR
description ILIKE '%violence%' THEN 'Bad_Content'
ELSE 'Good_Content'
END category
FROM netflix
)
SELECT 
category,
COUNT(*) AS TOTAL_CONTENT
FROM new_table
GROUP BY 1;
)
	


