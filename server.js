const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// DB CONNECTION
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'P@ssw0rd1',
    database: 'placement_system'
});

db.connect(err => {
    if (err) console.log(err);
    else console.log("MySQL Connected");
});

// ---------------- GET APIs ----------------

app.get('/students', (req, res) => {
    db.query('SELECT * FROM Student', (err, result) => {
        if (err) res.send(err);
        else res.json(result);
    });
});

app.get('/companies', (req, res) => {
    db.query('SELECT * FROM Company', (err, result) => {
        if (err) res.send(err);
        else res.json(result);
    });
});

app.get('/placed', (req, res) => {
    db.query('SELECT * FROM Placed_Students_View', (err, result) => {
        if (err) res.send(err);
        else res.json(result);
    });
});

// ---------------- INSERT APIs ----------------

// Add Student
app.post('/add-student', (req, res) => {
    const { name, branch, cgpa, email } = req.body;

    const sql = 'INSERT INTO Student (Name, Branch, CGPA, Email) VALUES (?, ?, ?, ?)';
    db.query(sql, [name, branch, cgpa, email], (err, result) => {
        if (err) res.send(err);
        else res.json({ message: "Student Added!" });
    });
});

// Add Company
app.post('/add-company', (req, res) => {
    const { name, cgpa } = req.body;

    const sql = 'INSERT INTO Company (CompanyName, MinCGPA) VALUES (?, ?)';
    db.query(sql, [name, cgpa], (err, result) => {
        if (err) res.send(err);
        else res.json({ message: "Company Added!" });
    });
});

// Add Placement
app.post('/add-placement', (req, res) => {
    const { studentId, companyId, package } = req.body;

    const sql = `INSERT INTO Placement (StudentID, CompanyID, Package, Status)
                 VALUES (?, ?, ?, 'Selected')`;

    db.query(sql, [studentId, companyId, package], (err, result) => {
        if (err) res.send(err);
        else res.json({ message: "Placement Added!" });
    });
});

// Eligibility
app.get('/eligible/:id', (req, res) => {
    db.query('CALL GetEligibleStudents(?)', [req.params.id], (err, result) => {
        if (err) res.send(err);
        else res.json(result[0]);
    });
});

app.listen(5000, () => console.log("Server running on port 5000"));