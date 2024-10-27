
# Netflix SQL Project
<img src="https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg" alt="Netflix Logo" width="300"/>

This project explores the Netflix dataset using SQL, aiming to answer various business questions and gain insights about content on the platform. It includes SQL queries to create the `netflix` table, analyze its data, and solve specific business problems.

## Project Structure

1. **Table Creation** - Define the `netflix` table with columns to store information on Netflix content, including titles, type, director, casts, country, release year, rating, and more.
2. **SQL Queries** - Solve various business problems and extract insights using SQL queries.

## Table Schema

The `netflix` table has the following structure:

```sql
CREATE TABLE netflix
(
    show_id VARCHAR(6),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);
```

## Example Queries

Here are some example queries used to analyze the Netflix data:

- **View All Content**:
  ```sql
  SELECT * FROM netflix;
  ```

- **Count Total Content**:
  ```sql
  SELECT COUNT(*) AS total_count FROM netflix;
  ```

- **Distinct Types of Content**:
  ```sql
  SELECT DISTINCT type FROM netflix;
  ```

## Business Problems Addressed

### 1. Count the Number of Movies vs. TV Shows
```sql
SELECT 
    type,
    COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```

### 2. Find the Most Common Rating for Movies and TV Shows
```sql
SELECT 
    type,
    rating
FROM
(
    SELECT
        type,
        rating,
        COUNT(*),
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY 1, 2
) AS t1
WHERE ranking = 1;
```

### 3. List All Movies Released in 2020
```sql
SELECT * FROM netflix
WHERE type = 'Movie' AND release_year = 2020;
```

### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
SELECT
    UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

### 5. Find the Top 5 Longest Movies
```sql
SELECT 
    title,  
    SUBSTRING(duration, 1, POSITION('m' IN duration) - 1)::int AS duration
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY duration DESC
LIMIT 5;
```

### Additional Queries

This project also addresses 10 more business-related questions. For example, identifying content added in the last 5 years, finding TV shows with more than 5 seasons, and categorizing content based on keywords in descriptions.

