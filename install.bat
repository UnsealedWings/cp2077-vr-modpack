@echo off
setlocal enabledelayedexpansion
title Cyberpunk 2077 VR Modpack - Installer / Updater

:: ================= CONFIG =================
set "REPO_ZIP=https://github.com/UnsealedWings/cp2077-vr-modpack/archive/refs/heads/main.zip"
set "VERSION_URL=https://raw.githubusercontent.com/UnsealedWings/cp2077-vr-modpack/main/version.txt"
:: ==========================================

set "MARKER=.cp2077_vr_modpack_installed"
set "ZIP=%TEMP%\cp2077-vr-modpack.zip"
set "TMP=%TEMP%\cp2077-vr-modpack"

:: The game folder is wherever this BAT is located.
set "CPDIR=%~dp0"
if "!CPDIR:~-1!"=="\" set "CPDIR=!CPDIR:~0,-1!"

echo.
echo  ==================================================
echo    Cyberpunk 2077 VR Modpack - Installer / Updater
echo  ==================================================
echo.

if not exist "!CPDIR!\bin\x64\Cyberpunk2077.exe" (
  echo   [ERROR] Run this BAT from inside the Cyberpunk 2077
  echo   directory. Place install.bat in your game folder:
  echo     ...\Cyberpunk 2077\
  echo   and double-click it there.
  echo.
  pause
  exit /b 1
)
echo   Game folder: "!CPDIR!"
echo.

:: --- Check for updates ---
echo   Checking for updates...
powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; try { Invoke-WebRequest -Uri '%VERSION_URL%' -OutFile '%TEMP%\cp2077-version.txt' -UseBasicParsing; exit 0 } catch { exit 1 }"
if errorlevel 1 (
  echo   [ERROR] Could not reach the update server.
  goto fail
)

set "LATEST="
set /p "LATEST=" < "%TEMP%\cp2077-version.txt"
set "INSTALLED="
if exist "!CPDIR!\!MARKER!" set /p "INSTALLED=" < "!CPDIR!\!MARKER!"

if "!INSTALLED!"=="!LATEST!" (
  echo.
  echo   You're up to date!
  echo.
  del /q "%TEMP%\cp2077-version.txt" 2>nul
  pause
  exit /b 0
)

:: --- VR choice ---
echo.
echo   Choose what to install:
echo     [1] Full modpack (with Cyberpunk VR)
echo     [2] Everything except VR
echo.
:vrchoice
set /p "CHOICE=  Enter 1 or 2: "
if "!CHOICE!"=="1" ( set "VR=1" ) else if "!CHOICE!"=="2" ( set "VR=0" ) else ( goto vrchoice )

:: --- Download ---
echo.
echo   [1/5] Downloading modpack (this can take a few minutes)...
if exist "!TMP!" rmdir /s /q "!TMP!"
if exist "!ZIP!" del /q "!ZIP!"
curl.exe -L -s --retry 3 -o "!ZIP!" "%REPO_ZIP%"
if errorlevel 1 (
  echo   [ERROR] Download failed. Check your internet connection.
  goto fail
)

:: --- Extract ---
echo   [2/5] Extracting...
if exist "!TMP!" rmdir /s /q "!TMP!"
mkdir "!TMP!"
tar -xf "!ZIP!" -C "!TMP!"
set "EXTRACTED="
for /d %%d in ("!TMP!\*") do set "EXTRACTED=%%d"
if not defined EXTRACTED (
  echo   [ERROR] Could not find the extracted modpack.
  goto fail
)

:: --- Copy ---
echo   [3/5] Installing mod files...
if "!VR!"=="1" (
  robocopy "!EXTRACTED!\files" "!CPDIR!" /E /NFL /NDL /NJH /NJS /NP >nul
  :: VR included -> remove standalone redscript so the VR port's bundled redscript is used
  del /q "!CPDIR!\engine\tools\scc.exe" 2>nul
  del /q "!CPDIR!\engine\tools\scc_lib.dll" 2>nul
  del /q "!CPDIR!\engine\config\base\scripts.ini" 2>nul
  del /q "!CPDIR!\r6\config\cybercmd\scc.toml" 2>nul
) else (
  robocopy "!EXTRACTED!\files" "!CPDIR!" /E /NFL /NDL /NJH /NJS /NP /XD cyberpunkvrport >nul
  :: VR excluded -> install standalone redscript so the other mods can run
  robocopy "!EXTRACTED!\redscript" "!CPDIR!" /E /NFL /NDL /NJH /NJS /NP >nul
)

:: --- Decompress RED4ext address database (required by RED4ext in both modes) ---
echo   [3/5] Extracting RED4ext address database...
powershell -NoProfile -Command "Add-Type -AssemblyName System.IO.Compression; $g='!CPDIR!\bin\x64\cyberpunk2077_addresses.json.gz'; $a='!CPDIR!\bin\x64\cyberpunk2077_addresses.json'; if (Test-Path $g) { $i=[IO.File]::OpenRead($g); $o=[IO.File]::Create($a); $z=New-Object IO.Compression.GZipStream($o,[IO.Compression.CompressionMode]::Decompress); $i.CopyTo($z); $z.Close(); $o.Close(); $i.Close(); Remove-Item $g -Force }"

:: --- Decompress VR archive (only when VR included) ---
if "!VR!"=="1" (
  echo   [4/5] Finalizing VR archive...
  powershell -NoProfile -Command "Add-Type -AssemblyName System.IO.Compression; $g='!CPDIR!\red4ext\plugins\cyberpunkvrport\archive\cyberpunkvrport.archive.gz'; $a='!CPDIR!\red4ext\plugins\cyberpunkvrport\archive\cyberpunkvrport.archive'; if (Test-Path $g) { $i=[IO.File]::OpenRead($g); $o=[IO.File]::Create($a); $z=New-Object IO.Compression.GZipStream($o,[IO.Compression.CompressionMode]::Decompress); $i.CopyTo($z); $z.Close(); $o.Close(); $i.Close(); Remove-Item $g -Force }"
) else (
  echo   [4/5] Skipping VR archive (VR excluded).
)

:: --- Configs (first install only) ---
if exist "!CPDIR!\!MARKER!" (
  echo   [5/5] Update - keeping your existing configs.
) else (
  echo   [5/5] First install - applying default configs...
  robocopy "!EXTRACTED!\configs" "!CPDIR!" /E /NFL /NDL /NJH /NJS /NP >nul
)

:: --- Record installed version ---
> "!CPDIR!\!MARKER!" echo !LATEST!

:: --- cleanup ---
rmdir /s /q "!TMP!" 2>nul
del /q "!ZIP!" 2>nul
del /q "%TEMP%\cp2077-version.txt" 2>nul

echo.
echo  ==================================================
echo    DONE. The modpack is installed and up to date.
echo  ==================================================
echo.
pause
exit /b 0

:fail
echo.
echo  [ERROR] Installation failed. See messages above.
echo.
pause
exit /b 1
