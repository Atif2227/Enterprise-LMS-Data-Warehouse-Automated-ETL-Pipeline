-- ENROLLMENTS VIEW
CREATE VIEW v_Enrollments AS
SELECT
    Id as EnrollmentId,
    CourseId,
    UserId,
    -- ✅ Extract clean email
    RIGHT(UserLoginName, LEN(UserLoginName) - CHARINDEX('|', UserLoginName, CHARINDEX('|', UserLoginName) + 1)) AS UserEmailId,
    Roles,

    -- ✅ Dates
    TRY_CAST(RegistrationDate AS DATETIME) AS RegistrationDate,
    TRY_CAST(StartDate AS DATETIME) AS StartDate,
    TRY_CAST(CompletionDate AS DATETIME) AS CompletionDate,
    TRY_CAST(DueDate AS DATETIME) AS DueDate,
    TRY_CAST(EndDate AS DATETIME) AS EndDate,
    TRY_CAST(RegistrationStatusChangedDate AS DATETIME) AS RegistrationStatusChangedDate,
    TRY_CAST(CreatedAt AS DATETIME) AS CreatedAt,
    TRY_CAST(ModifiedAt AS DATETIME) AS ModifiedAt,

    -- ✅ Status fields
    RegistrationStatus,
    CoursePassingStatus,
    CancellationReason,

    -- ✅ IDs
    CertificateId,
    CourseSessionId,
    CreatedByUserId,

    -- ✅ Numeric conversions
    TRY_CAST(CEU AS FLOAT) AS CEU,
    TRY_CAST(DecimalCEU AS FLOAT) AS DecimalCEU,
    TRY_CAST(CourseDuration AS FLOAT) AS CourseDuration,

    -- ✅ Boolean-like fields
    TRY_CAST(IsImported AS BIT) AS IsImported,
    TRY_CAST(IsPartOfTrainingPlan AS BIT) AS IsPartOfTrainingPlan,
    TRY_CAST(CanUnenroll AS BIT) AS CanUnenroll

FROM Enrollments;
-------------------------------------------------------------------------------


-- ATTENDANCE VIEW
CREATE VIEW v_Attendances AS
SELECT
    Id AS AttendancesId,
    EnrollmentId AS AttendancesEnrollmentId,
    CourseSessionId AS AttendancesCourseSessionId,

    -- ✅ Extract clean email
    RIGHT(UserLoginName, LEN(UserLoginName) - CHARINDEX('|', UserLoginName, CHARINDEX('|', UserLoginName) + 1)) AS EnrollmentUserEmail,

    -- ✅ Numeric
    TRY_CAST([Percent] AS FLOAT) AS AttendancesPercent,

    -- ✅ Dates
    TRY_CAST(CreatedAt AS DATETIME) AS AttendancesCreatedAt,
    TRY_CAST(ModifiedAt AS DATETIME) AS AttendancesModifiedAt

FROM Attendances;
--------------------------------------------------------------------


-- COURSE CATALOG VIEW
CREATE VIEW v_CourseCatalogs AS
SELECT
    Id AS CourseCatalogsId,
    Title AS CourseCatalogsTitle,

    -- ✅ Boolean conversion
    TRY_CAST(IsDeleted AS BIT) AS IsDeleted

FROM CourseCatalogs;
----------------------------------------------------------------------

