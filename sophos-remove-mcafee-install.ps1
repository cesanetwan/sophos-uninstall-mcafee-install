# v1.1
# Developed by Gareth Hill & Joshua Weller for Catholic Education South Australia
# Accepts the path to the McAfee Installer as an argument
# Removes any exists elements of a Sophos Anti-Virus Install, and triggers an installation of the McAfee (or any other) agent

$mcafeeinstallpath = $args[0]
$ErrorActionPreference = 'SilentlyContinue'

if ((Get-Service -DisplayName "Sophos AutoUpdate Service" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Anti-Virus" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Network Threat Protection" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos System Protection Service" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Agent" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Anti-Virus status reporter" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Message Router" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Web Control Service" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Web Intelligence Service" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Web Intelligence Update" -ErrorAction SilentlyContinue)) {
    foreach ($svc in Get-Service -DisplayName Sophos*) {
        Stop-Service -displayname $svc.DisplayName
    }
    $SophosUpdate32 = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos AutoUpdate"}
    $SophosUpdate64 = Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos AutoUpdate"}
    if ($SophosUpdate32 -ne $null) {
        $UninstallGUID = $SophosUpdate32.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }
    if ($SophosUpdate64 -ne $null) {
        $UninstallGUID = $SophosUpdate64.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }

    $SophosRMS32 = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos Remote Management System"}
    $SophosRMS64 = Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos Remote Management System"}
    if ($SophosRMS32 -ne $null) {
        $UninstallGUID = $SophosRMS32.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }
    if ($SophosRMS64 -ne $null) {
        $UninstallGUID = $SophosRMS64.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }

    $SophosAV32 = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos Anti-Virus"}
    $SophosAV64 = Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos Anti-Virus"}
    if ($SophosAV32 -ne $null) {
        $UninstallGUID = $SophosAV32.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }
    if ($SophosAV64 -ne $null) {
        $UninstallGUID = $SophosAV64.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }
    $SophosProt32 = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos System Protection"}
    $SophosProt64 = Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos System Protection"}
    if ($SophosProt32 -ne $null) {
        $UninstallGUID = $SophosProt32.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }
    if ($SophosProt64 -ne $null) {
        $UninstallGUID = $SophosProt64.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }

    $SophosNetProt32 = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos Network Threat Protection"}
    $SophosNetProt64 = Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -eq "Sophos Network Threat Protection"}
    if ($SophosNetProt32 -ne $null) {
        $UninstallGUID = $SophosNetProt32.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }
    if ($SophosNetProt64 -ne $null) {
        $UninstallGUID = $SophosNetProt64.PSChildName
        Start-Process -FilePath msiexec -ArgumentList @("/uninstall $UninstallGUID", "/quiet", "/norestart") -Wait
    }
}
if ((-Not (Get-Service -DisplayName "McAfee Agent Service" -ErrorAction SilentlyContinue))) {
    Start-Process -FilePath $mcafeeinstallpath -ArgumentList @("-f", "-s") -Wait
}
