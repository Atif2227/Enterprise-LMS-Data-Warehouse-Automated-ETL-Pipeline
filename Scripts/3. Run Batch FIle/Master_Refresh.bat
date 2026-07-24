@echo off

cd /d C:\Users\athasan

echo ======================================
echo Starting LMS Refresh...
echo ======================================

"C:\Users\athasan\AppData\Local\anaconda3\python.exe" Users.py
"C:\Users\athasan\AppData\Local\anaconda3\python.exe" Courses.py
"C:\Users\athasan\AppData\Local\anaconda3\python.exe" CourseCatalogs.py
"C:\Users\athasan\AppData\Local\anaconda3\python.exe" CourseCategories.py
"C:\Users\athasan\AppData\Local\anaconda3\python.exe" CourseSessions.py
"C:\Users\athasan\AppData\Local\anaconda3\python.exe" TrainingPlans.py
"C:\Users\athasan\AppData\Local\anaconda3\python.exe" enrollment_incremental_load.py
"C:\Users\athasan\AppData\Local\anaconda3\python.exe" attendance_incremental.py

echo.
echo ======================================
echo LMS Refresh Completed Successfully
echo ======================================

echo %date% %time% - Refresh Completed >> LMS_ETL_Log.txt

echo.
echo This window will close in 60 seconds...
timeout /t 60 >nul