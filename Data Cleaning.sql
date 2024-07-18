use newschema;

-- Making a copy of tables to keep a backup incase we make changes 
-- ----- 2014----------
CREATE TABLE election_2014
LIKE constituency_wise_results_2014;

SELECT * FROM election_2014;

INSERT election_2014
SELECT *
FROM constituency_wise_results_2014;
SELECT * FROM election_2014;
-- -------- 2019 ---------
CREATE TABLE election_2019
LIKE constituency_wise_results_2019;

SELECT * FROM election_2019;

INSERT election_2019
SELECT *
FROM constituency_wise_results_2019;
SELECT * FROM election_2019;


-- ------------- DATA CLEANING ---------------
-- --------- DUPLICATES 
WITH duplicate_cte  AS(
						SELECT *,
						ROW_NUMBER() OVER(
						PARTITION BY state, pc_name, sex, category ,party,party_symbol,total_votes) AS row_num
						FROM election_2014)
                        
SELECT * FROM duplicate_cte
WHERE row_num >1;
/*No duplicate in election_2014*/

WITH duplicate_cte  AS(
						SELECT *,
						ROW_NUMBER() OVER(
						PARTITION BY state, pc_name, sex, category ,party,party_symbol,total_votes) AS row_num
						FROM election_2019)
                        
SELECT * FROM duplicate_cte
WHERE row_num >1;

-- Same name constituencies -------------
WITH cte  AS(SELECT pc_name ,state from election_2014
GROUP BY pc_name,state),

cte2  AS(        SELECT *,
						ROW_NUMBER() OVER(
						PARTITION BY pc_name) AS num
						FROM cte  )
 SELECT pc_name , num FROM cte2
 WHERE num>1;
 -- 2019
 WITH cte  AS(SELECT pc_name ,state from election_2019
GROUP BY pc_name,state),

cte2  AS(        SELECT *,
						ROW_NUMBER() OVER(
						PARTITION BY pc_name) AS num
						FROM cte  )
 SELECT pc_name , num FROM cte2
 WHERE num>1;
 
SELECT pc_name, state FROM election_2014 WHERE pc_name ='Aurangabad'  GROUP BY pc_name,state ; -- Bihar and Maharastra
SELECT pc_name, state FROM election_2014  WHERE pc_name ='Hamirpur'  GROUP BY pc_name,state ;  -- Himachal Pradesh and Uttar Pradesh
SELECT pc_name, state FROM election_2014  WHERE pc_name ='Maharajganj' GROUP BY pc_name,state ; --  Bihar , Uttar Pradesh

-- Updating names to give Proper validation to constituencies
-- Aurangabad
UPDATE election_2014
SET pc_name ='Aurangabad_Bihar'
WHERE pc_name ='Aurangabad' and state ='Bihar';
SELECT * from election_2014 WHERE pc_name ='Aurangabad_Bihar';

-- Hamirpur 
UPDATE election_2014
SET pc_name ='Hamirpur_UP'
WHERE pc_name ='HamirpuR' AND state='Uttar Pradesh';
SELECT * from election_2014 WHERE pc_name ='Hamirpur_UP';

-- Maharaj ganj
UPDATE election_2014
SET pc_name ='Maharajganj_Bihar'
WHERE pc_name ='Maharajganj' and state ='Bihar';
SELECT * from election_2014 WHERE pc_name ='Maharajganj_Bihar';

-- SAME FOR 2019 
UPDATE election_2019
SET pc_name ='Aurangabad_Bihar'
WHERE pc_name ='Aurangabad' and state ='Bihar';
SELECT * from election_2014 WHERE pc_name ='Aurangabad_Bihar';

-- Hamirpur 
UPDATE election_2019
SET pc_name ='Hamirpur_UP'
WHERE pc_name ='HamirpuR' AND state='Uttar Pradesh';
SELECT * from election_2014 WHERE pc_name ='Hamirpur_UP';

-- Maharaj ganj
UPDATE election_2019
SET pc_name ='Maharajganj_Bihar'
WHERE pc_name ='Maharajganj' and state ='Bihar';
SELECT * from election_2014 WHERE pc_name ='Maharajganj_Bihar';

SELECT * from election_2014 WHERE state='Andhra Pradesh';

-- 2. In 2014, Andhra Pradesh underwent Bifurcation. Hence , updating required constituencies to Telangana
UPDATE election_2014
      SET state ='Telangana'
      WHERE pc_name in  (Select pc_name from election_2019 where state='Telangana');
      
SELECT state, pc_name  from election_2014
GROUP BY state , pc_name;
