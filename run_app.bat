@echo off
echo Starting Insights App...
echo.
echo Available options:
echo 1. Run on Chrome (recommended)
echo 2. Run on Edge
echo 3. Build for web
echo 4. Run tests
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo Starting on Chrome...
    flutter run -d chrome --web-port=8080
) else if "%choice%"=="2" (
    echo Starting on Edge...
    flutter run -d edge --web-port=8080
) else if "%choice%"=="3" (
    echo Building for web...
    flutter build web
    echo Build complete! Open build/web/index.html in your browser
) else if "%choice%"=="4" (
    echo Running tests...
    flutter test
) else (
    echo Invalid choice. Please run the script again.
)
pause
