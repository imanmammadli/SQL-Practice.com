-- Q1: Show unique birth years from patients and order them by ascending.

SELECT DISTINCT YEAR(birth_date) AS birth_year 
FROM patients 
ORDER BY birth_year;


-- Q2: Show unique first names from the patients table which only occurs once in the list.
  --For example, if two or more people are named 'John' in the first_name column then don't 
  --include their name in the output list. If only 1 person is named 'Leo' then include them in the output.

SELECT DISTINCT first_name 
FROM patients 
GROUP BY first_name 
HAVING COUNT(first_name) = 1;


-- Q3: Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.

SELECT patient_id, first_name 
FROM patients 
WHERE first_name LIKE 's%____%s';


-- Q4: Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.

    -- patients = PA
    -- admissions = AD

SELECT PA.patient_id, PA.first_name, PA.last_name 
FROM patients AS PA 
JOIN admissions AS AD ON PA.patient_id = AD.patient_id
WHERE AD.diagnosis = 'Dementia';


-- Q5: Display every patient's first_name. Order the list by the length of each name and then by alphabetically

SELECT first_name 
FROM patients 
ORDER BY LEN(first_name), first_name;


-- Q6: Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.

SELECT 
  (SELECT COUNT(patient_id) AS male_count FROM patients WHERE gender = 'M'),
	(SELECT COUNT(patient_id) AS female_count FROM patients WHERE gender = 'F')
	


-- Q7: Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. 
    -- Show results ordered ascending by allergies then by first_name then by last_name.

SELECT first_name, last_name, allergies FROM patients 
WHERE allergies = 'Penicillin' OR allergies = 'Morphine'
ORDER BY allergies, first_name, last_name;


-- Q8: Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.

SELECT patient_id, diagnosis 
FROM admissions GROUP patient_id, diagnosis 
HAVING COUNT(*) > 1;


-- Q9: Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.

SELECT DISTINCT city, COUNT(patient_id) AS num_patients 
FROM patients 
GROUP BY city 
ORDER BY num_patients DESC, city ASC;


-- Q10: Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"

SELECT first_name, last_name, 'Patient' 
FROM patients
                UNION ALL
SELECT first_name, last_name, 'Doctor' 
FROM doctors;


-- Q11: Show all allergies ordered by popularity. Remove NULL values from query.

SELECT allergies, COUNT(allergies) AS total_diagnosis 
FROM patients 
WHERE allergies IS NOT NULL 
GROUP BY allergies 
ORDER BY total_diagnosis DESC;


-- Q12: Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.

SELECT first_name, last_name, birth_date 
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979 
ORDER BY birth_date ASC;


-- Q13: We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, 
    --then first_name in all lower case letters. Separate the last_name and first_name with a comma. 
    --Order the list by the first_name in decending order. 
    -- EX: SMITH,jane

SELECT CONCAT(UPPER(last_name),',',LOWER(first_name)) AS new_name_format 
FROM patients 
ORDER BY first_name DESC;


-- Q14: Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.

SELECT province_id, SUM(height) AS sum_height 
FROM patients 
GROUP BY province_id 
HAVING sum_height > 7000 
ORDER BY sum_height ASC;


-- Q15: Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

SELECT (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients 
WHERE last_name = 'Maroni';


-- Q16: Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.

SELECT DAY(admission_date) AS day_number, COUNT(patient_id) AS number_of_admissions
FROM admissions 
GROUP BY day_number 
ORDER BY number_of_admissions DESC;


-- Q17: Show all columns for patient_id 542's most recent admission_date.

SELECT * 
FROM admissions 
WHERE patient_id = 542 
GROUP BY patient_id 
HAVING admission_date = MAX(admission_date)


-- Q18: Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
    --1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
    --2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

SELECT patient_id, attending_doctor_id, diagnosis 
FROM admissions
WHERE (patient_id % 2 == 1 AND attending_doctor_id IN (1, 5, 19)) 
      OR 
      (attending_doctor_id like '%2%' AND LEN(patient_id) = 3)


-- Q19: Show first_name, last_name, and the total number of admissions attended for each doctor.
    --Every admission has been attended by a doctor.
    
    --Doctors = DR
    --Admissions = AD

SELECT DR.first_name, DR.last_name, COUNT(AD.patient_id) AS admissions_total 
FROM admissions AS AD 
JOIN doctors AS DR ON AD.attending_doctor_id = DR.doctor_id
GROUP BY DR.doctor_id;


-- Q20: For each doctor, display their id, full name, and the first and last admission date they attended.
      --Doctors = DR
      --Admissions = AD

SELECT DR.doctor_id, 
      CONCAT(DR.first_name, ' ', DR.last_name), 
      MIN(AD.admission_date) AS first_admission_date, 
      MAX(AD.admission_date) AS last_admission_date
FROM admissions AS AD 
JOIN doctors AS DR ON AD.attending_doctor_id = DR.doctor_id
GROUP BY doctor_id;


-- Q21: Display the total amount of patients for each province. Order by descending.
      --Patients = PA
      --Province Names = PN
      
SELECT PN.province_name, COUNT(PA.patient_id) AS patient_count 
FROM province_names AS PN 
JOIN patients AS PA ON PN.province_id = PA.province_id
GROUP BY PN.province_name
ORDER BY patient_count desc;


-- Q22: For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
      --admissions = AD
      --patients = PA
      --doctors = DR

SELECT CONCAT(PA.first_name, ' ', PA.last_name) AS patient_name, 
      AD.diagnosis, 
      CONCAT(DR.first_name, ' ', DR.last_name) AS doctor_name
FROM admissions AS AD 
JOIN patients AS PA ON AD.patient_id = PA.patient_id 
JOIN doctors AS DR ON AD.attending_doctor_id = DR. doctor_id;


-- Q23: display the number of duplicate patients based on their first_name and last_name.

SELECT first_name, last_name, COUNT(patient_id) AS num_of_dublicates 
FROM patients
GROUP BY first_name, last_name
HAVING num_of_dublicates=2;


-- Q24: Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals,
    --birth_date, gender non abbreviated. Convert CM to feet by dividing by 30.48. Convert KG to pounds by multiplying by 2.205.

SELECT CONCAT(first_name, ' ', last_name) AS patient_name, 
    ROUND(height/30.48,1) AS 'height "Feet"', 
    ROUND(weight*2.205,0) AS 'weight "Pounds"', 
    birth_date,
    CASE 
      WHEN gender = 'M' THEN 'MALE'
      ELSE'FEMALE'
    END AS gender_type
FROM patients;


-- Q26: Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)
    --admissions = AD
    --patients = PA
    
SELECT PA.patient_id, PA.first_name, PA.last_name 
FROM patients AS PA 
LEFT JOIN admissions AS AD ON PA.patient_id = AD.patient_id
WHERE AD.patient_id IS NULL;


