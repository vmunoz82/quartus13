# We mount in /workspace because there is not a direct way to convert a Windows path to a WSL (wslpath don't work without a distro)

$QUARTUS13_IMAGE = if ($env:QUARTUS13_IMAGE) {$env:QUARTUS13_IMAGE} else {"quartus:13.0.1.2"}
$LICENSE_MAC = if ($env:LICENSE_MAC) {$env:LICENSE_MAC} else {"00:FF:FF:FF:FF:FF"}
$QUARTUS_LICENSE = if ($env:QUARTUS_LICENSE) {$env:QUARTUS_LICENSE} else {"/workspace/license/quartus.dat"}
$MODELSIM_LICENSE = if ($env:MODELSIM_LICENSE) {$env:MODELSIM_LICENSE} else {"/workspace/license/modelsim.dat"}

$local=(Get-Location).Path

$alias="vEthernet (WSL)"
$XSERVER_IP = if ($env:XSERVER_IP) `
  {$env:XSERVER_IP} else `
  {(Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias $alias).IPAddress}

Write-Host "XSERVER_IP: $XSERVER_IP"
Write-Host "QUARTUS13_IMAGE: $QUARTUS13_IMAGE"
Write-Host "LICENSE_MAC: $LICENSE_MAC"
Write-Host "QUARTUS_LICENSE: $QUARTUS_LICENSE"
Write-Host "MODELSIM_LICENSE: $MODELSIM_LICENSE"
Write-Host "WORKSPACE: $local"

$QUARTUS_PATH = "/opt/altera/13.0sp1/quartus/linux64"

& "docker" @("run", "--rm", `
"--mac-address", $LICENSE_MAC, `
"--security-opt", "seccomp=unconfined", `
"-e", ("LM_LICENSE_FILE={0}" -f $QUARTUS_LICENSE), `
"-e", ("MGLS_LICENSE_FILE={0}" -f $MODELSIM_LICENSE), `
"-e", ("DISPLAY={0}:0.0" -f $XSERVER_IP), `
"-e", ("PATH=/bin:/usr/bin:{0}" -f $QUARTUS_PATH), `
"-e", ("LD_LIBRARY_PATH={0}" -f $QUARTUS_PATH), `
"-e", "LD_PRELOAD=inode64.so", `
"-v", ("{0}:/workspace" -f $local), `
"-w", "/workspace", `
"-ti", $QUARTUS13_IMAGE + $args)
