-- Query 1: Retrieve all students with their full name, major department, program name, and advisor’s full name.

SELECT
    P.Fname, P.Minit, P.Lname,
    D.Department_Name,
    PR.Program_Name,
    A.Fname, A.Minit, A.Lname
FROM
    Students S,
    Person P,
    Department D,
    Programs PR,
    Instructors I,
    Person A
WHERE
    S.Pers_ID = P.Person_ID
    AND S.Dep_ID = D.Department_ID
    AND S.Prog_ID = PR.Program_ID
    AND S.Advisor_ID = I.Instructor_ID
    AND I.Pers_ID = A.Person_ID
ORDER BY
    D.Department_Name, P.Fname, P.Lname;

-- Query 2: Retrieve all course offerings scheduled in the 'Main Building' during Summer 2025, including course name, instructor, and time.

SELECT
    C.Course_Name,
    PI.Fname, PI.Minit, PI.Lname,
    CO.Course_Time
FROM
    Course_Offerings CO,
    Courses C,
    Linked_to L,
    Instructors I,
    Person PI
WHERE
    CO.C_Code = C.Course_Code
    AND CO.C_Code = L.C_Code
    AND CO.Year = L.Year
    AND CO.Semester = L.Semester
    AND CO.Course_Time = L.C_Time
    AND L.Instruc_ID = I.Instructor_ID
    AND I.Pers_ID = PI.Person_ID
    AND CO.Build_Name = 'Main Building'
    AND CO.Year = 2025
    AND CO.Semester = 'Summer'
ORDER BY
    CO.Course_Time;

-- Query 3: Retrieve all students who are enrolled in more than one course offering in the same semester.

SELECT
    S.Student_ID,
    P.Fname, P.Minit, P.Lname,
    E.Semester,
    E.Year
FROM
    Students S,
    Person P,
    Enroll E
WHERE
    S.Student_ID = E.Stud_ID
    AND S.Pers_ID = P.Person_ID
GROUP BY
    S.Student_ID, P.Fname, P.Minit, P.Lname, E.Semester, E.Year
HAVING
    COUNT(*) > 1
ORDER BY
    E.Year, E.Semester, P.Fname, P.Lname;

-- Query 4: Display a count of courses taught by each instructor per semester.

SELECT
    I.Instructor_ID,
    PI.Fname, PI.Minit, PI.Lname,
    L.Semester,
    L.Year,
    COUNT(DISTINCT L.C_Code)
FROM
    Instructors I,
    Person PI,
    Linked_to L
WHERE
    I.Instructor_ID = L.Instruc_ID
    AND I.Pers_ID = PI.Person_ID
GROUP BY
    I.Instructor_ID, PI.Fname, PI.Minit, PI.Lname, L.Semester, L.Year
ORDER BY
    L.Year, L.Semester, PI.Fname, PI.Lname;

-- Query 5: Retrieve the list of students who received scholarships worth more than $2,000, sorted by sponsor.

SELECT
    S.Student_ID,
    P.Fname, P.Minit, P.Lname,
    SC.Scholarship_Name,
    SC.Sponsor_Name,
    SC.Amount
FROM
    Students S,
    Person P,
    Awarded A,
    Scholarships SC
WHERE
    S.Student_ID = A.Stud_ID
    AND S.Pers_ID = P.Person_ID
    AND A.Scholar_Name = SC.Scholarship_Name
    AND SC.Amount > 2000
ORDER BY
    SC.Sponsor_Name, P.Fname, P.Lname;

-- Query 6: Identify any classroom scheduling conflicts (i.e., two courses scheduled at the same time in the same room).

SELECT
    CO1.Build_Name,
    CO1.Room_No,
    CO1.Course_Time,
    CO1.Semester,
    CO1.Year,
    CO1.C_Code,
    CO2.C_Code
FROM
    Course_Offerings CO1,
    Course_Offerings CO2
WHERE
    CO1.Build_Name = CO2.Build_Name
    AND CO1.Room_No = CO2.Room_No
    AND CO1.Course_Time = CO2.Course_Time
    AND CO1.Semester = CO2.Semester
    AND CO1.Year = CO2.Year
    AND CO1.C_Code < CO2.C_Code
ORDER BY
    CO1.Year, CO1.Semester, CO1.Build_Name, CO1.Room_No, CO1.Course_Time;