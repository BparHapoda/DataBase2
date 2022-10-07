CREATE TABLE assistants
(
id serial NOT NULL PRIMARY KEY,
teacher_id int NOT NULL,
FOREIGN KEY (teacher_id) REFERENCES teachers (id)
)

INSERT INTO assistants (teacher_id)
VALUES
(11 ),(6),(7),(8)


CREATE TABLE curators
(
id serial NOT NULL PRIMARY KEY,
teacher_id int NOT NULL,
FOREIGN KEY (teacher_id) REFERENCES teachers (id)
)

INSERT INTO curators (teacher_id)
VALUES
(9),(10),(11)

CREATE TABLE deans
(
id serial NOT NULL PRIMARY KEY,
teacher_id  int NOT NULL,
FOREIGN KEY (teacher_id) REFERENCES teachers (id)
)

INSERT INTO deans (teacher_id)
VALUES
(12),(5),(8)

CREATE TABLE departments
(
id serial NOT NULL PRIMARY KEY,
building  int NOT NULL,
CHECK (building BETWEEN 1 AND 5),
name varchar (100) NOT NULL UNIQUE,
CHECK (name <> ''),
faculty_id int NOT NULL,
head_id int NOT NULL,
FOREIGN KEY (faculty_id) REFERENCES faculties (id),
FOREIGN KEY (head_id) REFERENCES heads (id)
)

INSERT INTO departments (building,name,faculty_id,head_id)
VALUES
(1,'Java',1,1),
(1,'Математики',1,2),
(2,'Химии',1,3),
(2,'Физики',2,4)


CREATE TABLE faculties
(
id serial NOT NULL PRIMARY KEY,
building int NOT NULL ,
CHECK (building BETWEEN 1 AND 5),
name varchar (100) NOT NULL UNIQUE,
CHECK (name <>''),
dean_id int NOT NULL,
FOREIGN KEY (dean_id) REFERENCES deans (id)
)

INSERT INTO faculties (building,name,dean_id)
VALUES
(1,'Инженерный',1),
(2,'Естественно-научный',2),
(3,'Математический',3)

CREATE TABLE groups
(
id serial NOT NULL PRIMARY KEY,
name varchar (10) NOT NULL UNIQUE,
CHECK (name <> ''),
year int NOT NULL ,
CHECK (year BETWEEN 1 AND 5),
department_id int NOT NULL,
FOREIGN KEY (department_id) REFERENCES departments (id)
)

INSERT INTO groups (name,year,department_id)
VALUES
('101',1,1),
('201',2,1),
('301',3,1),
('401',4,1),
('100',1,2),
('200',2,2),
('300',3,2),
('400',4,2),
('110',1,3),
('210',2,3),
('310',3,3),
('410',4,3),
('150',1,4),
('250',2,4),
('350',3,4),
('440',4,4)


CREATE TABLE groups_curators
(
id serial NOT NULL PRIMARY KEY,
curator_id int NOT NULL,
group_id int NOT NULL,
FOREIGN KEY (curator_id) REFERENCES curators (id),
FOREIGN KEY (group_id) REFERENCES groups (id)
)

INSERT INTO groups_curators (curator_id,group_id)
VALUES
(1,1),
(1,2),
(1,3),
(2,4),
(2,5),
(2,6),
(3,7),
(3,8),
(3,9),
(1,10),
(1,11),
(1,12),
(2,13),
(2,14),
(2,15),
(1,16)


CREATE TABLE groups_lectures
(
id serial NOT NULL PRIMARY KEY,
lecture_id int NOT NULL,
group_id int NOT NULL,
FOREIGN KEY (lecture_id) REFERENCES lectures (id),
FOREIGN KEY (group_id) REFERENCES groups (id)
)

INSERT INTO groups_lectures (lecture_id,group_id)
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10),
(11,11),
(12,12),
(1,13),
(2,14),
(3,15),
(4,16),
(5,1),
(6,2),
(7,3),
(8,4),
(9,5),
(10,6),
(11,7),
(12,8)




CREATE TABLE heads
(
id serial NOT NULL PRIMARY KEY,
teacher_id int NOT NULL,
FOREIGN KEY (teacher_id) REFERENCES teachers(id)
)

INSERT INTO heads (teacher_id)
VALUES
(1),(2),(3),(4)

