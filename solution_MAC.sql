--Getting a feel for the data:
SELECT * FROM users LIMIT 10;
SELECT * FROM progress LIMIT 10;

--What are the Top 25 schools (.edu domains)?
SELECT email_domain AS 'Domain Name', COUNT(*) AS 'Num. of Users'
FROM users GROUP BY email_domain ORDER BY COUNT(*) DESC LIMIT 25;

--How many .edu learners are located in New York?
--Given the domain names that pop up, the "city" New York seems to encompass colleges/universities
--from all over the state, as I know for a fact that SUNY Binghamton is NOT in NYC. Also it seems
--to encompass schools which are decidedly NOT in New York (e.g., Princeton, NJIT). I don't know
--what to make of this.
SELECT email_domain AS "Domain" FROM users WHERE city = 'New York';
SELECT COUNT(user_id) AS "Num. of NYC Users" FROM users 
WHERE city = 'New York';

--The mobile_app column contains either mobile-user or NULL. 
--How many of these Codecademy learners are using the mobile app?
WITH temp AS (SELECT CASE 
WHEN (mobile_app = 'mobile-user') THEN 1 ELSE 0 END 
AS 'is_mobile' FROM users)
SELECT sum(is_mobile) AS "Num. of Mobile Users" FROM temp;

--The data type of the sign_up_at column is DATETIME. 
--It is for storing a date/time value in the database.
--Using the function strftime(), query for the 
--sign up counts for each hour.
SELECT strftime('%H', sign_up_at) AS "Hour of Sign-Up",
COUNT(*) AS "Num. of Sign-Ups"
FROM users GROUP BY 1 ORDER BY 1 ASC;
--Checked with Microsoft Excel that the above yields the 
--correct number of users.

--Join the two tables using JOIN and then 
--see what you can dig out of the data!
SELECT * FROM users INNER JOIN progress ON
users.user_id = progress.user_id;

--Suggested questions:
--DO different schools perfer different courses?
--Search is limited to the top 25 schools in the U.S.
--Delete the "LIMIT" clause to see data from all schools.
--The somewhat complicated HAVING statement is meant to
--leave out schools where (a) student(s) signed up for
--Codecademy but had not started or completed a course.
WITH all_data AS (SELECT * FROM users INNER JOIN progress ON
users.user_id = progress.user_id),
learning_data AS (SELECT email_domain, country,
CASE WHEN(learn_cpp = 'started' or learn_cpp = 'completed') THEN 1 ELSE 0 END AS 'Learning_CPP',
CASE WHEN(learn_sql = 'started' or learn_sql = 'completed') THEN 1 ELSE 0 END AS 'Learning_SQL',
CASE WHEN(learn_html = 'started' or learn_html = 'completed') THEN 1 ELSE 0 END AS 'Learning_HTML',
CASE WHEN(learn_javascript = 'started' or learn_javascript = 'completed') THEN 1 ELSE 0 END AS 'Learning_Javascript',
CASE WHEN(learn_java = 'started' or learn_java = 'completed') THEN 1 ELSE 0 END AS 'Learning_Java'
FROM all_data)
SELECT email_domain AS "Domain Name", SUM(Learning_CPP) AS 'Total CPP St.', SUM(Learning_SQL) AS 'Total SQL St.',
SUM(Learning_HTML) AS 'Total HTML St.', SUM(Learning_Javascript) AS 'Total Javascript St.',
SUM(Learning_Java) AS 'Total Java St.' FROM learning_data WHERE country = 'US' GROUP BY 1 
HAVING(SUM(Learning_CPP) > 0 OR SUM(Learning_SQL) > 0 OR SUM(Learning_HTML) > 0 OR 
SUM(Learning_Javascript) > 0 OR SUM(Learning_Java) > 0) ORDER BY 2 DESC, 3 DESC, 
4 DESC, 5 DESC, 6 DESC LIMIT 25;

--Which courses are the New Yorkers students taking?
WITH all_data AS (SELECT * FROM users INNER JOIN progress ON
users.user_id = progress.user_id),
learning_data AS (SELECT email_domain, 
CASE WHEN(learn_cpp = 'started' or learn_cpp = 'completed') THEN 1 ELSE 0 END AS 'Learning_CPP',
CASE WHEN(learn_sql = 'started' or learn_sql = 'completed') THEN 1 ELSE 0 END AS 'Learning_SQL',
CASE WHEN(learn_html = 'started' or learn_html = 'completed') THEN 1 ELSE 0 END AS 'Learning_HTML',
CASE WHEN(learn_javascript = 'started' or learn_javascript = 'completed') THEN 1 ELSE 0 END AS 'Learning_Javascript',
CASE WHEN(learn_java = 'started' or learn_java = 'completed') THEN 1 ELSE 0 END AS 'Learning_Java'
FROM all_data WHERE city = 'New York')
SELECT email_domain AS 'Domain Name', SUM(Learning_CPP) AS 'Total CPP St.', SUM(Learning_SQL) AS 'Total SQL St.',
SUM(Learning_HTML) AS 'Total HTML St.', SUM(Learning_Javascript) AS 'Total Javascript St.',
SUM(Learning_Java) AS 'Total Java St.' FROM learning_data GROUP BY 1 
HAVING(SUM(Learning_CPP) > 0 OR SUM(Learning_SQL) > 0 OR SUM(Learning_HTML) > 0 OR 
SUM(Learning_Javascript) > 0 OR SUM(Learning_Java) > 0) ORDER BY 2 DESC, 3 DESC, 
4 DESC, 5 DESC, 6 DESC;

