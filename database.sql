CREATE DATABASE placement_system;
USE placement_system;

-- STUDENT
CREATE TABLE Student (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Branch VARCHAR(50),
    CGPA DECIMAL(4,2),
    Email VARCHAR(100),
    PlacedStatus VARCHAR(20) DEFAULT 'Not Placed'
);

-- COMPANY
CREATE TABLE Company (
    CompanyID INT AUTO_INCREMENT PRIMARY KEY,
    CompanyName VARCHAR(100),
    MinCGPA DECIMAL(4,2)
);

-- PLACEMENT
CREATE TABLE Placement (
    PlacementID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    CompanyID INT,
    Package DECIMAL(10,2),
    Status VARCHAR(20),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- SAMPLE DATA
INSERT INTO Student (Name, Branch, CGPA, Email) VALUES
('Swapnil', 'ECS', 8.5, 'swapnil@gmail.com'),
('Rahul', 'IT', 7.2, 'rahul@gmail.com'),
('Amit', 'CS', 9.1, 'amit@gmail.com'),
('Neha', 'ECS', 8.0, 'neha@gmail.com');

INSERT INTO Company (CompanyName, MinCGPA) VALUES
('TCS', 7.0),
('Infosys', 7.5),
('Google', 8.5);

-- TRIGGER
DELIMITER $$
CREATE TRIGGER update_status
AFTER INSERT ON Placement
FOR EACH ROW
BEGIN
    UPDATE Student
    SET PlacedStatus = 'Placed'
    WHERE StudentID = NEW.StudentID;
END $$
DELIMITER ;

-- VIEW
CREATE VIEW Placed_Students_View AS
SELECT s.Name, c.CompanyName, p.Package
FROM Placement p
JOIN Student s ON p.StudentID = s.StudentID
JOIN Company c ON p.CompanyID = c.CompanyID
WHERE p.Status = 'Selected';

-- STORED PROCEDURE
DELIMITER $$
CREATE PROCEDURE GetEligibleStudents(IN comp_id INT)
BEGIN
    SELECT s.Name, s.CGPA
    FROM Student s
    JOIN Company c ON c.CompanyID = comp_id
    WHERE s.CGPA >= c.MinCGPA
    AND s.PlacedStatus = 'Not Placed';
END $$
DELIMITER ;