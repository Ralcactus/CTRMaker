@echo off
cd /d "%~dp0"

rem %1 = TARGET name from GameMaker
make TARGET=%1 -f Makefile
