@echo off
setlocal
title Glance Config Deploy

:: ---------------------------------------------------------------
::  Deploy glance.yml to the Glance host
:: ---------------------------------------------------------------
set "REMOTE_USER=james"
set "REMOTE_HOST=192.168.1.100"
set "REMOTE_PATH=/home/james/stacks/glance/config/glance.yml"
set "LOCAL_FILE=%~dp0glance.yml"

echo ===============================================
echo   Glance Config Deploy
echo ===============================================
echo   Source : %LOCAL_FILE%
echo   Target : %REMOTE_USER%@%REMOTE_HOST%:%REMOTE_PATH%
echo ===============================================
echo.

:: Check the local file exists
if not exist "%LOCAL_FILE%" (
    echo [ERROR] glance.yml not found next to this script.
    goto :end
)

where scp >nul 2>&1
if errorlevel 1 (
    echo [ERROR] scp was not found. Is OpenSSH Client installed?
    goto :end
)

:: Confirm before overwriting the remote file
choice /c YN /n /m "Overwrite the remote config? [Y/N] "
if errorlevel 2 (
    echo.
    echo Deployment cancelled.
    goto :end
)

echo.
echo Uploading...
scp "%LOCAL_FILE%" %REMOTE_USER%@%REMOTE_HOST%:%REMOTE_PATH%
 
if errorlevel 1 (
    echo.
    echo [FAILED] Upload did not complete. Check the host, credentials and path.
) else (
    echo.
    echo [SUCCESS] glance.yml deployed at %DATE% %TIME:~0,8%.
)
 
:end
echo.
pause
endlocal