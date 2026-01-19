USE p_p;
SHOW TABLES;
SELECT * FROM colleges;
SELECT * FROM edtech_usage;
SELECT * FROM performance;
SELECT * FROM students;
-- colleges -->college_id(pk)
-- edtech_usage -->usage_id(pk) , student_id(fk)
-- performance -->performance_id (pk) , student_id(fk)
-- students -->student_id (pk) , college_id (fk)

/* SECTION A — MySQL Tasks
------1. Basic Queries-------------*/
-- 1. List all colleges that adopted AI in 2024.
SELECT college_name
FROM colleges
WHERE adoption_year = 2024;

-- 2. Find the number of students in each department.
SELECT department ,
		count(student_id)
FROM students
GROUP BY department;

-- 3. Show the average GPA before and after AI adoption for each college.
SELECT C.college_name ,
		AVG(P.gpa_before_ai) AS avg_gpa_before_AI,
        AVG(P.gpa_after_ai) AS avg_gpa_after_AI
FROM students S 
JOIN performance P ON P.student_id = S.student_id
JOIN colleges C ON S.college_id = C.college_id
GROUP BY C.college_name;
	
-- 2. Intermediate Queries---------------
-- 4. Identify the top 10 students with the highest “hours_spent” on EdTech platforms.
SELECT student_id,
	   sum(hours_spent) AS max_hours_spent
FROM edtech_usage
GROUP BY student_id 
ORDER BY SUM(hours_spent) DESC
LIMIT 10;

-- 5. Show the correlation pattern: students who accepted more AI recommendations vs. change in GPA.
SELECT p.student_id ,
		SUM(e.ai_recommendations_accepted) AS more_AI_recommendations_Accepted,
        ROUND(SUM(p.gpa_after_ai) - SUM(p.gpa_before_ai) , 2)AS Change_in_GPA
FROM performance p 
JOIN edtech_usage e
ON p.student_id = e.student_id
GROUP BY p.student_id
ORDER BY more_AI_recommendations_Accepted ;

/* 6. Compare attendance improvement:
o Calculate “attendance_after_ai – attendance_before_ai” for each student.*/

SELECT student_id ,
	   SUM(attendance_after_ai) - SUM(attendance_before_ai) AS Change_in_attendence
FROM performance
GROUP BY student_id;

-- 3. Advanced & Insightful Queries ----------------

-- 7. Find which AI platform (LearnAI, SmartTutor, MindEd) resulted in the highest average GPA improvement.

SELECT c.ai_platform,
		ROUND(AVG (p.gpa_after_ai - p.gpa_before_ai) ,2) AS average_GPA_improvement
FROM colleges c
JOIN students s ON c.college_id = s.college_id
JOIN performance p ON p.student_id = s.student_id
GROUP BY c.ai_platform
ORDER BY average_GPA_improvement DESC;
    
    
/*8. Check whether increased usage hours lead to better quiz performance:
o Group by student, calculate total hours and total quizzes, and compare.*/
SELECT  student_id,
		SUM(hours_spent) AS total_hours,
        SUM(quizzes_taken) AS total_quizzes
FROM edtech_usage
GROUP BY student_id;
        
-- 9. Identify departments most benefited from AI adoption (highest GPA improvement grouped by department).
SELECT s.department ,
	   ROUND(MAX(p.gpa_after_ai - p.gpa_before_ai) , 2) AS Highest_GPA_improvement
FROM performance p 
JOIN students s 
ON p.student_id = s.student_id
GROUP BY s.department ;
		

-- 10. Determine if first-year students or final-year students gained the most improvement.
SELECT 	s.year_of_study,
		ROUND(MAX(p.gpa_after_ai - p.gpa_before_ai) , 2) AS Highest_GPA_improvement
FROM performance p 
JOIN students s 
ON p.student_id = s.student_id
GROUP BY s.year_of_study
HAVING s.year_of_study IN (1 , 4);
        
		



		










        








