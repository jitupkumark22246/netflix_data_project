## netflix_data_project
## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objective

-- Analyze the distribution of content types (movies vs TV shows).
--Identify the most common ratings for movies and TV shows.
-- List and analyze content based on release years, countries, and durations.
-- Explore and categorize content based on specific criteria and keywords.

## data set 
The data for this project is sourced from the Kaggle dataset:
Dataset Link : https://github.com/jitupkumark22246/netflix_data_project/blob/main/netflix_titles.csv

## Schema 
```sql
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

```

## Business problem and question 
### 1. Count the Number of Movies vs TV Shows
```sql
select 
type,
count(*) as total_count
from netflix
GROUP BY type;

```

### 2. Find the most common rating for movies and TV shows
```sql
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
```

### 3. List all movies released in a specific year (e.g., 2020)
```sql
select * from netflix
where 
type='Movie'
and
release_year = 2020 
limit 10

```

## -4. Find the top 5 countries with the most content on Netflix
```sql
select
UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
count(show_id) as cou_count
from netflix
group by 1
order by 2 desc
limit 5
```
## --5. Identify the longest movie
```sql
select  * from netflix 
where type='Movie'
and 
duration =(select max(duration) from netflix)
```
## 6. Find content added in the last 5 years

```sql
select *
from netflix 

where TO_DATE(date_added ,'Month DD,YYY') >= CURRENT_DATE - INTERVAL '5 years
```
## 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
```sql
select type, director
from netflix 
where director like '%Rajiv Chilaka%'
```

## 8. List all TV shows with more than 5 seasons
```sql
select * from netflix 
where 
type='TV Show'
and 
SPLIT_PART(duration ,' ', 1) :: numeric > 5
```
## 9. Count the number of content items in each genre

```sql
select 
unnest(string_to_array(listed_in , ',')) as genre,
count(show_id) as total_count
from netflix 
group by 1
order by 2 desc
```
## 10.Find each year and the average numbers of content release in India on netflix.return top 5 year with highest avg content release!
```sql

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
```
## --11. List all movies that are documentaries
```sql
select * 
from netflix 
where listed_in like '%Documentaries%'

```

### --12. Find all content without a director
```sql
select * from netflix
where director is null

```

## 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
```sql
select *
from netflix
where "cast" Like '%Salman Khan%'
and 
release_year > extract(year from current_date ) - 10

```
## --14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
```sql
select 
unnest(string_to_array("cast" ,',')) as actors,
count(*) as total_count
from netflix
where country like '%India'
group by 1
order by 2 desc 
limit 10

```

## 15 Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

```sql
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

```

Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

# Finding and conclusion 
Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.