-- COURSE CATEGORIES VIEW
CREATE VIEW v_CourseCategories AS
SELECT
    -- ✅ Category fields
    Category_Id AS CategoriesId,
    Category_Name AS CategoriesName,
    Category_CourseCatalogId AS CourseCatalogId,
    Category_ParentCategoryId AS ParentCategoryId,
    Category_ParentCategory AS ParentCategory,


    -- ✅ Course identifiers
    Course_Id AS CoursesId,
    Course_CourseID AS CourseHGIID,

    -- ✅ Course basic info
    Course_Title AS CourseTitle,
    Course_Description,
    Course_LongDescription,

    -- ✅ Numeric fields
    TRY_CAST(Course_CEU AS FLOAT) AS Course_CEU,
    TRY_CAST(Course_DecimalCEU AS FLOAT) AS Course_DecimalCEU,
    TRY_CAST(Course_Duration AS FLOAT) AS Course_Duration,
    TRY_CAST(Course_DurationInMinutes AS FLOAT) AS Course_DurationInMinutes,
    TRY_CAST(Course_MaxAttendees AS INT) AS Course_MaxAttendees,

    -- ✅ Boolean fields
    
    TRY_CAST(Course_ShowInCatalog AS BIT) AS Course_ShowInCatalog,
    TRY_CAST(Course_IsRequired AS BIT) AS Course_IsRequired,
    TRY_CAST(Course_IsPublished AS BIT) AS Course_IsPublished,
    TRY_CAST(Course_IsEnded AS BIT) AS Course_IsEnded,
    TRY_CAST(Course_IsScheduled AS BIT) AS Course_IsScheduled,
    TRY_CAST(Course_IsPromotionalTraining AS BIT) AS Course_IsPromotionalTraining,
    TRY_CAST(Course_IsDeleted AS BIT) AS Course_IsDeleted,
    TRY_CAST(Course_SessionRequestsEnabled AS BIT) AS Course_SessionRequestsEnabled,
    TRY_CAST(Course_WaitingListEnabled AS BIT) AS Course_WaitingListEnabled,
    TRY_CAST(Course_UnenrollDisabled AS BIT) AS Course_UnenrollDisabled,
    TRY_CAST(Course_CourseTargetingEnabled AS BIT) AS Course_CourseTargetingEnabled,
    TRY_CAST(Course_IsRetakeAllowed AS BIT) AS Course_IsRetakeAllowed,
    TRY_CAST(Course_AssignmentsEnabled AS BIT) AS Course_AssignmentsEnabled,
    TRY_CAST(Course_IsEnrollmentWithoutSessionsAllowed AS BIT) AS Course_IsEnrollmentWithoutSessionsAllowed,
    TRY_CAST(Course_IsChangeSessionRegistrationsAllowed AS BIT) AS Course_IsChangeSessionRegistrationsAllowed,
    TRY_CAST(Course_ExcludeFromLicenseCalculations AS BIT) AS Course_ExcludeFromLicenseCalculations,
    TRY_CAST(Course_IsSurveyEnabled AS BIT) AS Course_IsSurveyEnabled,
    TRY_CAST(Course_IsEnableForIndexing AS BIT) AS Course_IsEnableForIndexing,

    -- ✅ Dates
    TRY_CAST(Course_EnrollmentDeadline AS DATETIME) AS Course_EnrollmentDeadline,
    TRY_CAST(Course_CreatedAt AS DATETIME) AS Course_CreatedAt,
    TRY_CAST(Course_ModifiedAt AS DATETIME) AS Course_ModifiedAt,

    -- ✅ Other metadata
    Course_CourseType AS CourseType
    --Course_CertificateTemplateId,
    --Course_EnrollmentFlow,
    --Course_CourseSessionEnrollmentType,
    --Course_CourseLayoutId,
    --Course_ExternalReference,

    -- ✅ Duplicate category fields (keep consistent naming)
    --Id AS Raw_Id,
    --Name AS Raw_Name,
    --CourseCatalogId AS Raw_CourseCatalogId,
    --ParentCategoryId AS Raw_ParentCategoryId

FROM CourseCategories;


----------------------------------------------------------------------

