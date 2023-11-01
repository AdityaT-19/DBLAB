USE student_enrollment;

INSERT INTO Student VALUES
("01HF235", "Aditya", "CSE", "2001-05-15"),
("01HF354", "Vinod", "Literature", "2002-06-10"),
("01HF254", "Keerthi", "Philosophy", "2000-04-04"),
("01HF653", "Domi", "History", "2003-10-12"),
("01HF234", "Gambhir", "Computer Economics", "2001-10-10");

INSERT INTO Course VALUES
(001, "DBMS", "CS"),
(002, "Literature", "English"),
(003, "Philosophy", "Philosphy"),
(004, "History", "Social Science"),
(005, "Computer Economics", "CS");

INSERT INTO Enroll VALUES
("01HF235", 001, 5, 85),
("01HF354", 002, 6, 87),
("01HF254", 003, 3, 95),
("01HF653", 004, 3, 80),
("01HF234", 005, 5, 75);

INSERT INTO Text VALUES
(241563, "Operating Systems", "Pearson", "Silberschatz"),
(532678, "Complete Works of Shakesphere", "Oxford", "Shakesphere"),
(453723, "Immanuel Kant", "Delphi Classics", "Immanuel Kant"),
(278345, "History of the world", "The Times", "Richard Overy"),
(426784, "Behavioural Economics", "Pearson", "David Orrel");

INSERT INTO book_adoption VALUES
(001, 5, 241563),
(002, 6, 532678),
(003, 3, 453723),
(004, 3, 278345),
(001, 6, 426784);

