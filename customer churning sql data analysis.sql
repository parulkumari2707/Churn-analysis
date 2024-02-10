select * from public."custChurn"
select * from public."custChurn" limit 5;

describe public."custChurn";

SELECT * FROM public."custChurn" where credit_score IS NULL;
SELECT * FROM public."custChurn" WHERE age IS NULL;
SELECT * FROM public."custChurn" WHERE balance IS NULL;
SELECT * FROM public."custChurn" WHERE estimated_salary IS NULL;
SELECT * FROM public."custChurn" WHERE tenure IS NULL;
SELECT * FROM public."custChurn" WHERE country IS NULL;
SELECT * FROM public."custChurn" WHERE gender IS NULL;
SELECT * FROM public."custChurn" WHERE products_number IS NULL;
SELECT * FROM public."custChurn" WHERE credit_card IS NULL;
SELECT * FROM public."custChurn" WHERE active_member IS NULL;
SELECT * FROM public."custChurn" WHERE churn IS NULL;

select distinct gender,count(gender) as total_num from public."custChurn" group by gender;
select distinct country,count(country) as total_num from public."custChurn" group by country;

SELECT
    'credit_score' AS numeric_column_name,
    AVG(credit_score) AS mean,
    (SELECT credit_score FROM public."custChurn" GROUP BY credit_score ORDER BY COUNT(*) DESC LIMIT 1) AS mode,
    STDDEV(credit_score) AS sd,
    MAX(credit_score) AS max,
    MIN(credit_score) AS min
FROM public."custChurn"
UNION ALL
SELECT
    'age' AS numeric_column_name,
    AVG(age) AS mean,
    (SELECT age FROM public."custChurn" GROUP BY age ORDER BY COUNT(*) DESC LIMIT 1) AS mode,
    STDDEV(age) AS sd,
    MAX(age) AS max,
    MIN(age) AS min
FROM public."custChurn"
UNION ALL
SELECT
    'balance' AS numeric_column_name,
    AVG(balance) AS mean,
    (SELECT balance FROM public."custChurn" GROUP BY balance ORDER BY COUNT(*) DESC LIMIT 1) AS mode,
    STDDEV(balance) AS sd,
    MAX(balance) AS max,
    MIN(balance) AS min
FROM public."custChurn"
UNION ALL
SELECT
    'tenure' AS numeric_column_name,
    AVG(tenure) AS mean,
    (SELECT tenure FROM public."custChurn" GROUP BY tenure ORDER BY COUNT(*) DESC LIMIT 1) AS mode,
    STDDEV(tenure) AS sd,
    MAX(tenure) AS max,
    MIN(tenure) AS min
FROM public."custChurn"
UNION ALL
SELECT
    'estimated_salary' AS numeric_column_name,
    AVG(estimated_salary) AS mean,
    (SELECT estimated_salary FROM public."custChurn" GROUP BY estimated_salary ORDER BY COUNT(*) DESC LIMIT 1) AS mode,
    STDDEV(estimated_salary) AS sd,
    MAX(estimated_salary) AS max,
    MIN(estimated_salary) AS min
FROM public."custChurn";


SELECT
    CASE
        WHEN credit_score BETWEEN 100 AND 200 THEN '100-200'
        WHEN credit_score BETWEEN 200 AND 300 THEN '200-300'
		WHEN credit_score BETWEEN 300 AND 400 THEN '300-400'
		WHEN credit_score BETWEEN 400 AND 500 THEN '400-500'
		WHEN credit_score BETWEEN 500 AND 600 THEN '500-600'
		WHEN credit_score BETWEEN 600 AND 700 THEN '600-700'
		WHEN credit_score BETWEEN 700 AND 800 THEN '700-800'
		WHEN credit_score BETWEEN 800 AND 900 THEN '800-900'
		WHEN credit_score BETWEEN 900 AND 1000 THEN '900-1000'
     ELSE 'Other' 
    END AS credit_score_range,
    country,
    COUNT(*) AS count_all
FROM public."custChurn"
GROUP BY credit_score_range ,country
order by country,count_all desc;

SELECT
    gender,
    AVG(estimated_salary) AS average_salary,
    AVG(balance) AS average_bal,
    case
		WHEN churn = 0 THEN 'stayed'
        WHEN churn = 1 THEN 'not-stayed'
	end as churn_status ,
    COUNT(*) AS total_customers
FROM public."custChurn"
GROUP BY gender,churn_status;

SELECT percentile_disc(0.5) WITHIN GROUP (ORDER BY credit_score) AS median FROM public."custChurn";

SELECT
    gender,
   AVG(estimated_salary) AS average_salary, /*not needed */
    AVG(balance) AS average_bal,
    	case
			WHEN churn = 0 THEN 'stayed'
        	WHEN churn = 1 THEN 'not-stayed'
		end as churn_status,
    COUNT(*) AS total_customers
FROM public."custChurn"
GROUP BY gender,churn_status;

SELECT churn,credit_card,
    CASE
        WHEN age BETWEEN 10 AND 20 THEN '10-20'
        WHEN age BETWEEN 20 AND 30 THEN '20-30'
		WHEN age BETWEEN 30 AND 40 THEN '30-40'
		WHEN age BETWEEN 40 AND 50 THEN '40-50'
		WHEN age BETWEEN 50 AND 60 THEN '50-60'
		WHEN age BETWEEN 60 AND 70 THEN '60-70'
		WHEN age BETWEEN 70 AND 80 THEN '70-80'
		WHEN age BETWEEN 80 AND 90 THEN '80-90'
		WHEN age BETWEEN 90 AND 100 THEN '90-100'
        ELSE 'Other'
    END AS age_range,
    COUNT(*) AS frequency
FROM public."custChurn"
GROUP BY age_range,churn,credit_card
ORDER BY credit_card,churn,frequency desc;

select 
	active_member,churn,country,
count(*) as total_number 
from public."custChurn"
group by active_member,country ,churn
order by country,total_number desc;

/* */
select * from (
	select 
		customer_id,credit_score , churn,
		(balance/estimated_salary) as balance_to_salary_ratio 
		from public."custChurn"
		where credit_score>600 and balance > 0 
		order by credit_score asc) t 
order by t.balance_to_salary_ratio asc 
limit 5;

/* */
select * from (
	select 
	customer_id,credit_score , churn,
	(balance/estimated_salary) as balance_to_salary_ratio 
	from public."custChurn"
	where credit_score>600 and balance > 0 
	order by credit_score desc) t 
where t.balance_to_salary_ratio >10
order by t.balance_to_salary_ratio desc 
limit 5;

