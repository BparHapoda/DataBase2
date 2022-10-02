CREATE TABLE faculties (
id serial NOT NULL PRIMARY KEY,
name varchar (100) NOT NULL UNIQUE
CHECK (name <>'')
)
INSERT INTO faculties (name)
VALUES
('Computer Science'),('Griffindor'),('Hufflepuff'),('Ravenclaw'),('Slytherin')

CREATE TABLE departments
(
id serial NOT NULL PRIMARY KEY,
financing money NOT NULL  DEFAULT '0'
	CHECK (financing <> ''),
name varchar (100) NOT NULL  UNIQUE
	CHECK (name <> ''),
faculty_id int NOT NULL,
FOREIGN KEY (faculty_id) REFERENCES faculties (id)
)

INSERT INTO departments (financing,name,faculty_id)
VALUES
('2000','mathematic',2),
('3000','physics',2),
('4000','literature',3),
('5000','chemistry',4),
('6000','java',1),
('7000','c ++',1),
('3000','Software depelopment',1)



CREATE TABLE groups(
id serial NOT NULL PRIMARY KEY,
name varchar(10) NOT NULL UNIQUE,
CHECK (name <> ''),
year int NOT NULL,
CHECK (year>=1 and year <= 5),
department_id int NOT NULL,
FOREIGN KEY (department_id) REFERENCES departments (id)
)

INSERT INTO groups (name,year,department_id)
 VALUES
 ('100',1,1),
('D201',2,1),
('300',3,2),
('400',4,3),
('500',5,4),
('600',1,5),
('700',2,6),
('800',3,7),
('900',4,3),
('777',5,2)



CREATE TABLE subjects
(
id serial NOT NULL PRIMARY KEY,
name varchar (100) NOT NULL UNIQUE,
CHECK (name <> '')
)
INSERT INTO subjects (name)
VALUES
('algebra'),('geometry'),('history'),('english'),('programming'),('astronomy'),
('cobol'),('fortran'),('assembler')



CREATE TABLE teachers
(
id serial NOT NULL PRIMARY KEY,
name text NOT NULL ,
CHECK (name <> ''),
surname text NOT NULL,
CHECK (surname <> ''),
salary money NOT NULL ,
CHECK (salary>'0')
)

INSERT INTO teachers (name,surname,salary)
VALUES
('Victor','Ivunin','10000'),
('Dave','McQueen','1000'),
('Jack','Underhill','500'),
('Tom','Cruz','2000'),
('Nicol','Cidman','2000'),
('Arnold','Schwarzenegger','3000')

CREATE TABLE lectures
(
id serial NOT NULL PRIMARY KEY,
day_od_week int NOT NULL,
CHECK (day_od_week>=1   AND day_od_week <=7 ),
lecture_room text NOT NULL,
CHECK (lecture_room <> ''),
subject_id int NOT NULL,
teacher_id int NOT NULL ,
FOREIGN KEY (subject_id) REFERENCES subjects (id),
FOREIGN KEY (teacher_id) REFERENCES teachers (id)
)

INSERT INTO lectures (day_od_week,lecture_room,subject_id,teacher_id)
VALUES
(1,'111',1,1),(1,'222',1,1),(2,'333',2,1),(2,'444',2,2),(3,'555',3,2),(3,'11',4,2),(4,'22',4,2),
(4,'33',5,3),
(5,'44',6,4),(5,'55',7,3),(6,'4442',8,4),(6,'221',9,5),(7,'112',4,6),(7,'2216',4,6)

CREATE TABLE groups_lectures
(
id serial NOT NULL PRIMARY KEY,
group_id int NOT NULL,
lecture_id int NOT NULL,
FOREIGN KEY (group_id) REFERENCES groups(id),
FOREIGN KEY (lecture_id) REFERENCES lectures (id)
)

INSERT INTO groups_lectures (group_id,lecture_id)
VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),
(7,7),(8,8),(9,9),(10,10),(1,11),(2,12),(3,13),
(4,14)

--1. Вывести количество преподавателей кафедры “Software
--Development”.
SELECT departments.name,COUNT (*)
FROM teachers
INNER JOIN lectures ON teachers.id=lectures.teacher_id
INNER JOIN groups_lectures ON lectures.id=groups_lectures.lecture_id
INNER JOIN groups ON groups_lectures.group_id=groups.id
INNER JOIN departments ON groups.department_id=departments.id
GROUP BY departments.name
HAVING departments.name = 'Software depelopment'

