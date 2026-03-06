@echo off
setlocal

echo Select target to flash:
echo 1. Bootloader
echo 2. App Slot A
echo 3. App Slot B
set /p TARGET_CHOICE=Enter choice (1/2/3): 

if "%TARGET_CHOICE%"=="1" (
    set FILE=build/bootloader.bin
    set ADDR=0x08000000
)

if "%TARGET_CHOICE%"=="2" (
    set FILE=build/app_slotA.bin
    set ADDR=0x08008000
)

if "%TARGET_CHOICE%"=="3" (
    set FILE=build/app_slotB.bin
    set ADDR=0x08040000
)

echo ======================================
echo Flashing %FILE% at %ADDR%
echo ======================================

if not exist %FILE% (
    echo ERROR: File not found.
    echo Build the project first.
    exit /b 1
)

openocd -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program %FILE% %ADDR% verify reset exit"

if errorlevel 1 goto error

echo.
echo ======================================
echo FLASH SUCCESSFUL
echo ======================================
goto end

:error
echo.
echo ======================================
echo FLASH FAILED
echo ======================================
exit /b 1

:end
pause