CREATE TABLE lecture_rooms
(
id serial NOT NULL PRIMARY KEY,
building int NOT NULL,
CHECK (building BETWEEN 1 AND 5),
name varchar (10) NOT NULL UNIQUE,
CHECK (name <> '')
)

INSERT INTO lecture_rooms (building,name)
VALUES
(1,'101'),
(1,'102'),
(1,'103'),
(1,'104'),
(2,'201'),
(2,'202'),
(2,'203'),
(1,'105'),
(1,'106'),
(1,'107'),
(3,'300'),
(3,'301')


CREATE TABLE lectures
(
id serial NOT NULL PRIMARY KEY,
subject_id int NOT NULL,
teacher_id int NOT NULL,
FOREIGN KEY (subject_id) REFERENCES subjects(id),
FOREIGN KEY (teacher_id) REFERENCES teachers (id)
)

INSERT INTO lectures (subject_id,teacher_id)
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10),
(11,11),
(12,12)

CREATE TABLE schedules
(
id serial NOT NULL PRIMARY KEY,
class int NOT NULL,
CHECK (class BETWEEN 1 AND 8),
day_of_week int NOT NULL,
CHECK (day_of_week BETWEEN 1 AND 7),
week int NOT NULL,
CHECK (week BETWEEN 1 AND 52),
lecture_id int NOT NULL,
lecture_room_id int NOT NULL,
FOREIGN KEY (lecture_id) REFERENCES lectures (id),
FOREIGN KEY (lecture_room_id) REFERENCES lecture_rooms (id)
)

INSERT INTO schedules (class,day_of_week,week,lecture_id,lecture_room_id)
VALUES
(1,1,1,1,1),(2,2,1,10,2),(3,3,1,7,3),(4,4,1,4,4),(5,5,1,1,5),(6,6,1,10,6),(7,1,1,7,7),
(1,1,2,2,8),(2,2,2,11,9),(3,3,2,8,10),(4,4,2,5,11),(5,5,2,2,12),(6,6,2,11,1),(7,2,1,8,2),
(1,1,3,3,3),(2,2,3,12,4),(3,3,3,9,5),(4,4,3,6,6),(5,5,3,3,7),(6,6,3,12,8),(7,1,3,9,8),
(1,1,4,4,10),(2,2,4,1,11),(3,3,4,10,12),(4,4,4,7,1),(5,5,4,4,2),(6,6,4,1,3),(7,1,4,10,4),
(1,1,5,5,5),(2,2,5,2,6),(3,3,5,11,7),(4,4,5,8,8),(5,5,5,5,9),(6,6,5,2,10),(7,1,5,11,11),
(1,1,6,6,12),(2,2,6,3,1),(3,3,6,12,2),(4,4,6,9,3),(5,5,6,6,4),(6,6,6,3,5),(7,1,6,12,6),
(1,1,7,7,7),(2,2,7,4,8),(3,3,7,1,9),(4,4,7,10,10),(5,5,7,7,11),(6,6,7,4,12),(7,1,7,1,1),
(1,1,8,8,2),(2,2,8,5,3),(3,3,8,2,4),(4,4,8,11,5),(5,5,8,8,6),(6,6,8,5,7),(7,1,8,2,8),
(1,1,9,9,9),(2,2,9,6,10),(3,3,9,3,11),(4,4,9,12,12),(5,5,9,9,1),(6,6,9,6,2),(7,1,9,3,3)

CREATE TABLE subjects
(
id serial NOT NULL PRIMARY KEY,
name varchar (100) NOT NULL UNIQUE,
CHECK (name<>'')
)

INSERT INTO subjects (name)
VALUES
('Математика'),
('Физика'),
('Химия'),
('Информатика'),
('Физкультура'),
('Литература'),
('Java'),
('Геометрия'),
('Математический анализ'),
('История'),
('Астрономия'),
('Биология')

CREATE TABLE teachers
(
id serial NOT NULL PRIMARY KEY,
name text NOT NULL,
CHECK (name<>''),
surname text NOT NULL,
CHECK (name<>'')
)

INSERT INTO teachers (name,surname)
VALUES
('Михайло','Ломоносов'),
('Исаак','Ньютон'),
('Никола','Тесла'),
('Константин','Циолковский'),
('Альберт','Энштейн'),
('Мария','Складовская-Кюри'),
('Дмитрий','Менделеев'),
('Виктор','Ивунин'),
('Мвйкл','Фарадей'),
('Нильс','Бор'),
('Стивен','Хокинг'),
('Джеймс','Гослинг')


