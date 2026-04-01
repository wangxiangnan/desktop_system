@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Desktop System - Multi-Environment Build
echo ========================================

if "%1"=="" goto usage
if "%2"=="" goto usage

set ENV=%1
set PLATFORM=%2

if not "%ENV%"=="dev" if not "%ENV%"=="test" if not "%ENV%"=="staging" if not "%ENV%"=="prod" (
    echo Error: Invalid environment. Use: dev, test, staging, or prod
    exit /b 1
)

if not "%PLATFORM%"=="windows" if not "%PLATFORM%"=="macos" if not "%PLATFORM%"=="linux" (
    echo Error: Invalid platform. Use: windows, macos, or linux
    exit /b 1
)

echo Building %PLATFORM% application for %ENV% environment...
echo.

flutter build %PLATFORM% --dart-define=ENV=%ENV%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Build completed successfully!
    echo Environment: %ENV%
    echo Platform: %PLATFORM%
    echo ========================================
) else (
    echo.
    echo ========================================
    echo Build failed!
    echo ========================================
)

exit /b

:usage
echo Usage: build.bat ^<environment^> ^<platform^>
echo.
echo Environment:
echo   dev      - Development environment
echo   test     - Test environment
echo   staging  - Staging environment
echo   prod     - Production environment
echo.
echo Platform:
echo   windows  - Windows desktop
echo   macos    - macOS desktop
echo   linux    - Linux desktop
echo.
echo Example:
echo   build.bat dev windows
echo   build.bat prod macos
exit /b 1