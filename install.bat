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
    echo Error: The addon directory does not exist. Installation aborted.
    pause
    exit /b 1
)
echo Destination directory exists.

rem Copy kof_training.lua and kof_training_guipages.lua to addon directory
echo Copying kof_training.lua to %destinationDir%...
copy "%sourceDir%\kof_training.lua" "%destinationDir%" /Y > nul
echo Copied kof_training.lua to %destinationDir%

echo Copying kof_training_guipages.lua to %destinationDir%...
copy "%sourceDir%\kof_training_guipages.lua" "%destinationDir%" /Y > nul
echo Copied kof_training_guipages.lua to %destinationDir%


rem Set the game folder paths for the other games
set "gameDirKof96=..\fbneo-training-mode\games\kof96"
set "gameDirKof97=..\fbneo-training-mode\games\kof97"
set "gameDirKof98=..\fbneo-training-mode\games\kof98"
set "gameDirKof99=..\fbneo-training-mode\games\kof99"
set "gameDirKof2000=..\fbneo-training-mode\games\kof2000"
set "gameDirKof2001=..\fbneo-training-mode\games\kof2001"
set "gameDirKof2002=..\fbneo-training-mode\games\kof2002"

rem Check if the game folders exist for the other games
echo Checking if the game folders exist...
if not exist "%gameDirKof96%" (
    echo Error: The game folder %gameDirKof96% does not exist. Files not copied.
    pause
    exit /b 1
) else (
    echo Game folder %gameDirKof96% exists.
)

if not exist "%gameDirKof97%" (
    echo Error: The game folder %gameDirKof97% does not exist. Files not copied.
    pause
    exit /b 1
) else (
    echo Game folder %gameDirKof97% exists.
)

if not exist "%gameDirKof98%" (
    echo Error: The game folder %gameDirKof98% does not exist. Files not copied.
    pause
    exit /b 1
) else (
    echo Game folder %gameDirKof98% exists.
)

if not exist "%gameDirKof99%" (
    echo Error: The game folder %gameDirKof99% does not exist. Files not copied.
    pause
    exit /b 1
) else (
    echo Game folder %gameDirKof99% exists.
)

if not exist "%gameDirKof2000%" (
    echo Error: The game folder %gameDirKof2000% does not exist. Files not copied.
    pause
    exit /b 1
) else (
    echo Game folder %gameDirKof2000% exists.
)

if not exist "%gameDirKof2001%" (
    echo Error: The game folder %gameDirKof2001% does not exist. Files not copied.
    pause
    exit /b 1
) else (
    echo Game folder %gameDirKof2001% exists.
)

if not exist "%gameDirKof2002%" (
    echo Error: The game folder %gameDirKof2002% does not exist. Files not copied.
    pause
    exit /b 1
) else (
    echo Game folder %gameDirKof2002% exists.
)

rem Copy guipages.lua and moves_settings.lua to other game folders
echo Copying guipages.lua and moves_settings.lua to other game folders...

copy "%sourceDir%\guipages.lua" "%gameDirKof96%" /Y > nul
echo Copied guipages.lua to %gameDirKof96%
copy "%sourceDir%\moves_settings.lua" "%gameDirKof96%" /Y > nul
echo Copied moves_settings.lua to %gameDirKof96%
echo Adding require('addon.kof_training') to kof96.lua...
echo require('addon.kof_training')>>"%gameDirKof96%\kof96.lua"
echo Added require('addon.kof_training') to kof96.lua

copy "%sourceDir%\guipages.lua" "%gameDirKof97%" /Y > nul
echo Copied guipages.lua to %gameDirKof97%
copy "%sourceDir%\moves_settings.lua" "%gameDirKof97%" /Y > nul
echo Copied moves_settings.lua to %gameDirKof97%
echo Adding require('addon.kof_training') to kof97.lua...
echo require('addon.kof_training')>>"%gameDirKof97%\kof97.lua"
echo Added require('addon.kof_training') to kof97.lua

copy "%sourceDir%\guipages.lua" "%gameDirKof98%" /Y > nul
echo Copied guipages.lua to %gameDirKof98%
copy "%sourceDir%\moves_settings.lua" "%gameDirKof98%" /Y > nul
echo Copied moves_settings.lua to %gameDirKof98%
echo Adding require('addon.kof_training') to kof98.lua...
echo require('addon.kof_training')>>"%gameDirKof98%\kof98.lua"
echo Added require('addon.kof_training') to kof98.lua

copy "%sourceDir%\guipages.lua" "%gameDirKof99%" /Y > nul
echo Copied guipages.lua to %gameDirKof99%
copy "%sourceDir%\moves_settings.lua" "%gameDirKof99%" /Y > nul
echo Copied moves_settings.lua to %gameDirKof99%
echo Adding require('addon.kof_training') to kof99.lua...
echo require('addon.kof_training')>>"%gameDirKof99%\kof99.lua"
echo Added require('addon.kof_training') to kof99.lua

copy "%sourceDir%\guipages.lua" "%gameDirKof2000%" /Y > nul
echo Copied guipages.lua to %gameDirKof2000%
copy "%sourceDir%\moves_settings.lua" "%gameDirKof2000%" /Y > nul
echo Copied moves_settings.lua to %gameDirKof2000%
echo Adding require('addon.kof_training') to kof2000.lua...
echo require('addon.kof_training')>>"%gameDirKof2000%\kof2000.lua"
echo Added require('addon.kof_training') to kof2000.lua

copy "%sourceDir%\guipages.lua" "%gameDirKof2001%" /Y > nul
echo Copied guipages.lua to %gameDirKof2001%
copy "%sourceDir%\moves_settings.lua" "%gameDirKof2001%" /Y > nul
echo Copied moves_settings.lua to %gameDirKof2001%
echo Adding require('addon.kof_training') to kof2001.lua...
echo require('addon.kof_training')>>"%gameDirKof2001%\kof2001.lua"
echo Added require('addon.kof_training') to kof2001.lua

copy "%sourceDir%\guipages.lua" "%gameDirKof2002%" /Y > nul
echo Copied guipages.lua to %gameDirKof2002%
copy "%sourceDir%\moves_settings.lua" "%gameDirKof2002%" /Y > nul
echo Copied moves_settings.lua to %gameDirKof2002%
echo Adding require('addon.kof_training') to kof2002.lua...
echo require('addon.kof_training')>>"%gameDirKof2002%\kof2002.lua"
echo Added require('addon.kof_training') to kof2002.lua

echo Installation completed successfully.
pause


echo Installation completed successfully.
pause
