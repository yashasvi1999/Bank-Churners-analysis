create database customer_churn_records;
use customer_churn_records;

--Retrieving the data from the database
select * from churn_data;

--Distribution of churned customers based on age range
With age_analysis_churned as
(
select case when Age<20 then "0-20"
when Age between 20 and 30 then "20-30"
when Age between 30 and 40 then "30-40"
when Age between 40 and 50 then "40-50"
when Age between 50 and 60 then "50-60"
when Age between 60 and 70 then "60-70"
when Age>80 then "Above 80" end as age_range, Count(*) as customers
from churn_data where Exited = 1
group by age_range
order by age_range)

select age_range, customers, round(customers/(select count(*) from churn_data) * 100,2) as churn_percentage from age_analysis_churned
order by churn_percentage desc;
/* Customers in the 40-50 age group have the highest churn rate (7.9%), with those in the 30-40 age group closely following.*/

--Distribution of retained customers based on age range
With age_analysis_retained as
(
select case when Age<20 then "0-20"
when Age between 20 and 30 then "20-30"
when Age between 30 and 40 then "30-40"
when Age between 40 and 50 then "40-50"
when Age between 50 and 60 then "50-60"
when Age between 60 and 70 then "60-70"
when Age>80 then "Above 80" end as age_range, Count(*) as customers
from churn_data where Exited = 0
group by age_range
order by age_range)

select age_range, customers, round(customers/(select count(*) from churn_data) * 100,2) as retained_percentage from age_analysis_retained
order by retained_percentage desc;
/*The age distribution of retained bank customers is mostly between the ages of 30-40 years */

--Distribution of churned customer based on gender
With gender_analysis as 
(
Select Gender, count(*) as gender_churn_count 
from churn_data
where Exited = 1
group by Gender 
)

select Gender, gender_churn_count, round(gender_churn_count/(select count(*) from churn_data) * 100, 2) as gender_churn_percent from gender_analysis
order by gender_churn_percent desc;
/*Female customers exhibit a higher churn rate (11.4%) compared to males (9%)*/

--Distribution of retained customers based on gender
With gender_analysis as 
(
Select Gender, count(*) as gender_retained_count 
from churn_data 
where Exited = 0
group by Gender
)

select Gender, gender_retained_count, round(gender_retained_count/(select count(*) from churn_data) * 100, 2) as gender_retained_percent from gender_analysis
order by gender_retained_percent desc;
/*Male customers exhibit a higher churn rate (45.6%) compared to females (34%)*/

--Distribution of churned customers based on geography
With geo_analysis as (
Select Geography, count(*) as geo_churn_count from churn_data
where Exited = 1 
group by Geography
)

select Geography, geo_churn_count, round(geo_churn_count/(select count(*) from churn_data) * 100,2) as geo_churn_percent from geo_analysis
order by geo_churn_percent desc;
/*France and Germany share a higher churn rate (8.1%) than Spain (4.1%).*/

--Customer churn with respect to whether the customer is an active member or not 
With activity_analysis as (
select case when IsActiveMember = 1 then "active" Else "not_active" end as activity, count(*) as activity_count  from churn_data 
where Exited = 1 
group by activity)

Select activity, activity_count, round(activity_count/(select count(*) from churn_data) * 100, 2) as activity_percentage from activity_analysis
order by activity_percentage desc;
/*Inactive members demonstrate a significantly higher churn rate (13%) than active members.*/

--Customer churn with respect to HasCrCard
With cred_analysis as (
select case when HasCrCard = 1 then "has_cr_card" Else "does_not_have_cr_card" end as cr_card, count(*) as card_count from churn_data 
where Exited = 1 
group by cr_card)

Select cr_card, card_count, round(card_count/(select count(*) from churn_data) * 100,2) as percent from cred_analysis
order by percent desc;
/*Customers with credit cards churn at a notably higher rate (14.2%) than those without (6.1%).*/

--customer churn with respect to balance
select case when Balance between 0 and 50000 then "0-50000"
when Balance between 50000 and 100000 then "50000-100000"
when Balance between 100000 and 150000 then "100000-150000"
when Balance between 150000 and 200000 then "150000-200000"
when Balance between 200000 and 250000 then "200000-250000"
when Balance>250000 then "Above 250000" end as balance_range, Count(*) as customers
from churn_data where Exited = 1
group by balance_range
order by customers desc;
/* Customers in the balance group 100000-150000 are most likely to exit the bank*/

--customer churn with respect to Number of products
select NumOfProducts as no_of_products, count(*) as count from churn_data 
where Exited = 1
group by no_of_products 
order by count desc;
/*Customers who avail only 1 product are most likely to exit the bank*/


--customer churn with respect to card type
With card_type_analysis as(
select card_type, count(*) as total_count from churn_data 
where Exited = 1 
group by card_type)

Select card_type, total_count, round(total_count/(select count(*) from churn_data) *100, 2) as card_type_churn_percent from card_type_analysis
order by total_count desc;
/*Diamond cardholders churn more frequently (5.5%) than those with other card types*/

--customer churn with respect to credit score
SELECT 
CASE 
    WHEN Creditscore >= 800 AND creditscore <= 850 THEN 'Excellent'
	WHEN Creditscore >= 740 AND creditscore <= 799 THEN 'Very Good'
	WHEN Creditscore >= 670 AND creditscore <= 739 THEN 'Good'
	WHEN Creditscore >= 580 AND creditscore <= 669 THEN 'Fair'
	ELSE 'Poor'
End as credit_score_type, count(*) as count from churn_data 
where Exited = 1
group by credit_score_type
order by count desc;


/* This shows that the customers who have Fair and poor credit score type are more prone to exit bank and 
the customer who have credit score type as Excellent are least expected to exit the bank. */
