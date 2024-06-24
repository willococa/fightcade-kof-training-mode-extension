@echo off
pause

rem Set the source directory
echo Setting source directory...
set "sourceDir=%cd%"
echo Source directory set to: %sourceDir%

rem Set the destination directory for addon files relative to fbneo-training-mode
echo Setting destination directory...
set "destinationDir=..\fbneo-training-mode\addon"
echo Destination directory set to: %destinationDir%

rem Check if the destination directory exists
echo Checking if the destination directory exists...
if not exist "%destinationDir%" (
    echo Error: The addon directory does not exist. Uninstallation aborted.
    pause
    exit /b 1
)
echo Destination directory exists.

rem Remove kof_training.lua and kof_training_guipages.lua from addon directory
echo Removing kof_training.lua from %destinationDir%...
del /q "%destinationDir%\kof_training.lua"
echo Removed kof_training.lua from %destinationDir%

echo Removing kof_training_guipages.lua from %destinationDir%...
del /q "%destinationDir%\kof_training_guipages.lua"
echo Removed kof_training_guipages.lua from %destinationDir%

rem Set the game folder paths for the games
set "gameDirKof96=..\fbneo-training-mode\games\kof96"
set "gameDirKof97=..\fbneo-training-mode\games\kof97"
set "gameDirKof98=..\fbneo-training-mode\games\kof98"
set "gameDirKof99=..\fbneo-training-mode\games\kof99"
set "gameDirKof2000=..\fbneo-training-mode\games\kof2000"
set "gameDirKof2001=..\fbneo-training-mode\games\kof2001"
set "gameDirKof2002=..\fbneo-training-mode\games\kof2002"

rem Remove  the Lua files in the game folders
echo Removing files from %gameDirKof96%...
del /q "%gameDirKof96%\guipages.lua"
del /q "%gameDirKof96%\moves_settings.lua"
echo Removed files from %gameDirKof96%...

rem Remove the added lines from the Lua files in the game folders
echo Removing addon.kof_training require lines from Lua files...

rem Remove the lines from kof96.lua
echo Removing addon.kof_training require line from kof96.lua...
findstr /v /c:"addon.kof_training" "%gameDirKof96%\kof96.lua" > "%gameDirKof96%\temp.lua"
move /y "%gameDirKof96%\temp.lua" "%gameDirKof96%\kof96.lua"
echo Removed addon.kof_training require line from kof96.lua

rem Remove  the Lua files in the game folders
echo Removing files from %gameDirKof97%...
del /q "%gameDirKof97%\guipages.lua"
del /q "%gameDirKof97%\moves_settings.lua"
echo Removed files from %gameDirKof97%...

rem Remove the lines from kof97.lua
echo Removing addon.kof_training require line from kof97.lua...
findstr /v /c:"addon.kof_training" "%gameDirKof97%\kof97.lua" > "%gameDirKof97%\temp.lua"
move /y "%gameDirKof97%\temp.lua" "%gameDirKof97%\kof97.lua"
echo Removed addon.kof_training require line from kof97.lua

rem Remove  the Lua files in the game folders
echo Removing files from %gameDirKof98%...
del /q "%gameDirKof98%\guipages.lua"
del /q "%gameDirKof98%\moves_settings.lua"
echo Removed files from %gameDirKof98%...

rem Remove the lines from kof98.lua
echo Removing addon.kof_training require line from kof98.lua...
findstr /v /c:"addon.kof_training" "%gameDirKof98%\kof98.lua" > "%gameDirKof98%\temp.lua"
move /y "%gameDirKof98%\temp.lua" "%gameDirKof98%\kof98.lua"
echo Removed addon.kof_training require line from kof98.lua

rem Remove  the Lua files in the game folders
echo Removing files from %gameDirKof99%...
del /q "%gameDirKof99%\guipages.lua"
del /q "%gameDirKof99%\moves_settings.lua"
echo Removed files from %gameDirKof99%...

rem Remove the lines from kof99.lua
echo Removing addon.kof_training require line from kof99.lua...
findstr /v /c:"addon.kof_training" "%gameDirKof99%\kof99.lua" > "%gameDirKof99%\temp.lua"
move /y "%gameDirKof99%\temp.lua" "%gameDirKof99%\kof99.lua"
echo Removed addon.kof_training require line from kof99.lua

rem Remove  the Lua files in the game folders
echo Removing files from %gameDirKof2000%...
del /q "%gameDirKof2000%\guipages.lua"
del /q "%gameDirKof2000%\moves_settings.lua"
echo Removed files from %gameDirKof2000%...

rem Remove the lines from kof2000.lua
echo Removing addon.kof_training require line from kof2000.lua...
findstr /v /c:"addon.kof_training" "%gameDirKof2000%\kof2000.lua" > "%gameDirKof2000%\temp.lua"
move /y "%gameDirKof2000%\temp.lua" "%gameDirKof2000%\kof2000.lua"
echo Removed addon.kof_training require line from kof2000.lua

rem Remove  the Lua files in the game folders
echo Removing files from %gameDirKof2001%...
del /q "%gameDirKof2001%\guipages.lua"
del /q "%gameDirKof2001%\moves_settings.lua"
echo Removed files from %gameDirKof2001%...

rem Remove the lines from kof2001.lua
echo Removing addon.kof_training require line from kof2001.lua...
findstr /v /c:"addon.kof_training" "%gameDirKof2001%\kof2001.lua" > "%gameDirKof2001%\temp.lua"
move /y "%gameDirKof2001%\temp.lua" "%gameDirKof2001%\kof2001.lua"
echo Removed addon.kof_training require line from kof2001.lua

rem Remove  the Lua files in the game folders
echo Removing files from %gameDirKof2002%...
del /q "%gameDirKof2002%\guipages.lua"
del /q "%gameDirKof2002%\moves_settings.lua"
echo Removed files from %gameDirKof2002%...

rem Remove the lines from kof2002.lua
echo Removing addon.kof_training require line from kof2002.lua...
findstr /v /c:"addon.kof_training" "%gameDirKof2002%\kof2002.lua" > "%gameDirKof2002%\temp.lua"
move /y "%gameDirKof2002%\temp.lua" "%gameDirKof2002%\kof2002.lua"
echo Removed addon.kof_training require line from kof2002.lua

echo Uninstallation completed successfully.
pause