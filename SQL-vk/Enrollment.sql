DROP DATABASE IF EXISTS enrollment121;

CREATE DATABASE enrollment121;

USE enrollment121;

CREATE TABLE
    student (
        regno VARCHAR(13) NOT NULL,
        name VARCHAR(255) NOT NULL,
        major VARCHAR(255) NOT NULL,
        bdate DATE NOT NULL,
        PRIMARY KEY (regno)
    );

CREATE TABLE
    course (
        course_id INT NOT NULL,
        cname VARCHAR(255) NOT NULL,
        dept VARCHAR(255) NOT NULL,
        PRIMARY KEY (course_id)
    );

CREATE TABLE
    enrollment (
        regno VARCHAR(13) NOT NULL,
        course_id INT NOT NULL,
        sem INT NOT NULL,
        marks INT NOT NULL,
        FOREIGN KEY (regno) REFERENCES student (regno) ON DELETE CASCADE,
        FOREIGN KEY (course_id) REFERENCES course (course_id) ON DELETE CASCADE
    );

CREATE TABLE
    TextBook(
        bookIsbn int not null,
        bookTitle varchar(255) not null,
        author varchar(255) not null,
        publisher varchar(255) not null,
        primary key(bookIsbn)
    );

CREATE TABLE
    bookadoption(
        course_id INT NOT NULL,
        bookIsbn INT NOT NULL,
        sem INT NOT NULL,
        FOREIGN KEY (course_id) REFERENCES course (course_id) ON DELETE CASCADE,
        FOREIGN KEY (bookIsbn) REFERENCES TextBook (bookIsbn) ON DELETE CASCADE
    );

INSERT INTO student
VALUES (
        '01JCE21CS008',
        'Aditya',
        'CSE',
        '2003-01-01'
    );

INSERT INTO student
VALUES (
        '01JCE21CS014',
        'Bhavya',
        'CSE',
        '2003-05-01'
    );

INSERT INTO student
VALUES (
        '01JCE22CV015',
        'Chandan',
        'CV',
        '2004-07-07'
    );

INSERT INTO student
VALUES (
        '01JCE21BT008',
        'Sudharshan',
        'BT',
        '2003-07-28'
    );

INSERT INTO course VALUES (1, 'Data Structures', 'CSE');

INSERT INTO course
VALUES (
        2,
        'Database Management Systems',
        'CSE'
    );

INSERT INTO course VALUES ( 3, 'Engineering Mathematics', 'CV' );

INSERT INTO course VALUES (4, 'Engineering Physics', 'CV');

INSERT INTO course VALUES (6, 'Engineering Biology', 'BT');

INSERT INTO textbook
VALUES (
        1,
        'Data Structures',
        'Sartaj Sahni',
        'McGraw Hill'
    );

INSERT INTO textbook
VALUES (
        2,
        'Database Management Systems',
        'Kenneth Rosen',
        'McGraw Hill'
    );

INSERT INTO textbook
VALUES (
        3,
        'Engineering Mathematics',
        'Bali',
        'McGraw Hill'
    );

INSERT INTO textbook
VALUES (
        4,
        'Engineering Physics',
        'Rajendran',
        'McGraw Hill'
    );

INSERT INTO textbook
VALUES (
        5,
        'Engineering Biology',
        'Ravichandran',
        'McGraw Hill'
    );

INSERT INTO textbook
VALUES (
        6,
        'Biology Of Engineers',
        'Sukumaran',
        'Pearson'
    );

INSERT INTO bookadoption VALUES (1, 1, 3);

INSERT INTO bookadoption VALUES (2, 2, 5);

INSERT INTO bookadoption VALUES (3, 3, 4);

INSERT INTO bookadoption VALUES (4, 4, 2);

INSERT INTO bookadoption VALUES (6, 5, 1);

INSERT INTO bookadoption VALUES (6, 6, 2);

INSERT INTO enrollment VALUES ('01JCE21CS008', 1, 3, 90);

INSERT INTO enrollment VALUES ('01JCE21CS008', 2, 5, 80);

INSERT INTO enrollment VALUES ('01JCE22CV015', 3, 4, 70);

INSERT INTO enrollment VALUES ('01JCE21CS014', 2, 5, 60);

INSERT INTO enrollment VALUES ('01JCE21BT008', 6, 2, 76);

SELECT * FROM student;

SELECT * FROM course;

SELECT * FROM textbook;

SELECT * FROM bookadoption;

SELECT * FROM enrollment;

-- Query-1 : Demonstrate how you add a new text book to the database and make this book be adopted by some department.

INSERT INTO textbook
VALUES (
        7,
        'Systems of Database Management',
        'Sandeep Reddy Vanga',
        'Pearson'
    );

INSERT INTO bookadoption VALUES (2, 7, 1);

SELECT * FROM textbook;

SELECT * FROM bookadoption;

-- Query-2 : Produce a list of text books (include Course #, Book-ISBN, Book-title) in the alphabetical order for courses offered by the ‘CS’ department that use more than two books.

SELECT
    C.course_id,
    B.bookIsbn,
    T.bookTitle
FROM course C
    JOIN bookadoption B ON C.course_id = B.course_id
    JOIN TextBook T ON B.bookIsbn = T.bookIsbn
WHERE C.dept = 'CSE'
GROUP BY
    C.course_id,
    B.bookIsbn,
    T.bookTitle
ORDER BY T.bookTitle;

SELECT
    C.course_id,
    B.bookIsbn,
    T.bookTitle
FROM course C
    JOIN bookadoption B ON C.course_id = B.course_id
    JOIN TextBook T ON B.bookIsbn = T.bookIsbn
WHERE C.dept = 'CSE'
GROUP BY
    C.course_id,
    B.bookIsbn,
    T.bookTitle
HAVING COUNT(B.bookIsbn) = 1
ORDER BY T.bookTitle;

-- Query-3 : List any department that has all its adopted books published by a specific publisher.

SELECT dept
FROM course
    NATURAL JOIN bookadoption
    NATURAL JOIN textbook
GROUP BY dept
HAVING
    COUNT(DISTINCT publisher) = 1;

-- Query-4 : List the students who have scored maximum marks in ‘DBMS’ course.

SELECT regno, name
FROM student
    NATURAL JOIN enroll
    NATURAL JOIN course
WHERE
    cname = 'Database Management Systems'
    AND marks = (
        SELECT MAX(marks)
        FROM enrollment
            NATURAL JOIN course
        WHERE
            cname = 'Database Management Systems'
    );

-- View : Create a view to display all the courses opted by a student along with marks obtained.

CREATE VIEW Students_Course AS
SELECT
    regno,
    name,
    cname,
    marks
FROM student
    NATURAL JOIN enrollment
    NATURAL JOIN course
GROUP BY
    regno,
    course_id,
    marks;

SELECT * FROM Students_Course;

-- Trigger : Create a trigger that prevents a student from enrolling in a course if the marks prerequisite is less than 40.

DELIMITER / /

CREATE TRIGGER CHECKMARKS BEFORE INSERT ON ENROLLMENT 
FOR EACH ROW BEGIN IF 
	IF IF IF IF IF IF IF NEW.marks < 40 THEN SIGNAL SQLSTATE '45000'
	SET
	    MESSAGE_TEXT = 'Marks prerequisite not satisfied';
	END IF;
	END;
	/ / DELIMITER;
	INSERT INTO enrollment VALUES ('01JCE21CS008', 1, 1, 35);
