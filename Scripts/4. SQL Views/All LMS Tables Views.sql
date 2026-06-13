-- =========================
-- ENROLLMENTS
-- =========================
CREATE VIEW v_Enrollments AS
SELECT DISTINCT
    Id AS EnrollmentId,
    NULLIF(LTRIM(RTRIM(CourseId)), '') AS CourseId,
    NULLIF(LTRIM(RTRIM(UserId)), '') AS UserId,

    -- ✅ Clean Email
    LOWER(
        RIGHT(UserLoginName,
        LEN(UserLoginName) - CHARINDEX('|', UserLoginName, CHARINDEX('|', UserLoginName) + 1))
    ) AS UserEmailId,

    NULLIF(LTRIM(RTRIM(Role)), '') AS Roles,

    TRY_CAST(RegistrationDate AS DATETIME) AS RegistrationDate,
    TRY_CAST(StartDate AS DATETIME) AS StartDate,
    TRY_CAST(CompletionDate AS DATETIME) AS CompletionDate,
    --TRY_CAST(DueDate AS DATETIME) AS DueDate,
    TRY_CAST(EndDate AS DATETIME) AS EndDate,
    --TRY_CAST(RegistrationStatusChangedDate AS DATETIME) AS RegistrationStatusChangedDate,
    TRY_CAST(CreatedAt AS DATETIME) AS CreatedAt,
    --TRY_CAST(ModifiedAt AS DATETIME) AS ModifiedAt,

    NULLIF(LTRIM(RTRIM(RegistrationStatus)), '') AS RegistrationStatus,
    NULLIF(LTRIM(RTRIM(CoursePassingStatus)), '') AS CoursePassingStatus,
    --NULLIF(LTRIM(RTRIM(CancellationReason)), '') AS CancellationReason,

    --NULLIF(LTRIM(RTRIM(CertificateId)), '') AS CertificateId,
    NULLIF(LTRIM(RTRIM(CourseSessionId)), '') AS CourseSessionId,
    --NULLIF(LTRIM(RTRIM(CreatedByUserId)), '') AS CreatedByUserId,

    TRY_CAST(CEU AS FLOAT) AS CEU,
    TRY_CAST(DecimalCEU AS FLOAT) AS DecimalCEU,
    TRY_CAST(CourseDuration AS FLOAT) AS CourseDuration,

    --TRY_CAST(IsImported AS BIT) AS IsImported,
    TRY_CAST(IsPartOfTrainingPlan AS BIT) AS IsPartOfTrainingPlan
    --TRY_CAST(CanUnenroll AS BIT) AS CanUnenroll

FROM Enrollments;
GO

-- =========================
-- ATTENDANCES
-- =========================
CREATE VIEW v_Attendances AS
SELECT DISTINCT
    Id AS AttendancesId,
    EnrollmentId,
    CourseSessionId,

    LOWER(
        RIGHT(UserLoginName,
        LEN(UserLoginName) - CHARINDEX('|', UserLoginName, CHARINDEX('|', UserLoginName) + 1))
    ) AS EnrollmentUserEmail,

    TRY_CAST([Percent] AS FLOAT) AS AttendancesPercent,
    TRY_CAST(CreatedAt AS DATETIME) AS AttendancesCreatedAt
    --TRY_CAST(ModifiedAt AS DATETIME) AS AttendancesModifiedAt

FROM Attendances;
GO


-- =========================
-- COURSE CATALOGS
-- =========================
CREATE VIEW v_CourseCatalogs AS
SELECT DISTINCT
    Id AS CourseCatalogsId,
    NULLIF(LTRIM(RTRIM(Title)), '') AS  CourseCatalogsTitle,
    TRY_CAST(IsDeleted AS BIT) AS IsDeleted
FROM CourseCatalogs;
GO


-- =========================
-- COURSE CATEGORIES
-- =========================
CREATE VIEW v_CourseCategories AS
SELECT DISTINCT
    Category_Id AS CategoriesId,
    NULLIF(LTRIM(RTRIM(Category_Name)), '') AS CategoriesName,

    Category_CourseCatalogId AS CourseCatalogId,
    Category_ParentCategoryId AS ParentCategoryId,

    Course_Id AS CoursesId,
    --Course_CourseID AS CourseHGIID,

    NULLIF(LTRIM(RTRIM(Course_Title)), '') AS CourseTitle

    --TRY_CAST(Course_CEU AS FLOAT) AS Course_CEU,
    --TRY_CAST(Course_DecimalCEU AS FLOAT) AS Course_DecimalCEU,
    --TRY_CAST(Course_Duration AS FLOAT) AS Course_Duration,
    --TRY_CAST(Course_DurationInMinutes AS FLOAT) AS Course_DurationInMinutes,
    --TRY_CAST(Course_MaxAttendees AS INT) AS Course_MaxAttendees

    --TRY_CAST(Course_ShowInCatalog AS BIT) AS Course_ShowInCatalog,
    --TRY_CAST(Course_IsRequired AS BIT) AS Course_IsRequired,
    --TRY_CAST(Course_IsPublished AS BIT) AS Course_IsPublished,
    --TRY_CAST(Course_IsDeleted AS BIT) AS Course_IsDeleted,
    --TRY_CAST(Course_CreatedAt AS DATETIME) AS Course_CreatedAt,
    --TRY_CAST(Course_ModifiedAt AS DATETIME) AS Course_ModifiedAt

