#Prompt user to enter URL to download
$URL = Read-Host "Enter the CDN URL of the game you would like to download"

#Gets the ContentID from the URL and converts string to upper case. Stores value as $NameUpper
$NameUpper = ($URL -split "/")[5].toupper()

#Downloads the file based on user entered URL, outputs file to the location of script, and names files as the uppercase ContentID for console use.
$Priority = "Normal"
Start-BitsTransfer -Source $URL -Destination $NameUpper -Priority $Priority

Read-Host "Your file has been downloaded and is availble in $PSScriptRoot\$NameUpper

Press enter to close this window"
exit