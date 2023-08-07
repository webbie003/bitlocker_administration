#$bldrives = Get-PSDrive -PSProvider FileSystem | Where-Object {$_.Used -ne ""} 
$bldrives = Get-BitLockerVolume
$noEncrypt = Get-PSDrive -PSProvider FileSystem | Where-Object {($_.Used -ne "") } 
If ((Test-Path -Path ("C:\temp\"+($env:computername)+".txt")) -eq $false) {
    Foreach ($drive in $bldrives) {
        # Write-Host $drive.MountPoint
        Manage-Bde -protectors -get $drive.MountPoint | Out-File -Append ("C:\temp\"+($env:computername)+".txt")
    }
}
