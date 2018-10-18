@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
echo Enabling integrity checks and enable driver test signing."
bcdedit /deletevalue nointegritychecks 
bcdedit /deletevalue loadoptions 
bcdedit /debug off 
bcdedit -set loadoptions ENABLE_INTEGRITY_CHECKS
bcdedit
echo "If command completed successfully. you may press any key to close this window and reboot. If you see errors. Close this window and run this script as administrator."
pause
shutdown /r
:--------------------------------------


