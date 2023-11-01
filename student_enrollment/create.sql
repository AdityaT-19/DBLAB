CREATE DATABASE student_enrollment;

USE student_enrollment;

CREATE TABLE student (
    regno VARCHAR(15) PRIMARY KEY,
    name VARCHAR(50) ,
    major VARCHAR(20) ,
    bdate DATE
);

CREATE TABLE course(
    course INTEGER PRIMARY KEY,
    cname VARCHAR(30),
    dept VARCHAR(20)
);

CREATE TABLE enroll(
    regno VARCHAR(15),
    course INTEGER,
    sem INTEGER,
    marks INTEGER,
    FOREIGN KEY (regno) REFERENCES student(regno),
    FOREIGN KEY (course) REFERENCES course(course)
);

CREATE TABLE text(
    book_ISBN INTEGER PRIMARY KEY,
    book_title VARCHAR(50),
    publisher VARCHAR(30),
    author VARCHAR(30)
);

CREATE TABLE book_adoption(
    course INTEGER,
    sem INTEGER,
    book_ISBN INTEGER,
    FOREIGN KEY (course) REFERENCES course(course),
    FOREIGN KEY (book_ISBN) REFERENCES text(book_ISBN)
);
