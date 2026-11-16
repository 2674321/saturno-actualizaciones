@echo off
setlocal
cd /d "%~dp0"
echo.
echo Saturno - Actualizacion asistida a 1.6.0
echo.
where powershell.exe >nul 2>&1
if errorlevel 1 (
  echo ERROR: No se encuentra Windows PowerShell.
  pause
  exit /b 1
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Actualizar_Saturno.ps1"
set "resultado=%ERRORLEVEL%"
echo.
if "%resultado%"=="0" (
  echo Actualizacion instalada y version verificada.
) else (
  echo La actualizacion no se completo. Codigo: %resultado%.
  echo No borre la carpeta de datos ni desinstale el programa.
)
echo.
pause
exit /b %resultado%
