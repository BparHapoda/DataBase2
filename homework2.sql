CREATE TABLE curators (
        id serial NOT NULL PRIMARY KEY,
        name text NOT NULL ,
        surname text NOT NULL
        )
        INSERT INTO curators (name,surname)
        VALUES
        ('Иван','Грозный'),('Петр','Порошенко'),('Виктор','Ивунин'),('Павел','Степанов'),('Инноккентий','Смоктуновский')


        CREATE TABLE faculties (
        id serial NOT NULL ,
        financing money NOT NULL DEFAULT '0' CHECK (financing>='0'),
        name varchar(100) NOT NULL ,
        UNIQUE (name),
        UNIQUE (id)
        )
        INSERT INTO faculties(financing,name)
        VALUES
        ('20000','Информатика и вычислительная техника'),('30000','Разработка программного обеспечения'),
        ('10000','Строительство мостов и сооружений'),('40000','Инженерно-физический'),
        ('1000','Иностранных языков')




        CREATE TABLE departments (
        id serial NOT NULL PRIMARY KEY,
        financing money NOT NULL DEFAULT '0' CHECK (financing >= '0'),
        name varchar (100) NOT NULL ,
        UNIQUE (name),
        facultyId int NOT NULL,
        FOREIGN KEY (facultyId) REFERENCES faculties(id)
        )

        INSERT INTO departments(financing,name,facultyId)
        VALUES
        ('5000','Кафедра компьютерных наук',1),('4000','Кафедра СУБД',1),('4000','Кафедра Java',2),
        ('4000','Кафедра С++',2),('3000','Кафедра по строительству мостов',3),
        ('3000','Кафедра по строительству уникальных сооружений',3),('3000','Кафедра компьютерной томографии',4),
        ('3000','Кафедра приборостроения',4),('4000','Кафедра английского языка',5),('4000','Кафедра испанского языка',5)

        CREATE TABLE groups (
        id serial NOT NULL PRIMARY KEY,
        name varchar (10) NOT NULL,
        year int CHECK (year >=1 AND year <=5)  NOT NULL,
        departmentId int NOT NULL,
        UNIQUE (name),
        FOREIGN KEY (departmentId) REFERENCES departments (id)
        )

        INSERT INTO groups (name,year,departmentId)
        VALUES
        ('Группа 160',1,1),('Группа 161',1,1),('Группа 260',2,2),('Группа 261',2,2),('Группа 300',3,3),('Группа 301',3,3),
        ('Группа 454',4,4),('Группа 522',5,4),('Группа 100',1,5),('Группа 200',2,6),('Группа 320',3,7),('Группа 443',4,7),
        ('Группа 555',5,8),('Группа 467',4,8),('Группа 324',3,9),('Группа 201',2,9),('Группа 111',1,10)


        CREATE TABLE groupsCurators (
        id serial NOT NULL PRIMARY KEY,
        curatorId int NOT NULL,
        groupId int NOT NULL,
        FOREIGN KEY (curatorId) REFERENCES curators (id),
        FOREIGN KEY (groupId) REFERENCES groups (id)
        )

        INSERT INTO groupsCurators(curatorId,groupId)
        VALUES
        (1,1),(1,2),(2,3),(2,4),(2,5),(1,6),(1,7),(2,8),(2,9),(3,10),(3,11),(3,12),(4,13),(5,14),(5,15),(4,16),(4,17)



        CREATE TABLE subjects (
        id serial NOT NULL,
        name varchar (100) NOT NULL,
        UNIQUE (name),
        UNIQUE (id)
        )

        INSERT INTO subjects (name)
        VALUES
        ('Алгебра и начало анализа'),('Информатика'),('Системное администрирование'),('Дискретная математика'),('Сопромат'),
        ('Материаловедение'),('Английский язык'),('Испанский язык'),('История'),('Физическая культура')

        CREATE TABLE teachers (
        id serial NOT NULL PRIMARY KEY,
        name text NOT NULL,
        surname text NOT NULL,
        salary money NOT NULL CHECK (salary >'0')
        )

        INSERT INTO teachers(name,surname,salary)
        VALUES
        ('Александр','Роднянский','100'),('Алексей','Муромский','200'),('Виктор','Ивунин','1000'),('Николай','Бубин','100'),
        ('Андрей','Гребенкин','200'),('Игорь','Дронов','300'),('Станислав','Баранов','50'),('Игорь','Веселов','500'),
        ('Вячеслав','Иващенко','50'),('Виктор','Иванов','500')

        CREATE TABLE lectures (
        id serial NOT NULL PRIMARY KEY,
        lectureRoom text NOT NULL ,
        subjectId int NOT NULL,
        teacherId int NOT NULL,
        FOREIGN KEY (subjectId) REFERENCES subjects (id),
        FOREIGN KEY (teacherId) REFERENCES teachers (id)
        )

        INSERT INTO lectures (lectureRoom,subjectId,teacherId)
        VALUES
        ('1',1,10),('2',2,9),('3',3,8),('4',4,7),('5',5,6),('6',6,5),('7',7,4),('8',9,3),('9',10,2),('10',1,1),('11',2,2),
        ('12',3,3),('13',4,4),('14',5,5),('15',6,6),('16',7,7),('17',8,8)

        CREATE TABLE groupsLectures (
        id serial NOT NULL PRIMARY KEY,
        groupId int NOT NULL,
        lectureId int NOT NULL,
        FOREIGN KEY (groupId) REFERENCES groups (id),
        FOREIGN KEY (lectureId) REFERENCES lectures (id)
        )

        INSERT INTO groupsLectures(groupId,LectureId)
        VALUES
        (1,2),(2,1),(3,3),(4,4),(5,6),(6,5),(7,8),(8,7),(9,10),(10,9),(11,12),(12,11),(13,14),(14,13),(15,16),(16,15),(17,17)


        --1. Вывести все возможные пары строк преподавателей и групп.
        SELECT teachers.name,teachers.surname,groups.name
        FROM teachers
        INNER JOIN groups
        ON true

        --2. Вывести названия факультетов, фонд финансирования
        --  кафедр которых превышает фонд финансирования фа-
        --  культета.

        SET lc_monetary TO "en_US.UTF-8";
        SELECT faculties.name AS Факультет,faculties.financing AS Финансирование_факультета,
        SUM (departments.financing) AS Финансирование_кафедр_факультета
        FROM departments
        INNER JOIN faculties ON departments.facultyid=faculties.id
        GROUP BY faculties.name,faculties.financing
        HAVING SUM (departments.financing) > faculties.financing

        --3. Вывести фамилии кураторов групп и названия групп, ко-
        --  торые они курируют.

        SELECT curators.surname ,groups.name
        FROM groupscurators
        INNER JOIN groups ON groupscurators.groupid=groups.id
        INNER JOIN curators ON groupscurators.curatorid=curators.id

        --4. Вывести имена и фамилии преподавателей, которые читают
        --  лекции у группы “300”.

        SELECT teachers.surname,groups.name
        FROM groupslectures
        INNER JOIN groups ON groupslectures.groupid=groups.id
        INNER JOIN lectures ON groupslectures.lectureid=lectures.id
        INNER JOIN teachers ON lectures.teacherid=teachers.id
        GROUP BY teachers.surname,groups.name
        HAVING groups.name = 'Группа 300'

        --5. Вывести фамилии преподавателей и названия факультетов
        --  на которых они читают лекции.

        SELECT teachers.surname AS Фамилия_преподавателя,faculties.name AS Название_факультета
        FROM lectures
        INNER JOIN teachers ON lectures.teacherId=teachers.id
        INNER JOIN groupsLectures ON lectures.id=groupsLectures.lectureId
        INNER JOIN groups ON groupsLectures.groupId=groups.id
        INNER JOIN departments ON groups.departmentId=departments.id
        INNER JOIN faculties ON departments.facultyId=faculties.id
        GROUP BY teachers.surname,faculties.name

        --6. Вывести названия кафедр и названия групп, которые к
        --  ним относятся.
        SELECT departments.name , groups.name
        FROM groups
        INNER JOIN departments ON groups.departmentId=departments.id

        --7. Вывести названия дисциплин, которые читает препода-
        --  ватель Виктор Ивунин
        SELECT teachers.name AS Имя,teachers.surname AS Фамилия,subjects.name AS Название_предмета
        FROM lectures
        INNER JOIN teachers ON lectures.teacherId=teachers.id
        INNER JOIN subjects ON lectures.subjectId=subjects.id


        --8. Вывести названия кафедр, на которых читается дисциплина
        --  “Английский язык”.
        SELECT departments.name AS Название_кафедры,subjects.name AS Название_предмета
        FROM lectures
        INNER JOIN subjects ON lectures.subjectId=subjects.id
        INNER JOIN groupsLectures ON lectures.id=groupsLectures.lectureId
        INNER JOIN groups ON groupsLectures.groupId=groups.id
        INNER JOIN departments ON groups.departmentId=departments.id
        WHERE subjects.name='Английский язык'

        --9. Вывести названия групп, которые относятся к факультету
        -- Информатика и вычислительная техника
        SELECT faculties.name AS Название_факультета,groups.name AS Название_группы
        FROM groups
        INNER JOIN departments ON groups.departmentId=departments.id
        INNER JOIN faculties ON departments.facultyId=faculties.Id
        WHERE faculties.name = 'Информатика и вычислительная техника'

        --10. Вывести названия групп 5-го курса, а также название фа-
        --  культетов, к которым они относятся
        SELECT groups.name AS Название_группы,faculties.name AS Название_факультета
        FROM groups
        INNER JOIN departments ON groups.departmentId=departments.id
        INNER JOIN faculties ON departments.facultyId=faculties.id
        WHERE groups.year = 5

        --11. Вывести полные имена преподавателей и лекции, которые
        --они читают (названия дисциплин и групп), причем отобрать
        --только те лекции, которые читаются в аудитории “10”.
        SELECT teachers.name AS Имя ,teachers.surname AS Фамилия ,subjects.name Название_дисциплины,
        groups.name AS Название_группы,lectures.lectureRoom AS Номер_аудитории
        FROM lectures
        INNER JOIN subjects ON lectures.subjectId=subjects.id
        INNER JOIN teachers ON lectures.teacherId= teachers.id
        INNER JOIN groupsLectures ON lectures.id=groupsLectures.lectureId
        INNER JOIN groups ON groupsLectures.groupId=groups.id
        WHERE lectures.lectureRoom='10'