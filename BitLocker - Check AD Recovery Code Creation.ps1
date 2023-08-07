$objComputer = Get-ADComputer -Filter * -Properties lastLogon,OperatingSystem # | Where-Object {$_.OperatingSystem -clike "Windows 10*"}
$output = @('Workstation Name,Last Logon (Data/Time),Operating System,Recovery Code 1,Recovery Code 2,Recovery Code 3,Recovery Code 4')
ForEach ($computer in $objComputer){
    $recoveryInfo = Get-ADObject -Filter 'objectClass -eq "msFVE-RecoveryInformation"' -SearchBase $computer.DistinguishedName -Properties whenCreated,msFVE-RecoveryPassword | Select @{N='LastLogon'; E={[DateTime]::FromFileTime($_.LastLogon)}},OperatingSystem,whenCreated,msFVE-RecoveryPassword
    If ($recoveryInfo.whenCreated){$rIwC = ($recoveryInfo.whenCreated) -join "," }else{$rIwC = "None"}
    $output += $computer.Name + "," + [DateTime]::FromFileTime($computer.LastLogon) + "," + $computer.OperatingSystem + "," + $rIwC
}
$output > ((Get-Variable HOME -valueOnly) + "\Desktop\" + $env:USERDOMAIN + "_BitLocker.csv")