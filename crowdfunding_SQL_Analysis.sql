-- Challenge Bonus queries.
-- 1. (2.5 pts)
-- Retrieve all the number of backer_counts in descending order for each `cf_id` for the "live" campaigns. 
SELECT camp.cf_id, camp.backers_count, camp.outcome
FROM campaign AS camp
WHERE camp.outcome= 'live'
GROUP BY camp.cf_id
ORDER BY camp.cf_id DESC;


-- 2. (2.5 pts)
-- Using the "backers" table confirm the results in the first query.
SELECT COUNT (b.backer_id), b.cf_id
FROM backers AS b
GROUP BY b.cf_id
ORDER BY b.cf_id DESC;


-- 3. (5 pts)
-- Create a table that has the first and last name, and email address of each contact.
-- and the amount left to reach the goal for all "live" projects in descending order. 
SELECT con.first_name,
	con.last_name,
	con.email,
	camp.goal,
	camp.pledged,
	camp.outcome
INTO email_contacts_remaining_goal_amount_initial
FROM campaign AS camp 
	INNER JOIN contacts AS con
		ON (con.contact_id = camp.contact_id)
WHERE camp.outcome= 'live' 

ALTER TABLE "email_contacts_remaining_goal_amount_initial" 
ADD "remaining_goal_amount" int;

UPDATE email_contacts_remaining_goal_amount_initial SET remaining_goal_amount=goal-pledged

ALTER TABLE "email_contacts_remaining_goal_amount_initial"
ALTER COLUMN "remaining_goal_amount" SET NOT NULL,
DROP COLUMN goal,
DROP COLUMN pledged,
DROP COlUMN outcome;
	
SELECT * FROM email_contacts_remaining_goal_amount_initial
ORDER BY remaining_goal_amount DESC;
	
SELECT ecrgi.first_name,
	ecrgi.last_name,
	ecrgi.email,
	ecrgi.remaining_goal_amount
INTO email_contacts_remaining_goal_amount
FROM email_contacts_remaining_goal_amount_initial AS ecrgi
ORDER BY ecrgi.remaining_goal_amount DESC
-- Check the table
SELECT * FROM email_contacts_remaining_goal_amount


-- 4. (5 pts)
-- Create a table, "email_backers_remaining_goal_amount" that contains the email address of each backer in descending order, 
-- and has the first and last name of each backer, the cf_id, company name, description, 
-- end date of the campaign, and the remaining amount of the campaign goal as "Left of Goal". 
SELECT b.email,
	b.first_name,
	b.last_name,
	camp.cf_id,
	camp.company_name,
	camp.description,
	camp.end_date,
	camp.goal,
	camp.outcome,
	camp.pledged
INTO email_backers_remaining_goal_amount_initial
FROM campaign AS camp 
	INNER JOIN backers AS b
		ON (camp.cf_id = b.cf_id)
WHERE camp.outcome = 'live' --AND b.first_name = 'Monika'
ORDER BY b.email DESC 

ALTER TABLE "email_backers_remaining_goal_amount_initial" 
ADD "Left_of_Goal" int;

UPDATE email_backers_remaining_goal_amount_initial SET "Left_of_Goal"=goal-pledged

ALTER TABLE "email_backers_remaining_goal_amount_initial"
ALTER COLUMN "Left_of_Goal" SET NOT NULL,
DROP COLUMN goal,
DROP COLUMN pledged,
DROP COLUMN outcome;
	
SELECT * FROM email_backers_remaining_goal_amount_initial
	
SELECT email,
	first_name,
	last_name,
	cf_id,
	company_name,
	description,
	end_date,
	"Left_of_Goal"
INTO email_backers_remaining_goal_amount
FROM email_backers_remaining_goal_amount_initial
--WHERE first_name = 'Shelton'
ORDER BY last_name ASC


-- Check the table
SELECT * FROM email_backers_remaining_goal_amount