-- COURSES VIEW
CREATE VIEW v_Courses AS
SELECT
    -- ✅ Keys
    Id AS CoursesId,
    CourseCatalogId,
    CourseID AS CourseHGIID,

    -- ✅ Basic info
    Title AS CourseTitle,
    Description,
    --LongDescription,
    --Url,
    --ImageUrl,
    --BannerImageUrl,

    -- ✅ Numeric fields
    TRY_CAST(CEU AS FLOAT) AS CEU,
    TRY_CAST(DecimalCEU AS FLOAT) AS DecimalCEU,
    TRY_CAST(Duration AS FLOAT) AS Duration,
    TRY_CAST(DurationInMinutes AS FLOAT) AS DurationInMinutes,
    TRY_CAST(MaxAttendees AS INT) AS MaxAttendees,

    -- ✅ Boolean fields
    TRY_CAST(ShowInCatalog AS BIT) AS ShowInCatalog,
    TRY_CAST(IsRequired AS BIT) AS IsRequired,
    TRY_CAST(IsPublished AS BIT) AS IsPublished,
    TRY_CAST(IsEnded AS BIT) AS IsEnded,
    TRY_CAST(IsScheduled AS BIT) AS IsScheduled,
    TRY_CAST(IsPromotionalTraining AS BIT) AS IsPromotionalTraining,
    TRY_CAST(IsDeleted AS BIT) AS IsDeleted,
    TRY_CAST(SessionRequestsEnabled AS BIT) AS SessionRequestsEnabled,
    TRY_CAST(WaitingListEnabled AS BIT) AS WaitingListEnabled,
    TRY_CAST(UnenrollDisabled AS BIT) AS UnenrollDisabled,
    TRY_CAST(CourseTargetingEnabled AS BIT) AS CourseTargetingEnabled,
    TRY_CAST(IsRetakeAllowed AS BIT) AS IsRetakeAllowed,
    TRY_CAST(AssignmentsEnabled AS BIT) AS AssignmentsEnabled,
    TRY_CAST(IsEnrollmentWithoutSessionsAllowed AS BIT) AS IsEnrollmentWithoutSessionsAllowed,
    TRY_CAST(IsChangeSessionRegistrationsAllowed AS BIT) AS IsChangeSessionRegistrationsAllowed,
    TRY_CAST(ExcludeFromLicenseCalculations AS BIT) AS ExcludeFromLicenseCalculations,
    TRY_CAST(IsSurveyEnabled AS BIT) AS IsSurveyEnabled,
    TRY_CAST(IsEnableForIndexing AS BIT) AS IsEnableForIndexing,

    -- ✅ Dates
    TRY_CAST(EnrollmentDeadline AS DATETIME) AS EnrollmentDeadline,
    TRY_CAST(CreatedAt AS DATETIME) AS CreatedAt,
    TRY_CAST(ModifiedAt AS DATETIME) AS ModifiedAt,

    -- ✅ Other metadata
    CourseType,
    --CertificateTemplateId,
    EnrollmentFlow,
    CourseSessionEnrollmentType,
    CourseLayoutId,
    ExternalReference,

    -- ✅ Expanded Ratings
    TRY_CAST(Rating_Rating AS FLOAT) AS Rating,
    TRY_CAST(Rating_Count AS FLOAT) AS RatingCount

FROM Courses;
----------------------------------------------------------------------


