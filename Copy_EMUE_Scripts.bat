@echo off
setlocal EnableExtensions

REM ============================================================
REM EMUE Script Backup
REM ============================================================

set "SOURCE=W:\PATACCT\BusinessOfc\Revenue Cycle Analyst\Emue"
set "DEST=C:\Users\ssanders\OneDrive - stonybrookmedicine\EMUE\script_backups"
set "LOGDIR=C:\Users\ssanders\OneDrive - stonybrookmedicine\EMUE\script_backups\Logs"

REM ------------------------------------------------------------
REM Create log directory if it does not exist
REM ------------------------------------------------------------
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

REM ------------------------------------------------------------
REM Generate a locale-independent timestamp using PowerShell
REM Example: 2026-09-01_103300
REM ------------------------------------------------------------
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HHmmss"') do set "TIMESTAMP=%%I"

set "LOGFILE=%LOGDIR%\EMUE_Backup_%TIMESTAMP%.log"

REM ------------------------------------------------------------
REM Write header
REM ------------------------------------------------------------
echo ============================================================ > "%LOGFILE%"
echo EMUE Script Backup >> "%LOGFILE%"
echo Started: %DATE% %TIME% >> "%LOGFILE%"
echo Source:  %SOURCE% >> "%LOGFILE%"
echo Target:  %DEST% >> "%LOGFILE%"
echo File Type: *.emue >> "%LOGFILE%"
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
REM Copy EMUE files
REM
REM *.emue   Only copy EMUE files
REM /S       Include subdirectories, excluding empty directories
REM /COPY:DAT
REM          Copy Data, Attributes, and Timestamps
REM /DCOPY:T Preserve directory timestamps
REM /R:3     Retry failed files 3 times
REM /W:5     Wait 5 seconds between retries
REM /Z       Restartable mode
REM /FFT     Use 2-second timestamp tolerance
REM /NP      Do not display percentage progress
REM /TEE     Write output to console and log
REM /LOG+    Append Robocopy output to the log
REM ------------------------------------------------------------

robocopy "%SOURCE%" "%DEST%" "*.emue" ^
    /S ^
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