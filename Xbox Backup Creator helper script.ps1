#Possible todo: Add Redump settings check function, error count, and retry to Redump, add current settings check to main menu.

#Define variables

$StopXBC = [ScriptBlock]::Create('Stop-Process -Name "Xbox Backup Creator" -ea silentlycontinue')
$ClearErrorCount = 0

#Define functions

Function Welcome
    {
        Clear-Variable -Name "Action" -ErrorAction SilentlyContinue
        Write-Host "Welcome to the Xbox Backup Creator helper script.

        I can:

        1) Set XBC to Redump settings
        2) Clear all saved XBC settings
        9) Exit

        "

        $Global:Action = Read-Host -Prompt "Please enter your selection (Number 1-9)"
    }

Function Redump
    {
        Write-Host "`nSetting XBC to Redump settings.`n"
        If (Test-Path -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator')
            {
                Invoke-Command -Scriptblock $StopXBC
                #Default registry entries
                Set-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'BurnEngine' -Value '1'
                Set-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'LogLevel' -Value '2'
                Set-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'LogToFile' -Value '1'
                Set-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'PreformOPC' -Value '1'
                Set-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'PreformTrackReserve' -Value '1'
                Set-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'RemoveTagWriter' -Value '1'
                Set-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'SectorMapper' -Value '0'
                Set-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'ShowLog' -Value '1'
                #Named ISO Check in GUI
                Set-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'StealthCheck' -Value '1'
                
                #Entries only generated after settings modified
                New-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'ProcessAP25' -PropertyType String -Value '0' -force
                New-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'AddVideoFiller' -PropertyType String -Value '0' -force
                New-ItemProperty -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator\AppSettings' -Name 'BuildCleanISO' -PropertyType String -Value '1' -force

                Write-Host "`nI have set XBC to Redump settings.`n"
                Start-Sleep -Seconds 2

                Write-Host "`nI am currently not able to validate Redump settings, so please confirm they are correct before you start dumping.`n"
                Start-Sleep -Seconds 4
                
                Welcome
            }
        
        Else
            {
                Write-Host "`nIt looks like you haven't launched XBC for the first time or since you last cleared the settings.
                            `nPlease launch XBC once and try again.`n"
                Start-Sleep -Seconds 1
                Welcome
            }
    }

Function ClearSettings
    {
        If (Test-Path -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator')
            {
                Invoke-Command -Scriptblock $StopXBC
                
                Remove-Item -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator' -Force -Recurse
                
                
                If ($ClearErrorCount -ge 1)
                    {
                        Write-Host "`nI was not able to clear your XBC settings.`n"
                        $ClearErrorcount = 0
                        Start-Sleep -Seconds 1
                        Welcome
                    }
                
                ElseIf (Test-Path -Path 'HKCU:\SOFTWARE\VB and VBA Program Settings\Xbox Backup Creator')
                    {
                        Write-Host '`nSettings were not cleared. Retrying...`n'
                        $ClearErrorCount++
                        Start-Sleep -Seconds 1
                        ClearSettings
                    }             
                
                Else 
                    {
                        Write-Host '`nI have cleared your XBC settings`n'
                        Start-Sleep -Seconds 1
                        Welcome
                    }
            }

        Else
            {
                Write-Host "`nI didn't find any XBC settings, so nothing was deleted.`n"
                Welcome
            }
    }

#Begin main script

Welcome

If ($Action -eq '1')
    {
        Redump
    }

Elseif ($Action -eq '2')
    {
        ClearSettings
    }

Elseif ($Action -eq '9')
    {
        Write-Host "Goodbye"
        Start-Sleep -Seconds 1
        Exit
    }

Else 
    {
        Write-host "Oops, I didn't recognize that. Please try again."
        Welcome
    }