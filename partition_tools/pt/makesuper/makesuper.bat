@echo off
setlocal enabledelayedexpansion

if "%1"=="-h" call :Usage & exit /b 1
if "%1"=="" call :Usage & exit /b 1
set "dir=%1"
if not "%2"=="" set customsize=%2
if not exist "%1" echo �ļ���û�ҵ����ܵܣ� & exit /b 1

set "lpmake=%~dp0\lpmake.exe"
set "busybox=%~dp0\busybox.exe"

goto main
:Usage
echo  Usage:
echo        %~n0 ^<dir^> ^<(optinal)customsize^>
goto:eof
:main
set fullsize=0
for /f %%i in ('dir /b /s "!dir!\*.img"') do (
	set size=%%~zi

	for /f %%a in ('echo !fullsize!+%%~zi ^| !busybox! bc') do set fullsize=%%a
	set partition=%%~ni
	set "command=--partition !partition!:readonly:!size!:main --image=!partition!=!dir!\!partition!.img"
	set "full=!full! !command!"
	set command=
)
echo �Ƽ���С��С�ڣ�!fullsize!
if not defined customsize set /p customsize=[���棺�����Ƽ��Լ�����super����Ĵ�С�������ֱ�Ӱ�Enter����...]:
if defined customsize set fullsize=!customsize!
::!lpmake! --metadata-size 65536 -super-name super -metadata-slots 2 -device super:!fullsize! --group mian:!fullsize! !full! --out super.img
exit /b 0