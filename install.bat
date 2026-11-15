@echo off
setlocal enabledelayedexpansion
title Cyberpunk 2077 VR Modpack - Installer / Updater

:: ================= CONFIG =================
:: Point this at wherever you host the modpack repo.
set "REPO_URL=https://github.com/YOUR_USERNAME/cp2077-vr-modpack/archive/refs/heads/main.zip"
:: ==========================================

set "MARKER=.cp2077_vr_modpack_installed"
set "ZIP=%TEMP%\cp2077-vr-modpack.zip"
set "TMP=%TEMP%\cp2077-vr-modpack"

echo.
echo  ==================================================
echo    Cyberpunk 2077 VR Modpack - Installer / Updater
echo  ==================================================
echo.

:: --- 1. Cyberpunk folder (drag-and-drop or typed) ---
if "%~1" neq "" set "CPDIR=%~1"
if defined CPDIR goto validatedir

:askdir
set "CPDIR="
set /p "CPDIR=Enter your Cyberpunk 2077 folder path: "
if not defined CPDIR goto askdir

:validatedir
if "!CPDIR:~-1!"=="\" set "CPDIR=!CPDIR:~0,-1!"
if not exist "!CPDIR!\bin\x64\Cyberpunk2077.exe" (
  echo.
  echo   [ERROR] bin\x64\Cyberpunk2077.exe not found in:
  echo     "!CPDIR!"
  echo   Please enter the correct full folder path.
  echo.
  goto askdir
)
echo.
echo   Target: "!CPDIR!"
echo.

:: --- 2. Download latest ---
echo   [1/5] Downloading latest modpack...
if exist "!TMP!" rmdir /s /q "!TMP!"
if exist "!ZIP!" del /q "!ZIP!"
powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; try { Invoke-WebRequest -Uri '%REPO_URL%' -OutFile '!ZIP!' -UseBasicParsing; exit 0 } catch { exit 1 }"
if errorlevel 1 (
  echo   [ERROR] Download failed. Check your internet connection.
  goto fail
)

:: --- 3. Extract ---
echo   [2/5] Extracting...
powershell -NoProfile -Command "Expand-Archive -LiteralPath '!ZIP!' -DestinationPath '!TMP!' -Force"
set "EXTRACTED="
for /d %%d in ("!TMP!\*") do set "EXTRACTED=%%d"
if not defined EXTRACTED (
  echo   [ERROR] Could not find the extracted modpack folder.
  goto fail
)

:: --- 4. Copy mod files ---
echo   [3/5] Installing mod files...
robocopy "!EXTRACTED!\files" "!CPDIR!" /E /NFL /NDL /NJH /NJS /NP >nul

:: --- 5. Decompress VR archive ---
echo   [4/5] Finalizing VR archive...
powershell -NoProfile -Command "Add-Type -AssemblyName System.IO.Compression; $g='!CPDIR!\red4ext\plugins\cyberpunkvrport\archive\cyberpunkvrport.archive.gz'; $a='!CPDIR!\red4ext\plugins\cyberpunkvrport\archive\cyberpunkvrport.archive'; if (Test-Path $g) { $i=[IO.File]::OpenRead($g); $o=[IO.File]::Create($a); $z=New-Object IO.Compression.GZipStream($o,[IO.Compression.CompressionMode]::Decompress); $i.CopyTo($z); $z.Close(); $o.Close(); $i.Close(); Remove-Item $g -Force }"

:: --- 6. Configs (first install only) ---
if exist "!CPDIR!\!MARKER!" (
  echo   [5/5] Update detected - keeping your existing configs.
) else (
  echo   [5/5] First install - applying default configs...
  robocopy "!EXTRACTED!\configs" "!CPDIR!" /E /NFL /NDL /NJH /NJS /NP >nul
  echo installed> "!CPDIR!\!MARKER!"
)

:: --- cleanup ---
rmdir /s /q "!TMP!" 2>nul
del /q "!ZIP!" 2>nul

echo.
echo  ==================================================
echo    DONE. The modpack is installed and up to date.
echo  ==================================================
echo.
pause
exit /b 0

:fail
echo.
echo  [ERROR] Installation failed. See the messages above.
echo.
pause
exit /b 1