FROM CourseCategories;
GO


-- =========================
-- COURSES
-- =========================
CREATE VIEW v_Courses AS
SELECT DISTINCT
    Id AS CoursesId,
    CourseCatalogId,
    CourseID AS CourseIDQCHP,
    CourseType,

    NULLIF(LTRIM(RTRIM(Title)), '') AS CourseTitle,

    TRY_CAST(CEU AS FLOAT) AS CEU,
    TRY_CAST(DecimalCEU AS FLOAT) AS DecimalCEU,
    --TRY_CAST(Duration AS FLOAT) AS Duration,
    --TRY_CAST(DurationInMinutes AS FLOAT) AS DurationInMinutes,

    TRY_CAST(ShowInCatalog AS BIT) AS ShowInCatalog,
    TRY_CAST(IsPublished AS BIT) AS IsPublished,
    TRY_CAST(IsDeleted AS BIT) AS IsDeleted,

    --TRY_CAST(EnrollmentDeadline AS DATETIME) AS EnrollmentDeadline,
    TRY_CAST(CreatedAt AS DATETIME) AS CreatedAt,
    TRY_CAST(ModifiedAt AS DATETIME) AS ModifiedAt,
    TRY_CAST(Publishing_StartDate AS DATETIME) As Publishing_StartDate,
    TRY_CAST(Publishing_EndDate AS DATETIME) As Publishing_EndDate,


    TRY_CAST(Rating_Rating AS FLOAT) AS Rating
    --TRY_CAST(Rating_Count AS INT) AS RatingCount

FROM Courses;
GO

-- =========================
-- COURSE SESSIONS
-- =========================
CREATE VIEW v_CourseSessions AS
SELECT DISTINCT
    Id AS CourseSessionsId,
    CourseId,

    NULLIF(LTRIM(RTRIM(Title)), '') AS CourseSessionsTitle,

    --TRY_CAST(MaxAttendees AS INT) AS MaxAttendees,
    TRY_CAST(TakenSeatsCount AS INT) AS TakenSeatsCount,

    TRY_CAST(StartDate AS DATETIME) AS SessionStartDate,
    TRY_CAST(EndDate AS DATETIME) AS SessionEndDate

    --TRY_CAST(EnrollmentDeadline AS DATETIME) AS EnrollmentDeadline,
    --TRY_CAST(CreatedAt AS DATETIME) AS CreatedAt,
    --TRY_CAST(ModifiedAt AS DATETIME) AS ModifiedAt

FROM CourseSessions;
GO


-- =========================
-- USERS
-- =========================
CREATE VIEW v_Users AS
SELECT DISTINCT
    Id AS UserId,

    LOWER(NULLIF(LTRIM(RTRIM(Email)), '')) AS UserEmail,
    LTRIM(RTRIM(ISNULL(FirstName,'') + ' ' + ISNULL(LastName,''))) AS FullName,
    LEFT(LTRIM(RTRIM(Department)), CHARINDEX('-', Department + '-') - 1) AS Department,

    NULLIF(LTRIM(RTRIM(JobTitle)), '') AS JobTitle,
    NULLIF(LTRIM(RTRIM(Company)), '') AS JobLocation,
    NULLIF(LTRIM(RTRIM(City)), '') AS City,

    LOWER(
        RIGHT(ManagerLoginName,
        LEN(ManagerLoginName) - CHARINDEX('|', ManagerLoginName, CHARINDEX('|', ManagerLoginName) + 1))
    ) AS ManagerEmail,

    /*TRY_CAST(IsExternal AS BIT) AS*/ IsExternal,
    --TRY_CAST(IsDisabled AS BIT) AS IsDisabled,
    /*TRY_CAST(IsDeleted AS BIT) AS*/ IsDeleted,

    TRY_CAST(CreatedAt AS DATETIME) AS CreatedAt

FROM Users;
GO


-- =========================
-- TRAINING PLANS
-- =========================
CREATE VIEW v_TrainingPlans AS
SELECT DISTINCT
    TrainingPlanId,
    NULLIF(LTRIM(RTRIM(TrainingPlanTitle)), '') AS TrainingPlanTitle,
    TRY_CAST(TrainingPlanCreatedAt AS DATETIME) AS TrainingPlanCreatedAt,
    --TRY_CAST(Course_Order AS INT) AS Course_Order,
    --TRY_CAST(Course_HasPrerequisite AS BIT) AS Course_HasPrerequisite,

    Course_CourseId AS CourseId

FROM TrainingPlans;

-- ====================================
/*
SELECT COUNT(DISTINCT EnrollmentId) AS TotalUniqueEnrollments
FROM v_Enrollments
WHERE Roles = 'Learner'
  AND RegistrationDate >= '2025-01-01' 
  AND RegistrationDate < '2026-01-01';





Select * from v_Enrollments
--Where RegistrationDate >= '2015-01-01' 
  --AND RegistrationDate < '2016-01-01'
order by RegistrationDate ASC

*/