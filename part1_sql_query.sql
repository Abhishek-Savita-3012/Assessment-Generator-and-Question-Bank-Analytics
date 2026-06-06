-- Step 1 : Creating the database first
CREATE DATABASE assignment_db;

-- Step 2 : Selecting the database now
USE assignment_db;

-- Step 3 : Creating the tabel accoring the columns I have in the CSV File
CREATE TABLE question_bank (
    question_id INT PRIMARY KEY,
    subject VARCHAR(100),
    grade INT,
    competency VARCHAR(100),
    difficulty VARCHAR(20),
    question_type VARCHAR(20),
    marks INT,
    question_text TEXT
);

-- Step 4 :Importing the Dataset, first, I right click on the schema, thne select the option Table Data Import Wizard, the select the file
-- and import it

-- Step 5 : Verifying the dataset
SELECT * FROM question_bank LIMIT 10;

-- Step 6 : First, I will check and explore the dataset so that Incan understand the data
-- Check grades available:
SELECT DISTINCT grade FROM question_bank;

-- Check Subjects Available
SELECT DISTINCT subject FROM question_bank;

-- Check difficulties available:
SELECT DISTINCT difficulty FROM question_bank;

-- Check competencies available:
SELECT DISTINCT competency FROM question_bank;

-- Step 7 : Checking Grade 6 Mathematics Questions
SELECT * FROM question_bank WHERE grade = 6 AND subject = 'Mathematics';

-- Step 8 : Checking Difficulty Distribution
SELECT difficulty, COUNT(*) AS total_questions FROM question_bank WHERE grade = 6 AND subject = 'Mathematics' GROUP BY difficulty;

-- Step 9 : Generating the Question Paper
WITH required_questions AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY difficulty
               ORDER BY RAND()
           ) AS rn
    FROM question_bank
    WHERE grade = 6
      AND subject = 'Mathematics'
)

SELECT *
FROM required_questions
WHERE
      (difficulty = 'easy' AND rn <= 4)
   OR (difficulty = 'medium' AND rn <= 4)
   OR (difficulty = 'hard' AND rn <= 2);
   
-- Step 10 : Verify Total Questions
SELECT COUNT(*) AS total_questions
FROM
(
    WITH required_questions AS
    (
        SELECT *,
               ROW_NUMBER() OVER
               (
                   PARTITION BY difficulty
                   ORDER BY RAND()
               ) AS rn
        FROM question_bank
        WHERE grade = 6
          AND subject = 'Mathematics'
    )

    SELECT *
    FROM required_questions
    WHERE
          (difficulty = 'easy' AND rn <= 4)
       OR (difficulty = 'medium' AND rn <= 4)
       OR (difficulty = 'hard' AND rn <= 2)
) x;

-- Step 11 : Verify Competencies
WITH required_questions AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY difficulty
               ORDER BY RAND()
           ) AS rn
    FROM question_bank
    WHERE grade = 6
      AND subject = 'Mathematics'
)

SELECT COUNT(DISTINCT competency) AS competency_count
FROM required_questions
WHERE
      (difficulty = 'easy' AND rn <= 4)
   OR (difficulty = 'medium' AND rn <= 4)
   OR (difficulty = 'hard' AND rn <= 2);
