#Removes Windows 10 remembered display settings.

Remove-Item -Path HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration -Force
 
Remove-Item -Path HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Connectivity -Force

Remove-Item -Path HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\ScaleFactors -Force