--What courses are the Chicago students taking?
WITH all_data AS (SELECT * FROM users INNER JOIN progress ON
users.user_id = progress.user_id),
learning_data AS (SELECT email_domain, 
CASE WHEN(learn_cpp = 'started' or learn_cpp = 'completed') THEN 1 ELSE 0 END AS 'Learning_CPP',
CASE WHEN(learn_sql = 'started' or learn_sql = 'completed') THEN 1 ELSE 0 END AS 'Learning_SQL',
CASE WHEN(learn_html = 'started' or learn_html = 'completed') THEN 1 ELSE 0 END AS 'Learning_HTML',
CASE WHEN(learn_javascript = 'started' or learn_javascript = 'completed') THEN 1 ELSE 0 END AS 'Learning_Javascript',
CASE WHEN(learn_java = 'started' or learn_java = 'completed') THEN 1 ELSE 0 END AS 'Learning_Java'
FROM all_data WHERE city = 'Chicago')
SELECT email_domain AS 'Domain Name', SUM(Learning_CPP) AS 'Total CPP St.', SUM(Learning_SQL) AS 'Total SQL St.',
SUM(Learning_HTML) AS 'Total HTML St.', SUM(Learning_Javascript) AS 'Total Javascript St.',
SUM(Learning_Java) AS 'Total Java St.' FROM learning_data GROUP BY 1 
HAVING(SUM(Learning_CPP) > 0 OR SUM(Learning_SQL) > 0 OR SUM(Learning_HTML) > 0 OR 
SUM(Learning_Javascript) > 0 OR SUM(Learning_Java) > 0) ORDER BY 2 DESC, 3 DESC, 
4 DESC, 5 DESC, 6 DESC;

--How many students from the University of Pittsburgh have completed the Learn SQL course?
WITH all_data AS (SELECT * FROM users INNER JOIN progress ON
users.user_id = progress.user_id),
learning_data AS (SELECT email_domain, 
CASE WHEN(learn_sql = 'completed') THEN 1 ELSE 0 END AS 'Learning_SQL'
FROM all_data WHERE email_domain LIKE '%pitt.edu')
SELECT SUM(Learning_SQL) AS 'Total SQL St.' FROM learning_data;

--How popular is each language among mobile users?
WITH all_data AS (SELECT * FROM users INNER JOIN progress ON
users.user_id = progress.user_id),
learning_data AS (SELECT  
CASE WHEN (mobile_app = 'mobile-user') THEN 1 ELSE 0 END AS 'is_mobile',
CASE WHEN(learn_cpp = 'started' or learn_cpp = 'completed') THEN 1 ELSE 0 END AS 'Learning_CPP',
CASE WHEN(learn_sql = 'started' or learn_sql = 'completed') THEN 1 ELSE 0 END AS 'Learning_SQL',
CASE WHEN(learn_html = 'started' or learn_html = 'completed') THEN 1 ELSE 0 END AS 'Learning_HTML',
CASE WHEN(learn_javascript = 'started' or learn_javascript = 'completed') THEN 1 ELSE 0 END AS 'Learning_Javascript',
CASE WHEN(learn_java = 'started' or learn_java = 'completed') THEN 1 ELSE 0 END AS 'Learning_Java'
FROM all_data)
SELECT SUM(Learning_CPP) AS 'Total CPP Mob.', SUM(Learning_SQL) AS 'Total SQL Mob.',
SUM(Learning_HTML) AS 'Total HTML Mob.', SUM(Learning_Javascript) AS 'Total Javascript Mob.',
SUM(Learning_Java) AS 'Total Java Mob.' FROM learning_data WHERE is_mobile = 1;

--Do users who sign up for Codecademy later in the day tend to complete more courses than
--users who sign up earlier in the day?
WITH all_data AS (SELECT * FROM users INNER JOIN progress ON
users.user_id = progress.user_id),
learning_data AS (
SELECT strftime('%H', sign_up_at) AS "Hour",
CASE WHEN(learn_cpp = 'completed') THEN 1 ELSE 0 END AS 'Completed_CPP',
CASE WHEN(learn_sql = 'completed') THEN 1 ELSE 0 END AS 'Completed_SQL',
CASE WHEN(learn_html = 'completed') THEN 1 ELSE 0 END AS 'Completed_HTML',
CASE WHEN(learn_javascript = 'completed') THEN 1 ELSE 0 END AS 'Completed_Javascript',
CASE WHEN(learn_java = 'completed') THEN 1 ELSE 0 END AS 'Completed_Java'
FROM all_data)
SELECT Hour AS "Hour of Sign-Up", SUM(Completed_CPP) +
SUM(Completed_SQL) + SUM(Completed_HTML) +
SUM(Completed_Javascript) + SUM(Completed_Java) AS "Total Completed" 
FROM learning_data GROUP BY 1;
--The below breaks up the completed classes by class type:
--SELECT Hour AS "Hour of Sign-Up", SUM(Completed_CPP) AS "Finished CPP", 
--SUM(Completed_SQL) AS "Finished SQL", SUM(Completed_HTML) AS "Finished HTML", 
--SUM(Completed_Javascript) AS "Finished Javascript", SUM(Completed_Java) AS "Finished Java" 
--FROM learning_data GROUP BY 1;
