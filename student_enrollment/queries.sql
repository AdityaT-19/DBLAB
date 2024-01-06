-- demonstrate howe you add a new text book to the database and make this book be adopted by somem department

INSERT INTO text VALUES ( 12345,"The C Programming Language","Prentice Hall","Ritchie" );
INSERT INTO book_adoption VALUES ( 1,1,12345 );

-- produce a list of textbooka include course# Book-ISBN, Book-title in the alphabetical order for courses offered by department CS that use more than 2 books

SELECT course, book_ISBN,book_title
FROM book_adoption
NATURAL JOIN text NATURAL JOIN course
WHERE dept = "CS"
GROUP BY course, book_ISBN,book_title
HAVING COUNT(book_ISBN) > 0

-- list any department that has all its adopted books published by a specific publisher

SELECT dept
FROM course
NATURAL JOIN book_adoption
NATURAL JOIN text
GROUP BY dept
HAVING COUNT(DISTINCT publisher) = 1

-- list the students who have scored maximum marks in dbms course

SELECT *
FROM student
NATURAL JOIN enroll
NATURAL JOIN course
WHERE cname = "DBMS"
AND marks = (SELECT MAX(marks) FROM enroll WHERE cname = "DBMS")

-- create a view to display all the courses opted by a student along with the marks obtained

CREATE VIEW student_course_marks AS
SELECT course,marks
FROM enroll


-- trigger that prevents a student from enrolling in a course if the marks prerequisite course is less than 40

CREATE TRIGGER check_marks
BEFORE INSERT ON enroll
FOR EACH ROW
BEGIN
    IF  NEW.marks < 40
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Marks should be greater than 40';
    END IF;
END;

INSERT INTO enroll VALUES  ( "01JCE21CS008", 1, 35 );