--1. Вывести названия аудиторий, в которых читает лекции
--преподаватель “Михайло Ломоносов”.

SELECT t.name || ' ' || t.surname AS Имя_и_Фамилия_преподавателя,lr.name AS Номер_аудитории
FROM schedules s
JOIN lecture_rooms lr ON s.lecture_room_id= lr.id
JOIN lectures l ON s.lecture_id=l.id
JOIN teachers t ON l.teacher_id=t.id
WHERE t.name || ' ' || t.surname = 'Михайло Ломоносов'

--2. Вывести фамилии ассистентов, читающих лекции в группе
--“101”.

SELECT t.surname AS Фамилия, g.name AS Название_группы
FROM teachers t
JOIN curators c ON t.id = c.teacher_id
JOIN groups_curators gc ON c.id=gc.curator_id
JOIN groups g ON gc.group_id=g.id
WHERE g.name ='400'
AND t.id IN (SELECT teacher_id FROM assistants)


--3. Вывести дисциплины, которые читает преподаватель “Виктор Ивунин” для групп 4-го курса.
SELECT t.name || ' ' || t.surname ,g.name
FROM teachers t
JOIN lectures l ON t.id=l.teacher_id
JOIN groups_lectures gl ON l.id=gl.lecture_id
JOIN groups g ON gl.group_id=g.id
WHERE t.name || ' ' || t.surname='Виктор Ивунин' AND g.year =4



--4. Вывести фамилии преподавателей, которые не читают
--лекции по понедельникам.

SELECT t.surname,s.day_of_week
FROM teachers t
JOIN lectures l ON t.id= l.teacher_id
JOIN schedules s ON l.id=s.lecture_id
WHERE s.day_of_week <>1


--5. Вывести названия аудиторий, с указанием их корпусов,
--в которых нет лекций в среду второй недели на третьей
--паре.

SELECT l.name AS Название_аудитории,l.building AS Название_корпуса
FROM lecture_rooms l
JOIN schedules s ON l.id=s.lecture_room_id
WHERE s.day_of_week <> 3 AND s.week <> 2 AND s.class <> 3


--6. Вывести полные имена преподавателей факультета “Инженерный”, которые не курируют
--группы кафедры “Java”.

SELECT t.name || ' ' || t.surname ,f.name
FROM teachers t
LEFT JOIN deans d ON d.teacher_id = t.id
LEFT JOIN faculties f ON d.id=f.dean_id
LEFT JOIN curators c ON t.id=c.teacher_id
LEFT JOIN groups_curators gc ON c.id=gc.curator_id
LEFT JOIN groups g ON gc.group_id=g.id
LEFT JOIN departments ds ON g.department_id= ds.id
WHERE f.name = 'Естественно-научный' AND ds.name <> 'Java'


--7. Вывести список номеров всех корпусов, которые имеются
--в таблицах факультетов, кафедр и аудиторий.

SELECT f.building
FROM faculties f

UNION

SELECT d.building
FROM departments d

UNION

SELECT lr.building
FROM lecture_rooms lr

ORDER BY building



--8. Вывести полные имена преподавателей в следующем по-
--рядке: деканы факультетов, заведующие кафедрами, пре-
--подаватели, кураторы, ассистенты.

SELECT t.name || ' ' || t.surname
FROM teachers t
WHERE t.id IN (SELECT d.teacher_id FROM deans d)

UNION ALL

SELECT t.name || ' ' || t.surname
FROM teachers t
WHERE t.id IN (SELECT h.teacher_id FROM heads h)

UNION ALL

SELECT t.name || ' ' || t.surname
FROM teachers t
--WHERE t.id IN (SELECT d.teacher_id FROM deans d)

UNION ALL

SELECT t.name || ' ' || t.surname
FROM teachers t
WHERE t.id IN (SELECT c.teacher_id FROM curators c)

UNION ALL

SELECT t.name || ' ' || t.surname
FROM teachers t
WHERE t.id IN (SELECT a.teacher_id FROM assistants a)

--9. Вывести дни недели (без повторений), в которые имеются
--занятия в аудиториях “201” и “202” корпуса 2.

SELECT DISTINCT  s.day_of_week
FROM schedules s
JOIN lecture_rooms lr ON s.lecture_room_id = lr.id
WHERE (lr.name = '201' OR lr.name = '202') AND lr.building =2