--2. Вывести количество лекций, которые читает преподаватель
--“Dave McQueen”.
SELECT teachers.name || teachers.surname,COUNT (*)
FROM teachers
INNER JOIN lectures ON teachers.id=lectures.teacher_id
GROUP BY teachers.name || teachers.surname
HAVING teachers.name || teachers.surname = 'DaveMcQueen'

--3. Вывести количество занятий, проводимых в аудитории
--“555”.
SELECT lecture_room,COUNT (*)
FROM lectures AS l
WHERE l.lecture_room= '555'
GROUP BY lecture_room

--4. Вывести названия аудиторий и количество лекций, про-
--водимых в них.
SELECT l.lecture_room,COUNT (*)
FROM lectures AS l
INNER JOIN subjects ON l.subject_id=subjects.id
GROUP BY l.lecture_room




--5. Вывести количество студентов, посещающих лекции пре-
--подавателя “Jack Underhill”. Будем считать,что в группе 20 студентов
SELECT teachers.name || teachers.surname,COUNT (*)*20
FROM teachers,groups
WHERE teachers.name = 'Jack' AND teachers.surname='Underhill'
GROUP BY teachers.name || teachers.surname


--6. Вывести среднюю ставку преподавателей факультета
--“Computer Science”.
SELECT f.name,ROUND (AVG(t.salary::numeric),2)
FROM faculties AS f
JOIN departments AS d ON f.id=d.faculty_id
JOIN groups AS g ON d.id=g.department_id
JOIN groups_lectures AS gl ON g.id=gl.group_id
JOIN lectures AS l ON gl.lecture_id=l.id
JOIN teachers AS t ON l.teacher_id=t.id
WHERE f.name = 'Computer Science'
GROUP BY f.name



--7. Вывести минимальное и максимальное количество предметов
--у всех групп.
SELECT MIN (COUNT),MAX (COUNT) FROM (SELECT COUNT (*)
FROM groups
JOIN groups_lectures ON groups.id=groups_lectures.group_id
JOIN lectures ON groups_lectures.lecture_id=lectures.id
JOIN subjects ON lectures.subject_id=subjects.id
GROUP BY groups.name
ORDER BY COUNT(subjects)) AS a

--8. Вывести средний фонд финансирования кафедр.
SELECT ROUND (AVG (departments.financing::numeric),2)
FROM departments

--9. Вывести полные имена преподавателей и количество чи-
--таемых ими дисциплин.
SELECT t.name || t.surname ,COUNT (*)
FROM teachers AS t
JOIN lectures AS l ON t.id=l.teacher_id
JOIN subjects AS s ON l.subject_id=s.id
GROUP BY t.name || t.surname

--10. Вывести количество лекций в каждый день недели.
SELECT day_od_week AS d,COUNT (l)
FROM lectures AS l
GROUP BY d
ORDER BY d

--11. Вывести номера аудиторий и количество кафедр, чьи лек-
--ции в них читаются.
SELECT lecture_room,COUNT (d)
FROM lectures AS l
JOIN groups_lectures AS gl ON l.id=gl.lecture_id
JOIN groups AS g ON gl.group_id=g.id
JOIN departments AS d ON g.department_id=d.id
GROUP BY lecture_room
ORDER BY lecture_room

--12. Вывести названия факультетов и количество дисциплин,
--которые на них читаются.
SELECT f.name ,COUNT (s.name)
FROM faculties AS f
JOIN departments AS d ON f.id= d.faculty_id
JOIN groups AS g ON d.id= g.department_id
JOIN groups_lectures AS gl ON g.id=gl.group_id
JOIN lectures AS l ON gl.lecture_id=l.id
JOIN subjects AS s ON l.subject_id=s.id
GROUP BY f.name

--13. Вывести количество лекций для каждой пары преподава-
--тель-аудитория.
SELECT t.name ||' '|| t.surname AS ns,l.lecture_room AS lr,COUNT (l)
FROM teachers AS t,lectures AS l
GROUP BY ns,lr
