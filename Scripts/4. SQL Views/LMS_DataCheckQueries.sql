-- ENROLLMENTS
SELECT * FROM [dbo].[Enrollments];
-- All the columns data type is 'NVARCHAR that is Text', when loaded from Python to SSMS DB.
-- To set index on any Date column, first that date column needs to be converted into 'Datetime' or 'Date' data type.
ALTER TABLE [dbo].[Enrollments]
ADD RegistrationDate_DT DATETIME;

UPDATE [dbo].[Enrollments]
SET RegistrationDate_DT = TRY_CONVERT(DATETIME, RegistrationDate);

CREATE INDEX idx_reg_date ON Enrollments (RegistrationDate_DT);


-- COURSES
SELECT * FROM [dbo].[Courses];


-- COURSE CATEGORIES
SELECT * FROM [dbo].[CourseCategories];

-- USERS
SELECT * FROM [dbo].[Users];

ALTER TABLE Users
ADD LoginName_IDX NVARCHAR(200);

UPDATE Users 
SET LoginName_IDX = LEFT(LoginName, 200);



-- COURSE SESSIONS
SELECT * FROM [dbo].[CourseSessions];


-- TRAINING PLAN
SELECT * FROM [dbo].[TrainingPlans];

-- COURSE CATALOGS 
SELECT * FROM [dbo].[CourseCatalogs];


-- ATTENDANCE 
SELECT * FROM [dbo].[Attendances];

ALTER TABLE [dbo].[Attendances]
ADD UserLoginName_IDX NVARCHAR(200);
GO

UPDATE [dbo].[Attendances] 
SET UserLoginName_IDX = LEFT(UserLoginName, 200);



-- DATA VALIDATION: Validating the data of each table that was ingested. Check if any data failed to be ingested.

-- ENROLLMENTS
SELECT COUNT(*) FROM [dbo].[Enrollments];
SELECT MIN(RegistrationDate_DT), MAX(RegistrationDate_DT) FROM [dbo].[Enrollments];
-- Fast, index-friendly method
SELECT COUNT(*) 
FROM [dbo].[Enrollments] 
WHERE RegistrationDate_DT >= '2026-01-01' 
  AND RegistrationDate_DT < '2027-01-01';


-- COURSES
SELECT COUNT(*) FROM [dbo].[Courses];

-- COURSE CATEGORIES
SELECT COUNT(*) FROM [dbo].[CourseCategories];

-- USERS
SELECT COUNT(*) FROM [dbo].[Users];

-- COURSE SESSIONS
SELECT COUNT(*) FROM [dbo].[CourseSessions];
SELECT MIN(StartDate), MAX(StartDate) FROM [dbo].[CourseSessions];


-- TRAINING PLAN
SELECT COUNT(*) FROM [dbo].[TrainingPlans];

-- COURSE CATALOGS 
SELECT COUNT(*) FROM [dbo].[CourseCatalogs];


-- ATTENDANCE 
SELECT COUNT(*) FROM [dbo].[Attendances];
SELECT MIN(CreatedAt), MAX(CreatedAt) FROM [dbo].[Attendances];







