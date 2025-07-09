@Echo OFF
SETlocal EnableExtensions
SETlocal EnableDelayedExpansion

SET "ScriptTitle=3D Vision Settings + Profiles"
SET "ScriptVersion=1.0"
SET "ScriptTitleVersion=!ScriptTitle! !ScriptVersion!"

Echo [90m::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::[0m
Echo [90m::::::::::::::::::::::::::::::::::::::::::[0m[1m !ScriptTitleVersion! [0m[90m:::::::::::::::::::::::::::::::::::::::::::[0m
Echo [90m::::::::::::::::::::::::::::::::::::::::::: By 3DJ - github.com/ThreeDeeJay ::::::::::::::::::::::::::::::::::::::::::::[0m
Echo.

net session 1>NUL 2>&1 2>&1
IF NOT !ERRORLEVEL! == 0 (
    goto :Elevate
    )

PushD "%~dp0"
Echo Settings:
CD "%~dp0Resources/3D Vision/Settings"
FOR %%R IN (*.reg) Do (
    Echo     [94m %%~nR [0m
    )
CD "%~dp0"
Echo Profiles:
CD "%~dp0Resources/NVIDIA Profile Inspector/Profiles"
FOR %%P IN (*.nip) Do (
    Echo     [92m %%~nP [0m
    )
CD "%~dp0"

PAUSE 
:Begin
cls
Echo.


PushD "%~dp0"
::Settings
Echo Applying settings...
CD "%~dp0Resources/3D Vision/Settings"
FOR %%R IN (*.reg) Do (
    Echo     [94m %%~nR [0m
    reg import "%%R" 1>NUL 2>&1
    )
CD "%~dp0"

::Profiles
Echo Installing profiles...
CD "%~dp0Resources/NVIDIA Profile Inspector/Profiles"
FOR %%P IN (*.nip) Do (
    Echo     [92m %%~nP [0m 
    "%~dp0Resources/NVIDIA Profile Inspector/nvidiaProfileInspector.exe" -silent "%%P" 1>NUL 2>&1
    )
CD "%~dp0"


::Finish
Echo [92mSetup complete.[0m
Echo Notes:
Echo     - 
REM PAUSE>NUL

EXIT/B

:Execute
explorer "%~1"
EXIT /B

:Elevate
set "elevate=!temp!\elevate.vbs"
net file 1>NUL 2>NUL || (
    if "%~1" neq "ELEVATE" (
        Echo "Requesting administrative privileges..."
        >"!elevate!" Echo CreateObject^("Shell.Application"^).ShellExecute "!comspec!", "/c """"%~0"" ""!ExecutableFilePath!"" ""%~1""""", "", "runas", 1
        start "" "wscript" /B /NOLOGO "!elevate!"
        exit /B 1
    ) else (
        del "!elevate!" 1>NUL 2>&1
        <nul set /P "=Could not auto elevate, please rerun as administrator..."
        pause 1>NUL 2>&1
        exit /B 9001
    )
)
shift
del "!elevate!" 1>NUL 2>&1
cd /d "!CD!"

:ErrorCheck
IF !ERRORLEVEL! == 0 (
    Echo [92m[Done][0m
    ) else (
    Echo: [91m[Failed][0m Error: !ERRORLEVEL!
    )
Exit /B