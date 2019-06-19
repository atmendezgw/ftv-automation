@ECHO OFF
cls
REM install-kodi.cmd - Install Kodi, Solid Streamz and Mobdro along with Bauman config for Kodi
REM                via USB or IP
REM
:BEGIN
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
echo Installing Kodi 17.1 Krypton
adb install -r kodi-files\kodi-17.3-Krypton-armeabi-v7a.apk
REM echo Installing Solid Streamz
REM adb install kodi-files\solidstreamz1.0.apk
REM echo Installing Mobdro
REM adb install kodi-files\mobdro.apk
REM echo Installing Mouse Toggle
REM adb install kodi-files\MouseToggle.apk
echo Configuring Kodi
adb push -p FTV17.3BU /sdcard/Android/data/org.xbmc.kodi/files/.kodi
GOTO :END
:NO_INPUT
ECHO You did not enter any IP address.  Please enter somoething like 192.168.1.10
GOTO :END
:END
adb kill-server
echo End of install-kodi.cmd