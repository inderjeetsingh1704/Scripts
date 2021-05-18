
:: Since Registry modification requires admin privileges. Prompt to initiate the admin privileges.
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

::The Below statement directs all the names of the files present in a folder to the filename
dir C:\Windows\Web\Wallpaper\ /b > Wallpaper_File_name.txt
SET file=Wallpaper_File_name.txt

:: Counting the number of linetitems present in that particular file that was just created.
set /a cnt=0
for /f %%a in ('type "%file%"^|find "" /v /c') do set /a cnt=%%a
echo %file% has %cnt% lines

:: Generating a random number to get which row to select from the file
SET /A randomnumber=%RANDOM% %% %cnt%
echo %randomnumber%	

:: Based on the random number generated select the particular file name. 
for /F "skip=%randomnumber%" %%i in (%file%) do set "wallfilename=%%i" &goto nextline
:nextline
echo %wallfilename%

:: Make Edits in the Registry for the change of walpaper name
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" /V Wallpaper /T REG_SZ /D "%systemroot%\web\wallpaper\%wallfilename%" /f

Pause
:: Inorder for the Registry to get refreshed explorer.exe needs to be restarted.
taskkill /f /im explorer.exe
explorer.exe
