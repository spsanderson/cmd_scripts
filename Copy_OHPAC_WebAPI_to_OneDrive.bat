@echo off
setlocal EnableExtensions

REM ============================================================
REM Copy OHPAC WebAPI files to OneDrive
REM from: C:\Users\ssanders\Documents\GitHub\my_obsidian_vault\Work\Projects\EMUE\WEB and API\OHPAC API Documentation
REM to: C:\Users\ssanders\OneDrive - stonybrookmedicine\Oracle\OHPAC Web API
REM ============================================================

set "SOURCE=C:\Users\ssanders\Documents\GitHub\my_obsidian_vault\Work\Projects\EMUE\WEB and API\OHPAC API Documentation"
set "DEST=C:\Users\ssanders\OneDrive - stonybrookmedicine\Oracle\OHPAC Web API"
set "LOGDIR=C:\Users\ssanders\OneDrive - stonybrookmedicine\Oracle\Logs"

REM ------------------------------------------------------------
REM Create log directory if it doesn't exist
REM ------------------------------------------------------------
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

REM ------------------------------------------------------------
REM Generate a locale-independat timestamp using PowerShell
REM Example: 2026-08-19_091300
REM ------------------------------------------------------------

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"') do set "TIMESTAMP=%%I"

set "LOGFILE=%LOGDIR%\Copy_OHPAC_WebAPI_to_OneDrive_%TIMESTAMP%.log"

REM ------------------------------------------------------------
REM Write header
REM ------------------------------------------------------------
echo ============================================================ >> "%LOGFILE%"
echo Copy OHPAC WebAPI files to OneDrive >> "%LOGFILE%"
echo Started: %DATE% %TIME% >> "%LOGFILE%"
echo Source: %SOURCE% >> "%LOGFILE%"
echo Destination: %DEST% >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"
echo. >> "%LOGFILE%"

REM ------------------------------------------------------------
REM Verify source exists
REM ------------------------------------------------------------
if not exist "%SOURCE%" (
    echo ERROR: Source directory does not exist. >> "%LOGFILE%"
    echo Source: %SOURCE% >> "%LOGFILE%"
    exit /b 10
)

REM ------------------------------------------------------------
REM Verify/create destination
REM ------------------------------------------------------------
if not exist "%DEST%" (
    mkdir "%DEST%"

    if errorlevel 1 (
        echo ERROR: Could not create destination directory. >> "%LOGFILE%"
        exit /b 11
    )
)

REM ------------------------------------------------------------
REM Copy files
REM
REM /E       Copy all subdirectories, including empty ones
REM /COPY:DAT
REM          Copy Data, Attributes, and Timestamps
REM /DCOPY:T Preserve directory timestamps
REM /R:3     Retry failed files 3 times
REM /W:5     Wait 5 seconds between retries
REM /Z       Restartable mode
REM /FFT     Use 2-second timestamp tolerance
REM /NP      Do not display percentage progress
REM /TEE     Write output to console and log
REM /LOG+    Append robocopy output to the log
REM ------------------------------------------------------------

robocopy "%SOURCE%" "%DEST%" ^
    /E ^
    /COPY:DAT ^
    /DCOPY:T ^
    /R:3 ^
    /W:5 ^
    /Z ^
    /FFT ^
    /NP ^
    /TEE ^
    /LOG+:"%LOGFILE%"

set "ROBOCOPY_EXIT=%ERRORLEVEL%"

REM ------------------------------------------------------------
REM Robocopy exit codes 0-7 are considered successful.
REM 8 or higher indicates at least one failure.
REM ------------------------------------------------------------

echo. >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"
echo Finished: %DATE% %TIME% >> "%LOGFILE%"
echo Robocopy Exit Code: %ROBOCOPY_EXIT% >> "%LOGFILE%"

if %ROBOCOPY_EXIT% LEQ 7 (
    echo Status: SUCCESS >> "%LOGFILE%"
    echo ============================================================ >> "%LOGFILE%"
    exit /b 0
) else (
    echo Status: FAILED >> "%LOGFILE%"
    echo ============================================================ >> "%LOGFILE%"
    exit /b %ROBOCOPY_EXIT%
)

endlocal