-- COURSE SESSIONS VIEW
CREATE VIEW v_CourseSessions AS
SELECT
    -- ✅ Keys
    Id AS CourseSessionsId,
    CourseId,
    GroupId,

    -- ✅ Basic info
    Title AS CourseSessionsTitle,
    --Description,
    --Room,
    --MeetingUrl,
    --TimeZone,
    --TimeZoneName,

    -- ✅ Numeric fields
    TRY_CAST(MaxAttendees AS INT) AS MaxAttendees,
    TRY_CAST(TakenSeatsCount AS INT) AS TakenSeatsCount,
    TRY_CAST(Cost AS FLOAT) AS Cost,

    -- ✅ Dates (core)
    TRY_CAST(StartDate AS DATETIME) AS StartDate,
    TRY_CAST(EndDate AS DATETIME) AS EndDate,
    --TRY_CAST(StartDateLocal AS DATETIME) AS StartDateLocal,
    --TRY_CAST(EndDateLocal AS DATETIME) AS EndDateLocal,
    TRY_CAST(EnrollmentDeadline AS DATETIME) AS EnrollmentDeadline,
    TRY_CAST(EnrollmentDeadlineLocal AS DATETIME) AS EnrollmentDeadlineLocal,
    TRY_CAST(CreatedAt AS DATETIME) AS CreatedAt,
    TRY_CAST(ModifiedAt AS DATETIME) AS ModifiedAt,

    -- ✅ Attendance window
    TRY_CAST(AttendanceStartDate AS DATETIME) AS AttendanceStartDate,
    TRY_CAST(AttendanceEndDate AS DATETIME) AS AttendanceEndDate,
    --TRY_CAST(AttendanceStartDateLocal AS DATETIME) AS AttendanceStartDateLocal,
    --TRY_CAST(AttendanceEndDateLocal AS DATETIME) AS AttendanceEndDateLocal,

    -- ✅ Boolean flags
    TRY_CAST(IsTeamsOnlineMeeting AS BIT) AS IsTeamsOnlineMeeting,
    TRY_CAST(AssignMeetingCoOrganizersEnabled AS BIT) AS AssignMeetingCoOrganizersEnabled,
    TRY_CAST(GetAttendanceFromTeamsEnabled AS BIT) AS GetAttendanceFromTeamsEnabled,
    TRY_CAST(AutoRegisterAttendanceFromTeamsEnabled AS BIT) AS AutoRegisterAttendanceFromTeamsEnabled,
    TRY_CAST(AllowLearnerToSetAttendance AS BIT) AS AllowLearnerToSetAttendance,
    TRY_CAST(IsSignatureRequired AS BIT) AS IsSignatureRequired,
    TRY_CAST(IsQrCodeRequired AS BIT) AS IsQrCodeRequired,
    TRY_CAST(IsGroup AS BIT) AS IsGroup

FROM CourseSessions;
----------------------------------------------------------------------


-- USERS VIEW
CREATE VIEW v_Users AS
SELECT
    -- ✅ Keys
    Id AS UserId,

    -- ✅ Clean Email (preferred key)
    LOWER(Email) AS UserEmail,

    -- ✅ Basic info
    FirstName + ' ' + LastName AS FullName,
    FirstName,
    LastName,
    Title,
    JobTitle,
    LEFT(Department, CHARINDEX('-', Department + '-') - 1) AS Department,
    Company AS Location,
    Office,
    City,
    Country,
    Phone,

    -- ✅ Manager info (cleaned)
    ManagerId,
    RIGHT(ManagerLoginName, LEN(ManagerLoginName) - CHARINDEX('|', ManagerLoginName, CHARINDEX('|', ManagerLoginName) + 1)) AS ManagerEmail,

    -- ✅ Directory fields
    DirectoryObjectId,
    PrincipalType,
    UserSource,

    -- ✅ Boolean flags
    TRY_CAST(IsExternal AS BIT) AS IsExternal,
    TRY_CAST(IsDisabled AS BIT) AS IsDisabled,
    TRY_CAST(IsDeleted AS BIT) AS IsDeleted,
    TRY_CAST(IsProxyManager AS BIT) AS IsProxyManager,

    -- ✅ Dates
    TRY_CAST(CreatedAt AS DATETIME) AS CreatedAt,
    TRY_CAST(ModifiedAt AS DATETIME) AS ModifiedAt

FROM Users;


----------------------------------------------------------------------


-- TRAINING PLAN VIEW
CREATE VIEW v_TrainingPlans AS
SELECT
    -- ✅ Training Plan fields
    TrainingPlanId,
    TrainingPlanTitle,
    CourseCatalogId,

    -- ✅ Dates
    TRY_CAST(TrainingPlanCreatedAt AS DATETIME) AS TrainingPlanCreatedAt,
    TRY_CAST(TrainingPlanModifiedAt AS DATETIME) AS TrainingPlanModifiedAt,

    -- ✅ Course mapping
    Course_CourseId AS CourseId,
    --Course_TrainingPlanId,

    -- ✅ Order (numeric)
    TRY_CAST([Course_Order] AS INT) AS Course_Order,

    -- ✅ Boolean
    TRY_CAST(Course_HasPrerequisite AS BIT) AS Course_HasPrerequisite

FROM TrainingPlans;

----------------------------------------------------------------------

Select * from v_Enrollments
Select * from v_Attendances
Select * from v_CourseCatalogs