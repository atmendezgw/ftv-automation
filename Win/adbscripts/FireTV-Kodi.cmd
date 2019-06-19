@ECHO OFF
REM FireTV-Kodi.cmd - install Kodi on new stick and/or restore pre-configured backup
REM 
cls
ECHO Kodi for Fire TV and Fire TV Stick installation
ECHO.
ECHO Before proceeding, please be the Fire TV or Fire TV Stick has been initially set up
ECHO AND that ADB Debugging and Apps from Unknown sources has been turned ON
ECHO AND you have the IP address (192.168.1.something) of the Fire device.
ECHO.
SET /P YNAnswer=Ready to continue (y/n)? 
if /i "%YNAnswer%"=="y" (goto :LETSDOIT)
goto :END
:LETSDOIT
echo Cycling server daemon for fresh start
adb kill-server
echo Starting server daemon
adb start-server
IF "%errorlevel%"=="1" GOTO UNABLE2START
SET /P firetvip=Please enter the IP Address of the fire stick: 
IF "%firetvip%"=="" GOTO NO_INPUT
echo Connecting to Fire TV at %firetvip%
adb connect %firetvip%
SET /P YNAnswer=Did it connect (y/n)? 
if /i "%YNAnswer%"=="y" (goto :CONNECTED)
goto :END
:CONNECTED
ECHO Please be sure you follow these steps

SET /P YNAnswer=Install FRESH/NEW Kodi (y/n)? 
if /i "%YNAnswer%"=="n" (goto :KODI)
:KODI
SET /P YNAnswer=Install TVMC 14.2 Helix (y/n)? 
if /i "%YNAnswer%"=="n" (goto :NOTVMC)
echo Installing TVMC 14.2 Helix
REM adb install -r kodi-files\kodi-17.3-Krypton-armeabi-v7a.apk
adb install -r kodi-files\tvmc-14.2-helix.apk
:NOTVMC
SET /P YNAnswer=Install Kodi 15.2 Isengard (y/n)? 
if /i "%YNAnswer%"=="n" (goto :SPORTS)
echo Installing Kodi 15.2 Isengard
adb install -r kodi-files\kodi-15.1.1-Isengard-armeabi-v7a.apk
:SPORTS
SET /P YNAnswer=Copy SportsDevil zip (y/n)? 
if /i "%YNAnswer%"=="n" (goto :END)
echo Copying Sportsdevil zip file to Fire Tv Stick /sdcard/Download folder
adb push kodi-files\plugin.video.SportsDevil-2015-09-14.zip /sdcard/Download
:LLAMA
SET /P YNAnswer=Install Llama (y/n)? 
if /i "%YNAnswer%"=="n" (goto :END)
echo Installing Llama to Fire Tv Stick
adb install -r llama.apk
echo Installing Sling TV (for you to Llama)
adb install -r kodi-files\com-sling-1.apk
echo copying over thumbnails
adb push kodi-files\thumbnail_ae6fd8cf70f5794569e9e7ff8cb32c81958eb5a4182fb7a734feb7aca1294cc6.png /sdcard/.imagecache/com.amazon.venezia/com.sling/B00ODC5N80/
adb push kodi-files\preview_26ff1f8583e71e5943068ec389c11b81eb6957f6a99af163b8b0d4bc2a661260.png /sdcard/.imagecache/com.amazon.venezia/com.sling/B00ODC5N80/
pause
cls
echo If all went well, launch Llama (From FireTV - Settings > Applications > Llama > Launch Application).
echo Go to EVENTS on top menu and click '+' to add a NEW EVENT.
echo In your NEW EVENT select ADD CONDITION then, from the Menu select 'Active Application' and
echo select 'Choose App’. Scroll through the list of apps until you find “Classic TV” and select this 
echo app. Doing this should return you to the Events Menu.
echo Next, select ADD ACTION and select 'Run Application' from the Menu list. From here, select
echo the Kodi or TVMC app. That should create your event.  Press the back button and you are done.
GOTO :END
:NO_INPUT
ECHO You did not enter any IP address.  Please enter somoething like 192.168.1.10
GOTO :END
:UNABLE2START
ECHO Unable to start services, please try again
:END
echo End of FireTV-Kodi.cmd