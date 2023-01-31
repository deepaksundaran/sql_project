-- first off, before importing our data we should create a database to load our data into it
-- or just load our table into an existing database. 

CREATE DATABASE PROJECT;


-- We want to work on our databse.

USE PROJECT;


-- Create a table that will contain the csv file we want to import. 

CREATE TABLE calls (
	ID CHAR(50),
	cust_name CHAR (50),
	sentiment CHAR (20),
	csat_score INT,
	call_timestamp CHAR (10),
	reason CHAR (20),
	city CHAR (20),
	state CHAR (20),
	channel CHAR (20),
	response_time CHAR (20),
	call_duration_minutes INT,
	call_center CHAR (20)
);

-- Here we used table data import wizard and loaded our data in. Let's check how it looks.

SELECT * FROM  project.`calls center` LIMIT 10;



------------------- Cleaning our data --------------------


-- The call_timestamp is a string, so we need to convert it to a date.

SET SQL_SAFE_UPDATES = 0;

UPDATE  project.`calls center` SET call_timestamp = str_to_date(call_timestamp, "%m/%d/%Y");

UPDATE  project.`calls center` SET csat_score = NULL WHERE csat_score = 0;

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM  project.`calls center` LIMIT 10;


----------------- Exploring our data --------------------------


-- lets see the shape pf our data, i.e, the number of columns and rows

SELECT COUNT(*) AS rows_num FROM  project.`calls center`;
SELECT COUNT(*) AS cols_num FROM information_schema.columns WHERE table_name = ' project.`calls center`' ;


-- Checking the distinct values of some columns:

SELECT DISTINCT sentiment FROM  project.`calls center`;
SELECT DISTINCT reason FROM  project.`calls center`;
SELECT DISTINCT channel FROM  project.`calls center`;
SELECT DISTINCT response_time FROM  project.`calls center`;
SELECT DISTINCT call_center FROM  project.`calls center`;


-- The count and precentage from total of each of the distinct values we got:

SELECT sentiment, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM  project.`calls center` GROUP BY 1 ORDER BY 3 DESC;

SELECT reason, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM  project.`calls center` GROUP BY 1 ORDER BY 3 DESC;

SELECT channel, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM  project.`calls center` GROUP BY 1 ORDER BY 3 DESC;

SELECT response_time, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM  project.`calls center` GROUP BY 1 ORDER BY 3 DESC;

SELECT call_center, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM calls)) * 100, 1) AS pct
FROM  project.`calls center` GROUP BY 1 ORDER BY 3 DESC ;

SELECT state, COUNT(*) FROM project.`calls center`  GROUP BY 1 ORDER BY 2 DESC;

SELECT DAYNAME(call_timestamp) as Day_of_call, COUNT(*) num_of_calls FROM  project.`calls center` GROUP BY 1 ORDER BY 2 DESC;


-- Aggregations :

SELECT MIN(csat_score) AS min_score, MAX(csat_score) AS max_score, ROUND(AVG(csat_score),1) AS avg_score
FROM  project.`calls center` WHERE csat_score != 0; 

SELECT MIN(call_timestamp) AS earliest_date, MAX(call_timestamp) AS most_recent FROM  project.`calls center`;

SELECT MIN(call_duration_minutes) AS min_call_duration, MAX(call_duration_minutes) AS max_call_duration, AVG(call_duration_minutes) AS avg_call_duration FROM  project.`calls center`;

SELECT call_center, response_time, COUNT(*) AS count
FROM  project.`calls center` GROUP BY 1,2 ORDER BY 1,3 DESC;

SELECT call_center, AVG(call_duration_minutes) FROM  project.`calls center` GROUP BY 1 ORDER BY 2 DESC;

SELECT channel, AVG(call_duration_minutes) FROM  project.`calls center` GROUP BY 1 ;

SELECT state, COUNT(*) FROM  project.`calls center` GROUP BY 1 ORDER BY 2 DESC;

SELECT state, reason, COUNT(*) FROM  project.`calls center` GROUP BY 1,2 ORDER BY 1,2,3 DESC;

SELECT state, sentiment , COUNT(*) FROM  project.`calls center` GROUP BY 1,2 ORDER BY 1,3 DESC;

SELECT state, AVG(csat_score) as avg_csat_score FROM  project.`calls center` WHERE csat_score != 0 GROUP BY 1 ORDER BY 2 DESC;

SELECT sentiment, AVG(call_duration_minutes) FROM  project.`calls center` GROUP BY 1 ORDER BY 2 DESC;

-- more advanced queries.

SELECT call_timestamp, MAX(call_duration_minutes) OVER(PARTITION BY call_timestamp) AS max_call_duration FROM  project.`calls center` 

