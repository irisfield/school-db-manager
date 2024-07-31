/*************************************
 * DEFINE THE SCHOOL DATABASE SCHEMA *
 *************************************/

/* For the tables defined below:
 * Ensure referential integrity is maintained with
 * cascading actions for both updates and deletions.
 * Cascading actions automatically update or delete
 * related rows in child tables when changes occur in
 * parent tables, ensuring data consistency.
 */

/* Create a database for managing the school system. */
CREATE DATABASE school_management;

/* Select the database to work with. */
USE school_management;

/* Table to store department information. */
CREATE TABLE department (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(200),
  phone VARCHAR(14),
  location VARCHAR(200)
);

/* Table to store course information. */
CREATE TABLE course (
  course_id INT PRIMARY KEY,
  dept_id INT,
  course_code VARCHAR(20),
  hours DECIMAL(4, 2),
  credits INT,
  description VARCHAR(400),
  course_name VARCHAR(200),
  /* Foreign key constraint */
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to store postal information. */
CREATE TABLE postal (
  postal_code INT PRIMARY KEY,
  city VARCHAR(20),
  state VARCHAR(20)
);


/* Table to store current member (student or instructor) information. */
CREATE TABLE current_member (
  emplid INT PRIMARY KEY,
  fname VARCHAR(20),
  lname VARCHAR(20),
  email VARCHAR(40),
  phone VARCHAR(12),
  street VARCHAR(40),
  postal_code INT,
  /* Foreign key constraint */
  FOREIGN KEY (postal_code) REFERENCES postal(postal_code)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to store instructor information (inherits from current_member). */
CREATE TABLE instructor (
  emplid INT PRIMARY KEY,
  hire_date DATE,
  office_location VARCHAR(100),
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES current_member(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to record courses taught by instructor. */
CREATE TABLE taught_courses (
  emplid INT,
  course_id INT,
  /* Composite primary key */
  PRIMARY KEY (emplid, course_id),
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES instructor(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES course(course_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to record instructor's teaching interests. */
CREATE TABLE teaching_interests (
  emplid INT,
  teaching_interests VARCHAR(500),
  /* Composite primary key */
  PRIMARY KEY (teaching_interests, emplid),
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES instructor(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to record instructor's research interests. */
CREATE TABLE research_interests (
  emplid INT,
  research_interests VARCHAR(500),
  /* Composite primary key */
  PRIMARY KEY (research_interests, emplid),
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES instructor(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to store course section information. */
CREATE TABLE course_section (
  sect_id INT PRIMARY KEY,
  semester_year INT,
  room_no INT,
  emplid INT,
  schedule VARCHAR(40),
  course_id INT,
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES instructor(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES course(course_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to store student information (inherits from current_member). */
CREATE TABLE student (
  emplid INT PRIMARY KEY,
  dob DATE,
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES current_member(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to store student major information. */
CREATE TABLE student_major (
  major VARCHAR(25),
  emplid INT,
  /* Composite primary key */
  PRIMARY KEY (major, emplid),
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES student(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to record cheating incidents. */
CREATE TABLE cheating_incident (
  incident_id INT PRIMARY KEY,
  incident_date DATE,
  incident_description VARCHAR(100),
  sect_id INT,
  emplid INT,
  /* Foreign key constraint */
  FOREIGN KEY (sect_id) REFERENCES course_section(sect_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (emplid) REFERENCES instructor(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to record students involved in cheating incidents. */
CREATE TABLE student_involved (
  emplid INT,
  incident_id INT,
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES student(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (incident_id) REFERENCES cheating_incident(incident_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to record student enrollments in course sections. */
CREATE TABLE enrolls (
  emplid INT,
  sect_id INT,
  grade CHAR,
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES student(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (sect_id) REFERENCES course_section(sect_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to record graduation information. */
CREATE TABLE graduate (
  emplid INT PRIMARY KEY,
  grad_date DATE,
  degree VARCHAR(20),
  /* Foreign key constraint */
  FOREIGN KEY (emplid) REFERENCES student(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to store employer information. */
CREATE TABLE employer (
  employer_id INT PRIMARY KEY,
  employer_name VARCHAR(30),
  industry VARCHAR(100),
  street VARCHAR(40),
  postal_code INT,
  /* Foreign key constraint */
  FOREIGN KEY (postal_code) REFERENCES postal(postal_code)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

/* Table to record employment records. */
CREATE TABLE employment_record (
  position VARCHAR(40),
  start_date DATE,
  end_date DATE,
  employer_id INT,
  emplid INT,
  /* Foreign key constraint */
  FOREIGN KEY (employer_id) REFERENCES employer(employer_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (emplid) REFERENCES graduate(emplid)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);


/********************************
 * POPULATE THE SCHOOL DATABASE *
 ********************************/

/* Insert data into the department table. */
INSERT INTO department (dept_id, dept_name, phone, location)
VALUES
  (1, "Computer Science", "555-123-4567", "New York, NY"),
  (2, "English Literature", "555-234-5678", "New York, NY"),
  (3, "Mathematics", "555-345-6789", "New York, NY"),
  (4, "Biology", "555-456-7890", "New York, NY"),
  (5, "Health Sciences", "555-567-8901", "Queens, NY"),
  (6, "Nursing", "555-678-9012", "Brooklyn, NY"),
  (7, "Physics", "555-789-0123", "Bronx, NY"),
  (8, "Business Administration", "555-890-1234", "Bronx, NY"),
  (9, "Economics", "555-901-2345", "Bronx, NY");

/* Insert data into the course table. */
INSERT INTO course (course_id, dept_id, course_code, hours, credits, description, course_name)
VALUES
  (101, 1, "CMP 101", 4.0, 4, "Introduction to Database Systems", "Database Systems"),
  (102, 2, "ENG 201", 3.5, 3, "Advanced Writing Techniques", "Creative Writing"),
  (103, 3, "MAT 301", 4.0, 4, "Fundamentals of Networking", "Networking Fundamentals"),
  (104, 4, "BIO 202", 3.0, 3, "Introduction to Python Programming", "Intro to Python"),
  (105, 5, "HLT 303", 4.0, 4, "Principles of Game Development", "Game Development"),
  (106, 6, "NUR 204", 3.5, 3, "Object-Oriented Programming Concepts", "OOP Fundamentals"),
  (107, 7, "PHY 305", 4.0, 4, "Principles of Modern Physics", "Modern Physics"),
  (108, 8, "BUS 401", 3.0, 3, "Business Strategy and Management", "Business Administration"),
  (109, 9, "ECO 202", 3.5, 3, "Introduction to Microeconomics", "Microeconomics");

/* Insert data into the postal table. */
INSERT INTO postal (postal_code, city, state)
VALUES
  (10001, "New York", "NY"),
  (10002, "New York", "NY"),
  (11101, "Queens", "NY"),
  (11201, "Brooklyn", "NY"),
  (10451, "Bronx", "NY"),
  (10452, "Bronx", "NY"),
  (10453, "Bronx", "NY"),
  (30301, "Atlanta", "GA"),
  (60614, "Chicago", "IL"),
  (98101, "Seattle", "WA"),
  (94105, "San Francisco", "CA"),
  (02110, "Boston", "MA"),
  (33101, "Miami", "FL"),
  (77001, "Houston", "TX"),
  (20001, "Washington", "DC"),
  (75201, "Dallas", "TX");

/* Insert data into the current member table. */
INSERT INTO current_member (emplid, fname, lname, email, phone, street, postal_code)
VALUES
  (1001, "Rose", "Lily", "rose.lily@school.edu", "678-678-6789", "3456 Street", 10001),
  (1002, "Daisy", "Tulip", "daisy.tulip@school.edu", "453-545-4567", "4565 Street", 10002),
  (1003, "Orchid", "Iris", "orchid.iris@school.edu", "564-645-6789", "9768 Street", 11101),
  (1004, "Violet", "Jasmine", "violet.jasmine@school.edu", "234-234-2345", "567 Street", 11201),
  (1005, "Lily", "Peony", "lily.peony@school.edu", "685-874-5678", "125 Street", 10451),
  (1006, "Marigold", "Poppy", "marigold.poppy@school.edu", "346-346-5432", "567 Street", 10452),
  (1007, "Camellia", "Azalea", "camellia.azalea@school.edu", "678-678-6789", "234 Street", 10453),
  (1008, "Heather", "Lavender", "heather.lavender@school.edu", "213-421-3421", "677 Street", 10451),
  (1009, "Gardenia", "Hibiscus", "gardenia.hibiscus@school.edu", "345-635-1234", "3254 Street", 10452),
  (2001, "Jasmine", "Sunflower", "jasmine.sunflower@school.edu", "123-456-7890", "111 Maple Ave", 10451),
  (2002, "Lily", "Violet", "lily.violet@school.edu", "234-567-8901", "222 Oak St", 10452),
  (2003, "Dahlia", "Marigold", "dahlia.marigold@school.edu", "345-678-9012", "333 Birch St", 10453),
  (2004, "Tulip", "Poppy", "tulip.poppy@school.edu", "456-789-0123", "444 Cedar St", 11101),
  (2005, "Orchid", "Rose", "orchid.rose@school.edu", "567-890-1234", "555 Elm St", 11201),
  (2006, "Iris", "Carnation", "iris.carnation@school.edu", "678-901-2345", "666 Willow St", 10001),
  (2007, "Peony", "Daisy", "peony.daisy@school.edu", "789-012-3456", "777 Pine St", 10002),
  (2008, "Camellia", "Heather", "camellia.heather@school.edu", "890-123-4567", "888 Spruce St", 11101),
  (2009, "Marigold", "Gardenia", "marigold.gardenia@school.edu", "901-234-5678", "999 Fir St", 10453);

/* Insert data into the instructor table. */
INSERT INTO instructor (emplid, hire_date, office_location)
VALUES
  (1001, "2017-11-29", "505 Pine St, Queens, NY"),
  (1002, "2018-12-02", "404 Oak St, New York, NY"),
  (1003, "2019-06-21", "202 Elm St, New York, NY"),
  (1004, "2020-07-01", "101 Main St, New York, NY"),
  (1005, "2020-08-11", "303 Maple Ave, New York, NY"),
  (1006, "2020-09-24", "707 Cedar St, Bronx, NY"),
  (1007, "2021-04-17", "606 Birch St, Brooklyn, NY"),
  (1008, "2021-08-10", "808 Walnut St, Bronx, NY"),
  (1009, "2022-03-22", "909 Spruce St, Bronx, NY");

/* Insert data into the taught courses table.
 * Note: emplid is a foreign key referencing the instructor table.
 */
INSERT INTO taught_courses (emplid, course_id)
VALUES
  (1001, 103),
  (1002, 101),
  (1002, 106),
  (1003, 107),
  (1004, 104),
  (1005, 105),
  (1006, 106),
  (1007, 107),
  (1008, 109),
  (1009, 108);

/* Insert data into the teaching interests table.
 * Note: emplid is a foreign key referencing the instructor table.
 */
INSERT INTO teaching_interests (emplid, teaching_interests)
VALUES
  (1001, "Mathematics"),
  (1002, "Computer Science"),
  (1003, "Physics"),
  (1004, "Biology"),
  (1005, "Health Sciences"),
  (1006, "Programming"),
  (1007, "Engineering"),
  (1008, "Economics"),
  (1009, "Business");

/* Insert data into the research interests table.
 * Note: emplid is a foreign key referencing the instructor table.
 */
INSERT INTO research_interests (emplid, research_interests)
VALUES
  (1001, "Human Behavior"),
  (1001, "Cognitive Science"),
  (1002, "French Linguistics"),
  (1002, "Translation Studies"),
  (1003, "Artificial Intelligence"),
  (1003, "Machine Learning"),
  (1004, "Object-Oriented Programming"),
  (1004, "Software Development"),
  (1005, "Data Structures"),
  (1005, "Algorithm Optimization"),
  (1006, "Human-Computer Interaction"),
  (1006, "Usability Engineering"),
  (1007, "Human Genetics"),
  (1007, "Evolutionary Biology"),
  (1008, "English Literature"),
  (1008, "Creative Writing"),
  (1009, "Mathematical Theory"),
  (1009, "Applied Mathematics");

/* Insert data into the course section table.
 * Note: emplid is foreign key referencing the instructor table.
 */
INSERT INTO course_section (sect_id, semester_year, room_no, emplid, schedule, course_id)
VALUES
  (31, 2023, "201", 1001, "Mon-Wed 10:00-11:30", 101),
  (32, 2023, "302", 1002, "Tue-Thu 09:00-10:30", 102),
  (33, 2023, "403", 1003, "Mon-Wed 13:00-14:30", 103),
  (34, 2023, "104", 1004, "Tue-Thu 11:00-12:30", 104),
  (35, 2023, "205", 1005, "Mon-Wed 15:00-16:30", 105),
  (36, 2023, "306", 1006, "Tue-Thu 14:00-15:30", 106),
  (37, 2023, "407", 1007, "Mon-Wed 10:00-11:30", 107),
  (38, 2023, "208", 1008, "Tue-Thu 09:00-10:30", 108),
  (39, 2023, "309", 1009, "Mon-Wed 13:00-14:30", 109);

/* Insert data into the student table. */
INSERT INTO student (emplid, dob)
VALUES
  (2001, "2001-10-11"),
  (2002, "1999-11-11"),
  (2003, "2004-05-20"),
  (2004, "2001-08-15"),
  (2005, "2000-12-01"),
  (2006, "2002-09-30"),
  (2007, "2003-07-22"),
  (2008, "2007-10-11"),
  (2009, "2001-10-11");

/* Insert data into the student major table.
 * Note: emplid is a foreign key referencing the student table.
 */
INSERT INTO student_major (major, emplid)
VALUES
  ("Computer Science", 2001),
  ("English Literature", 2002),
  ("Mathematics", 2003),
  ("Biology", 2004),
  ("Health Sciences", 2005),
  ("Nursing", 2006),
  ("Physics", 2007),
  ("Business Administration", 2008),
  ("Economics", 2009);

/* Insert data into the cheating incident table.
 * Note: emplid is a foreign key referencing the instructor table.
 */
INSERT INTO cheating_incident (incident_id, incident_date, incident_description, sect_id, emplid)
VALUES
  (91, "2021-10-10", "Copying during exam", 32, 1001),
  (92, "2021-10-10", "Exam paper exchange", 36, 1006),
  (93, "2022-12-16", "Plagiarism in assignment", 33, 1004),
  (94, "2022-12-16", "Plagiarism in assignment", 33, 1004),
  (95, "2022-12-16", "Plagiarism in assignment", 33, 1004);

/* Insert data into the student involved table.
 * Note: emplid is a foreign key referencing the student table.
 */
INSERT INTO student_involved (emplid, incident_id)
VALUES
  (2001, 91),
  (2003, 92),
  (2006, 93),
  (2007, 94),
  (2008, 95);

/* Insert data into the enrolls table.
 * Note: emplid is a foreign key referencing the student table.
 */
INSERT INTO enrolls (emplid, sect_id, grade)
VALUES
  (2001, 31, "A"),
  (2002, 32, "B"),
  (2003, 33, "C"),
  (2004, 34, "B"),
  (2005, 35, "A"),
  (2006, 36, "C"),
  (2007, 37, "B"),
  (2008, 38, "A"),
  (2009, 39, "B");

/* Insert data into the graduate table.
 * Note: emplid is a foreign key referencing the student table.
 * This table is used to track the expected graduation of students.
 */
INSERT INTO graduate (emplid, grad_date, degree)
VALUES
  (2001, "2023-05-28", "Computer Science"),
  (2002, "2023-05-28", "English"),
  (2003, "2023-05-28", "Mathematics"),
  (2004, "2023-05-28", "Economics"),
  (2005, "2023-05-28", "Business"),
  (2006, "2023-05-28", "Nursing"),
  (2007, "2023-05-28", "Physics"),
  (2008, "2023-05-28", "Business"),
  (2009, "2023-05-28", "Economics");

/* Insert data into the employer table.
 * Note: emplid is a foreign key referencing the student table.
 * This table is used to track graduate employment records.
 */
INSERT INTO employer (employer_id, employer_name, industry, street, postal_code)
VALUES
  (123456, "Tech Innovations Inc.", "Technology", "123 Tech Lane", 10001),
  (345678, "Literary Press", "Publishing", "789 Book Road", 11101),
  (678901, "Math Research Labs", "Research", "303 Research St", 10452),
  (789012, "BioTech Labs", "Biotechnology", "404 Bio Park", 10453),
  (901234, "Healthcare Services", "Healthcare", "606 Health St", 10002),
  (345345, "Nursing Care Center", "Healthcare", "909 Care Lane", 10451),
  (567567, "Physics Research Group", "Research", "202 Physics Drive", 10453),
  (678678, "Business Solutions Corp.", "Business", "303 Business Rd", 10001),
  (901901, "Finance Group", "Finance", "606 Finance St", 11201);

/* Insert data into the employment record table.
 * Note: emplid is a foreign key referencing the student table.
 */
INSERT INTO employment_record (position, start_date, end_date, employer_id, emplid)
VALUES
  ("Software Engineer", "2023-08-01", NULL, 123456, 2001),
  ("Editorial Assistant", "2023-06-15", "2024-06-15", 345678, 2002),
  ("Data Analyst", "2023-07-10", NULL, 678901, 2003),
  ("Biotech Researcher", "2023-09-01", NULL, 789012, 2004),
  ("Healthcare Consultant", "2023-08-20", NULL, 901234, 2005),
  ("Nurse Practitioner", "2023-10-01", NULL, 345345, 2006),
  ("Physics Researcher", "2023-07-01", NULL, 567567, 2007),
  ("Business Analyst", "2023-09-15", NULL, 678678, 2008),
  ("Financial Analyst", "2023-11-01", "2024-11-01", 901901, 2009);
