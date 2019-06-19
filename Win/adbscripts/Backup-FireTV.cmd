@ECHO OFF
REM Backup-FireTV.cmd - Backup Kodi configuration for a FireTV Stick or Box to a local directory
REM 
REM To backup a stick: adb pull /sdcard/Android/data/org.xbmc.kodi/files/.kodi/ ./JQuinn
REM To restore: adb push JQuinn /sdcard/Android/data/org.xbmc.kodi/files/.kodi/
cls
ECHO Kodi for Fire TV and Fire TV Stick Backup
ECHO.
ECHO Before proceeding, please be the Fire TV or Fire TV Stick has been initially set up
ECHO AND that ADB Debugging and Apps from Unknown sources has been turned ON
ECHO AND you have the IP address (192.168.1.something) of the Fire device OR BETTER
ECHO the Stick is connected via USB to this computer.
echo.
echo If necessary, press Control-C to abort, plug the stick to your TV
echo and go to Settings - System - Developer Options and turn them on.
echo.
ECHO.
SET /P YNAnswer=Ready to continue (y/n)? 
if /i "%YNAnswer%"=="y" (goto :START_SERVICES)
GOTO :END
:START_SERVICES
echo Kill server daemon
adb kill-server
echo Starting server daemon
adb start-server
:USB_OR_IP
SET /P usb_or_ip=Is the device connected to the USB on the machine? 
IF "%usb_or_ip%"=="y" GOTO USBCONX
SET /P firetvip=Please enter the IP Address of the fire stick: 
IF "%firetvip%"=="" GOTO NO_INPUT
echo Connecting to Fire TV at %firetvip%
adb connect %firetvip%
:USBCONX
adb devices
SET /P YNAnswer=Did it connect (y/n)? 
if /i "%YNAnswer%"=="y" (goto :CONNECTED)
echo Failed to connect.  Please verify the IP and/or Developer options on the Fire TV Stick
goto :END
:CONNECTED
echo Here we gooooooo......
:CONNECTED2
SET BACKUPDIR=.\adblink\%USERNAME%
echo We will backup the configuration on this system and call it .\adblink\%USERNAME%
echo Do you want to specify a different directory name to backup your configuration?
SET /P YNAnswer=Did it connect (y/n)? 
if /i "%YNAnswer%"=="n" (goto :DEFAULT_USERDIR)
:DIR_EXIST_LOOP
SET /P BACKUPDIR=Enter the directory path and name to use (i.e. C:\FIRETVBK, E:\FTBCK, etc.) : 
IF NOT EXIST %BACKUPDIR% (
  ECHO %BACKUPDIR% does not exist.
  SET /P YNAnswer=Create it (y/n)? 
  if /i "%YNAnswer%"=="n" (goto :CONNECTED2)
ECHO Trying to create directory %BACKUPDIR%
  mkdir %BACKUPDIR% 2> nul
  IF %ERRORLEVEL%==0 (
  ECHO Successfully created %BACKUPDIR%
  GOTO :DEFAULT_USERDIR
  ) ELSE ( 
	ECHO Failed to create %BACKUPDIR%
)
IF EXIST %BACKUPDIR% ECHO as it already exists.
SET /P YNAnswer=Continue using %BACKUPDIR% (y/n)? 
if /i "%YNAnswer%"=="n" (goto :DIR_EXIST_LOOP)
REM Fall thru here using the directory.
:DEFAULT_USERDIR
REM IF NOT EXIST C:\WIN\NUL GOTO NOWINDIR
adb pull /sdcard/Android/data/org.xbmc.kodi/files/.kodi/ %BACKUPDIR%
pause
GOTO :END
:NO_INPUT
ECHO You did not enter any IP address.  Please enter somoething like 192.168.1.10
GOTO :END
:END
adb kill-server
echo End of Backup-FireTVi.cmd