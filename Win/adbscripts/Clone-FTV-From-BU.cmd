@ECHO OFF
cls
REM Clone-FTV-From-BU.cmd - Conditionally re-install Kodi, then restore from backup directory
REM                via USB or IP
REM
:BEGIN
echo This will conditionally re-install Kodi to your device then ask for the
echo directory path name to use from previous backup to mirror the Kodi config
echo.
echo * * * I M P O R T A N T * * *
echo Be sure you validate that you have turned ON the following:
echo.
echo    Apps from Unknown Sources
echo    ADB Debugging
echo.
echo If necessary, press Control-C to abort, plug the stick to your TV
echo and go to Settings - System - Developer Options and turn them on.
echo.
SET /P YNAnswer=Ready to continue (y/n)? 
if /i "%YNAnswer%"=="y" (goto :START_SERVICES)
GOTO :END
:START_SERVICES
echo Kill server daemon
adb kill-server
echo Starting server daemon
adb start-server
:USB_OR_IP
SET /P usb_or_ip=Is the device connected to the USB on the machine (y/n) ? 
IF "%usb_or_ip%"=="y" GOTO USBCONX
SET /P firetvip=Please enter the IP Address of the fire stick: 
IF "%firetvip%"=="" GOTO NO_INPUT
echo Connecting to Fire TV at %firetvip%
adb connect %firetvip%
:USBCONX
adb devices
SET /P YNAnswer=Did it connect (y/n)? 
if /i "%YNAnswer%"=="y" (goto :CONNECTED) ELSE (
echo Failed to connect.  Please verify the IP and/or Developer options on the Fire TV Stick
goto :END
)
:CONNECTED
echo Here we gooooooo......
:REINSTALL_KODI
SET /P YNAnswer=Install/Update Kodi to 17.6 Krypton (y/n)? 
if /i "%YNAnswer%"=="n" (goto :INSTALL_FFHQ) ELSE (
echo Installing Kodi 17.6 Krypton
adb install -r .\kodi-files\kodi-17.6-Krypton-armeabi-v7a.apk
)
:INSTALL_FFHQ
SET /P YNAnswer=Install FreeFlixHQ 2.5 (y/n)? 
if /i "%YNAnswer%"=="n" (goto :INSTALL_SILK) ELSE (
echo Installing FreeFlixHQ
adb install -r .\kodi-files\ffhq_v2.2.5.apk
)
:INSTALL_SILK
echo If you have a Silk Browser on your stick and it is working, do NOT reinstall this....
SET /P YNAnswer=Install Silk Browser (y/n)? 
if /i "%YNAnswer%"=="n" (goto :PROMPT_FOR_DIR) ELSE (
echo Installing Silk Browser
adb install -r .\kodi-files\silk-base.apk
)
:PROMPT_FOR_DIR
SET BACKUPDIR=%cd%\%USERNAME%
ECHO %BACKUPDIR%
IF EXIST %BACKUPDIR% (
	SET /P YNAnswer="Do you want to clone from "%BACKUPDIR%" (y/n) ? "
	if /i "%YNAnswer%"=="y" (goto :RESTORE)
	)
:DIR_EXIST_LOOP
SET /P BACKUPDIR=Enter the directory path to clone from (i.e. C:\FIRETVBK, E:\FTBCK, etc.) : 
IF NOT EXIST %BACKUPDIR% (
  ECHO %BACKUPDIR% does not exist.
  GOTO :DIR_EXIST_LOOP 
  )
:RESTORE
adb push -p %BACKUPDIR% /sdcard/Android/data/org.xbmc.kodi/files/.kodi
GOTO :END
:NO_INPUT
ECHO You did not enter any IP address.  Please enter somoething like 192.168.1.10
GOTO :END
:END
adb kill-server
pause
echo End of Clone-FTV-From-BU.cmd