drop table  if exists netflix;
CREATE TABLE netflix (
    show_id VARCHAR(20) PRIMARY KEY,
    "type" VARCHAR(20),
    title VARCHAR(200),
    director VARCHAR(208),
    "cast" VARCHAR(1000),
    country VARCHAR(200),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in VARCHAR(255),
    description VARCHAR(250)
);


select * from netflix 

COPY netflix(show_id, type, title, director, "cast", country, date_added, release_year, rating, duration, listed_in, description)
FROM 'D:\new sql project\netflix_titles.csv'
DELIMITER ','
CSV HEADER;


select *
from netflix
where country is null


select
distinct type
from netflix

select * from netflix 

-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows
--2. Find the most common rating for movies and TV shows
--3. List all movies released in a specific year (e.g., 2020)
--4. Find the top 5 countries with the most content on Netflix
--5. Identify the longest movie
--6. Find content added in the last 5 years
--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
--8. List all TV shows with more than 5 seasons
--9. Count the number of content items in each genre
--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!
--11. List all movies that are documentaries
--12. Find all content without a director
--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

/*15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category. */

--1. Count the number of Movies vs TV Shows
select 
type,
count(*) as total_count
from netflix
GROUP BY type;

--2. Find the most common rating for movies and TV shows
select 
type,
rating,
ranking
from 

( select 
type,
rating,
count(*) as no_of_count,
rank() over(partition by type order by count(*) desc) as ranking
from netflix 
group by type,rating 
) as t1 

where ranking =1 ;


--3. List all movies released in a specific year (e.g., 2020)
select * from netflix
where 
type='Movie'
and
release_year = 2020 
limit 10


--4. Find the top 5 countries with the most content on Netflix

select
UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
count(show_id) as cou_count
from netflix
group by 1
order by 2 desc
limit 5

--5. Identify the longest movie
select  * from netflix 
where type='Movie'
and 
duration =(select max(duration) from netflix)


--6. Find content added in the last 5 years
select *
from netflix 

where TO_DATE(date_added ,'Month DD,YYY') >= CURRENT_DATE - INTERVAL '5 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select type, director
from netflix 
where director like '%Rajiv Chilaka%'


--8. List all TV shows with more than 5 seasons
select * from netflix 
where 
type='TV Show'
and 
SPLIT_PART(duration ,' ', 1) :: numeric > 5

--9. Count the number of content items in each genre

select 
unnest(string_to_array(listed_in , ',')) as genre,
count(show_id) as total_count
from netflix 
group by 1
order by 2 desc

/* 10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release! */ 

SELECT 
    EXTRACT (YEAR FROM TO_DATE(date_added, 'Month DD YYYY')) as year,
    COUNT(*) AS yearl_content ,
    ROUND(
        COUNT(*)::numeric /
        (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
where country='India'
group by 1

--11. List all movies that are documentaries
select * 
from netflix 
where listed_in like '%Documentaries%'

--12. Find all content without a director
select * from netflix
where director is null

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select *
from netflix
where "cast" Like '%Salman Khan%'
and 
release_year > extract(year from current_date ) - 10


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
unnest(string_to_array("cast" ,',')) as actors,
count(*) as total_count
from netflix
where country like '%India'
group by 1
order by 2 desc 
limit 10

/*15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category. */
with new_table
as
(
select *,

case 
	when
	description like '%kill%'
	or 
	description like '%violence%' then 'bad_film'

	else 'good_film'

	end as category
 from netflix 
) 

select category ,
count(*) total_count
from new_table 
group by 1