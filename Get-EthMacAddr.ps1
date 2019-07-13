$MAC = "10505601078E"
$ConfMAC = Get-NetAdapter | Where-Object {$_.Name -like "Ethernet*" -and $_.Status -like "Up"} | Select-Object -Property PermanentAddress, Name
if ($ConfMAC[0] -match $MAC) {
	write-host "MAC matches Source VM MAC.... Quitting!"
	exit
	}
elseif ($ConfMAC[0] -notmatch $MAC) {
	write-host "MAC does not match Source VM MAC"
	write-host "Terminating interface "$ConfMAC[0].Name
	Disable-NetAdapter -Name $ConfMAC[0].Name -Confirm:$False
	write-host "Interface disabled.... Quitting!"
	exit
	}