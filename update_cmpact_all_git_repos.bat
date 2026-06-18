@echo off
setlocal enabledelayedexpansion

set "ROOT=C:\Users\steve\Documents\GitHub"
:: set "ROOT=C:\Users\ssanders\Documents\GitHub\"

echo.=============================================================
echo Updating Git repositories in:
echo %ROOT%
echo.=============================================================

if not exist "%ROOT%" (
    echo ERROR: Folder does not exist:
    echo %ROOT%
    pause
    exit /b 1
)

for /d %%D in ("%ROOT%\*") do (
    echo ------------------------------------------------------------
    echo Checking: %%~nxD
    echo Path: %%D

    if exist "%%D\.git" (
        echo Git repository found.
        echo.

        pushd "%%D"

        echo Running: git status --short
        git status --short

        echo.
        echo Running: git pull --ff-only
        git pull --ff-only

        if errorlevel 1 (
            echo.
            echo WARNING: git pull failed for %%~nxD
            echo This may be due to local changes, conflicts, or a non-fast-forward update.
            echo Skipping cleanup for this repository.
            popd
            echo.
        ) else (
            echo.
            echo Running: git gc
            git gc

            echo.
            echo Running: git repack -a -d
            git repack -a -d

            echo.
            echo Finished: %%~nxD
            popd
            echo.
        )
    ) else (
        echo Skipping: Not a Git repository.
        echo.
    )
)

echo ------------------------------------------------------------
echo All done.
pause

endlocal