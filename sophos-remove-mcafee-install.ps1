# v1.2
# Developed by Gareth Hill & Joshua Weller for Catholic Education South Australia
# Accepts the path to the McAfee Installer as an argument
# Removes any exists elements of a Sophos Anti-Virus Install, and triggers an installation of the McAfee (or any other) agent

$mcafeeinstallpath = $args[0]
$ErrorActionPreference = 'SilentlyContinue'

if ((Get-Service -DisplayName "Sophos AutoUpdate Service" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Anti-Virus" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Network Threat Protection" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos System Protection Service" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Agent" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Anti-Virus status reporter" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Message Router" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Web Control Service" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Web Intelligence Service" -ErrorAction SilentlyContinue) -Or (Get-Service -DisplayName "Sophos Web Intelligence Update" -ErrorAction SilentlyContinue)) {
    foreach ($svc in Get-Service -DisplayName Sophos*) {
        Stop-Service -displayname $svc.DisplayName
    }
    if (Test-Path 'C:\ProgramData\Sophos\Sophos Anti-Virus\Config\machine.xml') {
       [xml]$sophosConfig = Get-Content 'C:\ProgramData\Sophos\Sophos Anti-Virus\Config\machine.xml'
       if (($sophosConfig.configuration.components.TamperProtectionManagement.settings.enabled) -And ($sophosConfig.configuration.components.TamperProtectionManagement.settings.enabled -eq "true")) {
          $sophosConfig.configuration.components.TamperProtectionManagement.settings.enabled = 'false'
          $sophosConfig.Save('C:\ProgramData\Sophos\Sophos Anti-Virus\Config\machine.xml')
          Start-Service -displayname "Sophos Anti-Virus" -Wait
          Stop-Service -displayname "Sophos Anti-Virus"
       }
    }
    Stop-Process -processname ALMon -force
    Stop-Process -processname ManagementAgentNT -force
    Stop-Process -processname SavService -force
    Stop-Process -processname SAVAdminService -force
    Stop-Process -processname Alsvc -force
    Stop-Process -processname CertificationManagerServiceNT -force
    Stop-Process -processname Sophos.FrontEnd.Service -force
    Stop-Process -processname MgntSvc -force
    Stop-Process -processname RouterNT -force
    Stop-Process -processname PatchEndpointCommunicator -force
    Stop-Process -processname PatchEndpointOrchestrator -force
    Stop-Process -processname PatchServerCommunicator -force
    Stop-Process -processname ssp -force
    Stop-Process -processname SUMService -force
    Stop-Process -processname swc_service -force
    Stop-Process -processname swi_filter -force
    Stop-Process -processname swi_service -force
    Stop-Process -processname SntpService -force
    Stop-Process -processname EnterpriseConsole -force
    Stop-Process -processname Sophos.Messenger -force
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
    $remaininginstalls = 0
    foreach ($sophos32product in (Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -like "Sophos*"})) {
        if ($sophos32product -ne $null) {
            $remaininginstalls = $remaininginstalls + 1        
        }
    }
    foreach ($sophos64product in (Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -like "Sophos*"})) {
        if ($sophos64product -ne $null) {
            $remaininginstalls = $remaininginstalls + 1
        }
    }
    if ($remaininginstalls -le 4) {
        foreach ($svc in Get-Service -DisplayName Sophos*) {
            sc.exe delete $svc.Name
        }
    }
}
if ((-Not (Get-Service -DisplayName "McAfee Agent Service" -ErrorAction SilentlyContinue))) {
    Start-Process -FilePath $mcafeeinstallpath -ArgumentList @("-f", "-s") -Wait
}
