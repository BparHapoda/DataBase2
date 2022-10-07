CREATE TABLE teacher_deleted_infos(
id serial NOT NULL PRIMARY KEY,
employment_date date NOT NULL,
CHECK (employment_date>'01-01-1990'),
name text NOT NULL,
CHECK (name <>''),
surname text NOT NULL,
CHECK (surname <>''),
salary money NOT NULL,
CHECK (salary >='0'),
--manipulation_id int NOT NULL,
--FOREIGN KEY (manipulation_id) REFERENCES teacher_manipulations (id)
)

CREATE TABLE teacher_added_infos (
id serial NOT NULL PRIMARY KEY,
employment_date date NOT NULL,
CHECK (employment_date>'01-01-1990'),
name text NOT NULL,
CHECK (name <>''),
surname text NOT NULL,
CHECK (surname <>''),
salary money NOT NULL,
CHECK (salary >='0'),
manipulation_id int NOT NULL,
FOREIGN KEY (manipulation_id) REFERENCES teacher_manipulations (id)
)

CREATE TABLE teacher_modify_infos (
id serial NOT NULL PRIMARY KEY,
employment_date date NOT NULL,
CHECK (employment_date>'01-01-1990'),
name text NOT NULL,
CHECK (name <>''),
surname text NOT NULL,
CHECK (surname <>''),
salary money NOT NULL,
CHECK (salary >='0'),
manipulation_id int NOT NULL,
FOREIGN KEY (manipulation_id) REFERENCES teacher_manipulations (id)
)

CREATE TABLE actions (
id serial NOT NULL PRIMARY KEY,
name varchar (100) NOT NULL UNIQUE,
CHECK (name <>'')
)

INSERT INTO actions (name)
VALUES
('INSERT'),('UPDATE'),('DELETE')


CREATE TABLE teacher_manipulations (
id serial NOT NULL PRIMARY KEY,
date date NOT NULL,
CHECK (date <= CURRENT_DATE),
action_id int NOT NULL,
teacher_id int NOT NULL,
FOREIGN KEY (action_id) REFERENCES actions (id)
FOREIGN KEY (teacher_id) REFERENCES teachers (id)
)


CREATE TABLE teachers(
id serial NOT NULL PRIMARY KEY,
employment_date date NOT NULL,
CHECK (employment_date > '01-01-1990'),
name text NOT NULL,
CHECK (name <>''),
surname text NOT NULL,
CHECK (surname <>''),
salary money NOT NULL,
CHECK (salary >='0')
)

INSERT INTO teachers (employment_date,name,surname,salary)
VALUES
('10-10-2018','Петр','Петров','10000'),
('10-10-2019','Иван','Иванов','9000'),
('10-10-2015','Виктор','Ивунин','20000'),
('10-10-2016','Алексей','Толстой','5000'),
('10-10-2017','Александр','Пушкин','8000'),
('10-10-2020','Семен','Гоцман','7000')


--Создать триггер, который позволяет только увеличивать
--размер фонда финансирования факультета.
CREATE FUNCTION track_financing () RETURNS trigger AS $$
BEGIN
IF NEW.salary < OLD.salary THEN RETURN NULL;
ELSE
RETURN NEW;
END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER financing_has_bevome_less_than_it_was BEFORE UPDATE  ON teachers
FOR EACH ROW EXECUTE PROCEDURE track_financing ();

--Создать триггер, который фиксирует в журнале сведений
--о преподавателях все операции манипулирования, про-
--изводимые над таблицей преподавателей.

CREATE FUNCTION track_teacher_delete () RETURNS trigger AS $$

BEGIN
-- С удалением у меня не получилось,тк при удалении из teachers нужно оставить ссылку на учителя
-- которого нет в таблице teachers,поэтому я его добавляю в teacher_deleted_infos без ссылки на teacher_manipulations
-- а в teacher_manipulations его не сохранить. может быть что то с какскадным удалением ,но я не понял как

--INSERT INTO teacher_manipulations(date,action_id,teacher_id)
--VALUES
--(CURRENT_DATE,(SELECT id FROM actions WHERE name = 'DELETE'),OLD.id);

INSERT INTO teacher_deleted_infos (employment_date,name,surname,salary)
VALUES (OLD.employment_date,OLD.name,OLD.surname,OLD.salary);

RETURN OLD;

END

$$ LANGUAGE plpgsql;

CREATE TRIGGER teacher_delete_add_info AFTER DELETE ON teachers
FOR EACH ROW EXECUTE PROCEDURE track_teacher_delete ();
---------------------------------------------------------------------

CREATE FUNCTION track_teacher_modify () RETURNS trigger AS $$

BEGIN
INSERT INTO teacher_manipulations(date,action_id,teacher_id)
VALUES
(CURRENT_DATE,(SELECT id FROM actions WHERE name = 'UPDATE'),OLD.id);

INSERT INTO teacher_modify_infos (employment_date,name,surname,salary,manipulation_id)
VALUES (OLD.employment_date,OLD.name,OLD.surname,OLD.salary,
(SELECT id FROM teacher_manipulations t  ORDER BY id DESC LIMIT 1));

RETURN NEW;

END

$$ LANGUAGE plpgsql;

CREATE TRIGGER teacher_modify_modify_info BEFORE UPDATE ON teachers
FOR EACH ROW EXECUTE PROCEDURE track_teacher_modify ();
-----------------------------------------------------------------------

CREATE FUNCTION track_teacher_add () RETURNS trigger AS $$

BEGIN
INSERT INTO teacher_manipulations(date,action_id,teacher_id)
VALUES
(CURRENT_DATE,(SELECT id FROM actions WHERE name = 'INSERT'),NEW.id);

INSERT INTO teacher_added_infos (employment_date,name,surname,salary,manipulation_id)
VALUES (NEW.employment_date,NEW.name,NEW.surname,NEW.salary,
(SELECT id FROM teacher_manipulations t  ORDER BY id DESC LIMIT 1));

RETURN NEW;

END

$$ LANGUAGE plpgsql;

CREATE TRIGGER teacher_modify_add_info AFTER INSERT ON teachers
FOR EACH ROW EXECUTE PROCEDURE track_teacher_add ();







-----------------------------------------------------------------------
-- ниже просто для тестирования
UPDATE teachers
SET salary = '0'
WHERE id=6

UPDATE teachers
SET salary = '100000'
WHERE id=6

DROP FUNCTION track_financing ()
DROP TRIGGER financing_has_bevome_less_than_it_was on teachers


DROP FUNCTION track_teacher_add ()
DROP TRIGGER teacher_modify_add_info on teachers

DROP FUNCTION track_teacher_modify ()
DROP TRIGGER teacher_modify_modify_info on teachers

DROP FUNCTION track_teacher_delete ()
DROP TRIGGER teacher_delete_add_info on teachers

DELETE FROM teachers
WHERE id=1

UPDATE teachers
SET name = 'Иван'
WHERE id=6

INSERT INTO teachers (employment_date,name,surname,salary)
VALUES
('10-10-2015','Хрен','Сгоры','10000')