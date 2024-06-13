-- Q1: Show first name, last name, and gender of patients whose gender is 'M'

SELECT first_name, last_name, gender 
FROM patients 
WHERE gender = 'M';


-- Q2: Show first name and last name of patients who does not have allergies. (null)

SELECT first_name, last_name 
FROM patients 
WHERE allergies IS NULL;


-- Q3: Show first name of patients that start with the letter 'C'.

SELECT first_name 
FROM patients 
WHERE first_name LIKE 'C%';


-- Q4: Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)

SELECT first_name, last_name 
FROM patients 
WHERE weight BETWEEN 100 AND 120;


-- Q5: Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'

UPDATE patients 
SET allergies = 'NKA'
WHERE allergies IS NULL;


-- Q6: Show first name and last name concatinated into one column to show their full name.

SELECT CONCAT(first_name, ' ', last_name) AS full_name 
FROM patients;


-- Q7: Show first name, last name, and the full province name of each patient. Example: 'Ontario' instead of 'ON'

    -- province_names = PN
    -- patients = PA
SELECT PA.first_name, PA.last_name, PN.province_name 
FROM patients AS PA 
JOIN province_names AS PN ON PA.province_id = PN.province_id;


-- Q8: Show how many patients have a birth_date with 2010 as the birth year.
SELECT COUNT(patient_id) AS total_paitents 
FROM patients 
WHERE YEAR(birth_date) = 2010;


-- Q9: Show the first_name, last_name, and height of the patient with the greatest height.

SELECT first_name, last_name, MAX(height) AS height 
FROM patients;


-- Q10: Show all columns for patients who have one of the following patient_ids: 1, 45, 534, 879, 1000

SELECT * 
FROM patients 
WHERE patient_id IN (1, 45, 534, 879, 1000);


-- Q11: Show the total number of admissions.

SELECT COUNT(patient_id) AS total_admissions 
FROM admissions;


-- Q12: Show all the columns from admissions where the patient was admitted and discharged on the same day.

SELECT * 
FROM admissions 
WHERE admission_date = discharge_date;


-- Q13: Show the patient id and the total number of admissions for patient_id 579.

SELECT patient_id, COUNT(patient_id) AS total_admissions 
FROM admissions 
WHERE patient_id = 579;


-- Q14: Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?

SELECT distinct city AS unique_cities 
FROM patients 
WHERE province_id = 'NS';


-- Q15: Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70.

SELECT first_name, last_name, birth_date 
FROM patients 
WHERE height > 160 AND weight > 70;


-- Q16: Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'

SELECT first_name, last_name, allergies 
FROM patients 
WHERE where city = 'Hamilton' AND allergies IS NOT NULL;


-- Q17: Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u). Show the result order in ascending by city.

SELECT DISTINCT city 
FROM patients 
WHERE city LIKE('a%') OR city LIKE('e%') OR city LIKE('i%') OR city LIKE('o%') OR city LIKE('u%') ORDER BY city ASC;
