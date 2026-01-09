@Echo OFF
SETlocal EnableExtensions
SETlocal EnableDelayedExpansion

SET "ScriptTitle=3D Vision Settings + Profiles"
SET "ScriptVersion=1.4"
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


::Driver
IF EXIST "%~dp0Resources\3D Vision\Driver\*.exe" (
    Echo Driver:
    CD "%~dp0Resources/3D Vision/Driver"
    FOR %%E IN (*.exe) Do (
        Echo     [92m %%~nxE [0m
        )
    CD "%~dp0"
    )

::Settings
Echo Settings:
CD "%~dp0Resources/3D Vision/Settings"
FOR %%R IN (*.reg) Do (
    Echo     [94m %%~nR [0m
    )
CD "%~dp0"

::Profiles
Echo Profiles:
CD "%~dp0Resources/NVIDIA Profile Inspector/Profiles"
FOR %%P IN (*.nip) Do (
    Echo     [92m %%~nP [0m
    )
CD "%~dp0"

::ShadowPlay
Echo ShadowPlay:
IF EXIST "%~dp0Resources\ShadowPlay\Login bypass\app.js" (
    Echo     [92m Login bypass [0m
    )
CD "%~dp0Resources/ShadowPlay/Settings"
FOR %%R IN (*.reg) Do (
    Echo     [94m %%~nR [0m
    )
CD "%~dp0"


PAUSE 
:Begin
cls
Echo.


PushD "%~dp0"

::Driver
IF EXIST "%~dp0Resources\3D Vision\Driver\*.exe" (
    Echo Installing driver...
    CD "%~dp0Resources/3D Vision/Driver"
    FOR %%E IN (*.exe) Do (
        Echo     [92m %%~nxE [0m
        "%%~nxE" -s -clean
        Call :ErrorCheck
        )
    )
CD "%~dp0"

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

::ShadowPlay
Echo Configuring ShadowPlay...
IF EXIST "%~dp0Resources\ShadowPlay\Login bypass\app.js" (
    Echo     [92m Login bypass [0m
    copy "%~dp0Resources\ShadowPlay\Login bypass\app.js" "C:\Program Files\NVIDIA Corporation\NVIDIA GeForce Experience\www\app.js" 1>NUL 2>&1
    )
CD "%~dp0Resources/ShadowPlay/Settings"
FOR %%R IN (*.reg) Do (
    Echo     [94m %%~nR [0m
    reg import "%%R" 1>NUL 2>&1
    )
CD "%~dp0"

::Finish
Echo [92mSetup complete.[0m
Echo Once the driver has been installed, press any key to enable 3D Vision.
PAUSE>NUL
"%ProgramFiles(x86)%\NVIDIA Corporation\3D Vision\nvstlink.exe" /enable
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
IF NOT !ERRORLEVEL! == 0 (
    Echo Installer has returned an error code: "!ERRORLEVEL!"
    IF "!ERRORLEVEL!"=="-522190748" (
        Echo Low disk space. Please try to free up some disk space then try again.
        ) else (
        If "!ERRORLEVEL!"=="-467664896" (
            Echo This error was caused by a pending setup, so try manually uninstalling the driver then restart your PC, then run this script again.
        ) else (
            Echo: [91m[Failed][0m Error: !ERRORLEVEL!
            )
        )
    Echo You can close this window to abort the installation or press any key to continue at your own risk.
    )
REM "-469762040" Unknown
Exit /B
