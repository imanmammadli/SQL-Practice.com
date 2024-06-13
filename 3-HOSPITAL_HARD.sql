-- Q1: Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group.
  --Order the list by the weight group decending. For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.

SELECT COUNT(patient_id) AS patients_in_group, FLOOR(weight / 10)*10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;


-- Q2: Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. 
  --Obese is defined as weight(kg)/(height(m)2) >= 30. weight is in units kg. height is in units cm.

SELECT patient_id, weight, height, 
CASE
  WHEN weight / POWER(height/100.0,2) >= 30 THEN 1
  ELSE 0
END AS isObese
FROM patients;


-- Q3: Show patient_id, first_name, last_name, and attending doctor's specialty. 
    --Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'
    --Check patients, admissions, and doctors tables for required information.
    
    --patients = PA
    --admissions = AD
    --doctors = DR

SELECT PA.patient_id, 
      PA.first_name AS patient_first_name, 
      PA.last_name AS patient_last_name, 
      DR.specialty
FROM patients AS PA 
JOIN admissions AS AD ON AD.patient_id = PA.patient_id
JOIN doctors AS DR ON AD.attending_doctor_id = DR.doctor_id
WHERE AD.diagnosis = 'Epilepsy' AND DR.first_name = 'Lisa';


-- Q4: All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.
    --The password must be the following, in order:
    --1. patient_id
    --2. the numerical length of patient's last_name
    --3. year of patient's birth_date

SELECT distinct AD.patient_id, CONCAT(PA.patient_id, LEN(PA.last_name), YEAR(PA.birth_date)) AS temp_password
FROM patients AS PA 
JOIN admissions AS AD ON PA.patient_id = AD.patient_id;


-- Q5: Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
    --Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.

SELECT 
    CASE 
        WHEN patient_id % 2 = 0 THEN 'Yes' 
        ELSE 'No'
    END AS has_insurance, 
    sum(CASE 
            WHEN patient_id % 2 = 0 THEN 10
    	      ELSE 50
        END) AS cost_after_insurance
FROM admissions 
GROUP BY has_insurance;


-- Q6: Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name
    
    --patients = PA
    --province_names = PN
    
SELECT PN.province_name  
FROM province_names AS PN 
JOIN patients AS PA ON PN.province_id = PA.province_id
GROUP BY PN.province_name
HAVING count(CASE 
                WHEN gender = 'M' THEN 1
            END)	
        >
       count(CASE 
                WHEN gender = 'F' THEN 1
            END);


-- Q7: We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
    -- First_name contains an 'r' after the first two letters.
    -- Identifies their gender as 'F'
    -- Born in February, May, or December
    -- Their weight would be between 60kg and 80kg
    -- Their patient_id is an odd number
    -- They are from the city 'Kingston'

SELECT * 
FROM patients
WHERE first_name like('__r%') AND gender = 'F' AND month(birth_date) in (2, 5, 12) AND 
      weight BETWEEN 60 AND 80 AND patient_id % 2 = 1 AND city = 'Kingston';


-- Q8: Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.

SELECT CONCAT(ROUND(CAST(
        (SELECT COUNT(1) FROM patients WHERE gender='M') AS float) * 100 / CAST((SELECT COUNT(1) FROM patients) AS float), 2),'%')


-- Q9: For each day display the total amount of admissions on that day. Display the amount changed from the previous date

SELECT admission_date, COUNT(admission_date) AS admission_day, 
      COUNT(admission_date) - LAG(COUNT(admission_date)) OVER(ORDER BY admission_date) AS admission_count_change 
FROM admissions
GROUP BY admission_date;


-- Q10: Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.

SELECT province_name
FROM province_names
ORDER BY (CASE 
              WHEN province_name = 'Ontario' THEN 0 
              ELSE 1 
              END), 
          province_name;


-- Q11: We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
    
    --admissions = AD
    --doctors = DR

SELECT DR.doctor_id, CONCAT(DR.first_name, ' ', DR.last_name) AS doctor_name, 
      DR.specialty, YEAR(AD.admission_date) AS selected_year, 
      COUNT(AD.patient_id) AS total_admissions 
FROM admissions AS AD 
LEFT JOIN doctors AS DR ON AD.attending_doctor_id = DR.doctor_id
GROUP BY doctor_name, selected_year;

