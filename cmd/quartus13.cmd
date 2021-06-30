@echo off
REM We mount in /workspace because there is not a direct way to convert a Windows path to a WSL (wslpath don't work without a distro)

if [%XSERVER_IP%] equ [""] set XSERVER_IP=
if [%XSERVER_IP%] equ [] (
for /f "tokens=3 delims=: " %%i  in ('netsh interface ip show config name^="vEthernet (WSL)" ^| findstr /R /C:"^ *IP[v4]* Address"') do set XSERVER_IP=%%i
)

if [%QUARTUS13_IMAGE%] equ [""] set QUARTUS13_IMAGE=
if [%QUARTUS13_IMAGE%] equ [] set QUARTUS13_IMAGE="quartus:13.0.1.2"

if [%LICENSE_MAC%] equ [""] set LICENSE_MAC=
if [%LICENSE_MAC%] equ [] set LICENSE_MAC="00:FF:FF:FF:FF:FF"

if [%QUARTUS_LICENSE%] equ [""] set QUARTUS_LICENSE=
if [%QUARTUS_LICENSE%] equ [] set QUARTUS_LICENSE="/workspace/license/quartus.dat"

if [%MODELSIM_LICENSE%] equ [""] set MODELSIM_LICENSE=
if [%MODELSIM_LICENSE%] equ [] set MODELSIM_LICENSE="/workspace/license/modelsim.dat"

echo XSERVER_IP: %XSERVER_IP%  
echo QUARTUS13_IMAGE: %QUARTUS13_IMAGE%
echo LICENSE_MAC: %LICENSE_MAC%
echo QUARTUS_LICENSE: %QUARTUS_LICENSE%
echo MODELSIM_LICENSE: %MODELSIM_LICENSE%
echo WORKSPACE: %CD%

set DISPLAY=%XSERVER_IP%:0.0

set QUARTUS_PATH="/opt/altera/13.0sp1/quartus/linux64"

docker run --rm ^
--mac-address %LICENSE_MAC% ^
--security-opt seccomp=unconfined ^
-e LM_LICENSE_FILE=%QUARTUS_LICENSE% ^
-e MGLS_LICENSE_FILE=%MODELSIM_LICENSE% ^
-e DISPLAY=%DISPLAY% ^
-e PATH=/bin:/usr/bin:%QUARTUS_PATH% ^
-e LD_LIBRARY_PATH=%QUARTUS_PATH% ^
-e LD_PRELOAD=inode64.so ^
-v "%CD%:/workspace" ^
-w /workspace ^
-ti %QUARTUS13_IMAGE% %*
