/*****************************************
 * RETRIEVING  RECORDS FROM THE DATABASE *
 *****************************************/

/*****************
 * SIMPLE SELECT *
 *****************/

/* Using one SELECT statement per table: */

/* Write queries to retrieve records from the tables without any condition. */
SELECT * FROM student;
SELECT * FROM student_major;
SELECT * FROM course;
SELECT * FROM course_section;
SELECT * FROM instructor;
SELECT * FROM department;
SELECT * FROM teaching_interests;
SELECT * FROM research_interests;
SELECT * FROM cheating_incident;
SELECT * FROM student_involved;
SELECT * FROM current_member;
SELECT * FROM enrolls;
SELECT * FROM postal;
SELECT * FROM graduate;
SELECT * FROM employer;
SELECT * FROM employment_record;
SELECT * FROM taught_courses;

/* Write queries to retrieve all records from each table using a simple condition. */
SELECT * FROM department WHERE dept_id = 1;
SELECT * FROM course WHERE course_code = "CMP 101";
SELECT * FROM postal WHERE postal_code = 10001;
SELECT * FROM current_member WHERE emplid = 2001;
SELECT * FROM instructor WHERE emplid = 1004;
SELECT * FROM student WHERE emplid = 2003;
SELECT * FROM student_major WHERE major = "Computer Science";
SELECT * FROM course_section WHERE sect_id = 31;
SELECT * FROM enrolls WHERE emplid = 2002;
SELECT * FROM taught_courses WHERE emplid = 1003;
SELECT * FROM research_interests WHERE emplid = 1005;
SELECT * FROM cheating_incident WHERE incident_id = 92;
SELECT * FROM student_involved WHERE emplid = 2004;
SELECT * FROM graduate WHERE degree = "Computer Science";
SELECT * FROM employer WHERE employer_id = 1;
SELECT * FROM employment_record WHERE end_date IS NULL;

/********************************
 * ADVANCED SELECT (TWO TABLES) *
 ********************************/

/* Write a query to get the students who have cheated and the description of the incident. */
SELECT
  CM.emplid,
  CM.fname AS first_name,
  CM.lname AS last_name,
  CI.incident_description
FROM current_member CM
JOIN student S ON CM.emplid = S.emplid
INNER JOIN student_involved SI ON S.emplid = SI.emplid
INNER JOIN cheating_incident CI ON SI.incident_id = CI.incident_id;

/* Write a query to retrieve the instructors and their teaching interests. */
SELECT
  CM.emplid,
  CM.fname AS first_name,
  CM.lname AS last_name,
  TI.teaching_interests
FROM current_member CM
JOIN instructor I ON CM.emplid = I.emplid
LEFT JOIN teaching_interests TI ON I.emplid = TI.emplid;


/* Write a query to retrieve students who have only received "A" grades in all their courses. */
SELECT
  CM.emplid,
  CM.fname as first_name,
  CM.lname as last_name
FROM current_member CM
JOIN student S ON CM.emplid = S.emplid
WHERE CM.emplid NOT IN (
    SELECT E.emplid
    FROM enrolls E
    WHERE E.grade <> "A"
);

/* Write a query to retrieve the students who have not taken more than 2 courses. */
SELECT
  CM.fname as first_name,
  CM.lname as last_name
FROM current_member CM
JOIN student S ON CM.emplid = S.emplid
JOIN enrolls E ON S.emplid = e.Emplid
GROUP BY CM.fname, CM.lname
HAVING COUNT(DISTINCT E.sect_id) <= 2;

/* Write a query to retrieve the students who were caught cheating in at least one course. */
SELECT DISTINCT
  CM.emplid,
  CM.fname as first_name,
  CM.lname as last_name
FROM current_member CM
JOIN student_involved SI ON CM.emplid = SI.emplid;

/* Write a query to retrieve the instructor who has reported the most cheating incidents. */
SELECT
  CM.emplid,
  CM.fname as first_name,
  CM.lname as last_name,
  COUNT(CI.incident_id) as incidents_reported
FROM current_member CM
JOIN instructor I ON CM.emplid = I.emplid
JOIN cheating_incident CI ON CI.emplid = I.emplid
GROUP BY CM.fname, CM.lname
ORDER BY COUNT(CI.incident_id) DESC
LIMIT 1;

/* Write a query to retrieve the instructors who have never reported any cheating incidents. */
SELECT
  CM.emplid,
  CM.fname as first_name,
  CM.lname as last_name
FROM current_member CM
JOIN instructor I ON CM.emplid = I.emplid
LEFT JOIN cheating_incident CI ON I.emplid = CI.emplid
WHERE CI.incident_id IS NULL;

/* Write a query to retrieve the name of the most recently hired instructor. */
SELECT
  CM.emplid,
  CM.fname as first_name,
  CM.lname as last_name,
  I.hire_date
FROM current_member CM
JOIN instructor I ON CM.emplid = I.emplid
ORDER BY I.hire_date DESC
LIMIT 1;

/*******************
 * MODIFY DATABASE *
 *******************/

/* Write statements to update certain records based on some conditions. */
UPDATE department
SET dept_name = "History",
    phone = "555-412-5532",
    location = "Brooklyn, NY"
WHERE dept_id = 5;

UPDATE course
SET course_code = 5,
    hours = 5.0,
    credits = 3,
    description = "Introduction to History",
    course_name = "Modern History"
WHERE course_name = "Game Development";

/* Write statements to delete records from tables based on some conditions. */
DELETE FROM employment_record
WHERE employer_id = 901234;

DELETE FROM postal
WHERE postal_code = 10002;

DELETE FROM enrolls
WHERE emplid = 2002 AND sect_id = 32;
