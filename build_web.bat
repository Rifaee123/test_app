@echo off
echo ==============================================
echo      Building Flutter Web Application
echo ==============================================

echo Cleaning previous builds...
call flutter clean

echo Getting dependencies...
call flutter pub get

echo Building for Web (Release mode)...
call flutter build web --release

echo ==============================================
echo Build Complete!
echo The build artifacts are in build/web
echo ==============================================
pause
