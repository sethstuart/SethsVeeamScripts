$MAC = "10505601078E" 																		#Place the Source VM's MAC here for the interface you would like to disable
$ConfMAC = Get-NetAdapter | Where-Object {$_.Name -like "Ethernet*" -and $_.Status -like "Up"} | Select-Object -Property PermanentAddress, Name 		#Gets the MAC and interface names of all Ethernet interfaces in an Up state and places them into an array
if ($ConfMAC[0] -match $MAC) { 																	#$ConfMAC[0] references the first interface object in the returned array. To select a different NIC, increment the number in the square brackets. EX: $ConfMAC[1], $ConfMAC[2]
	write-host "MAC matches Source VM MAC.... Quitting!"
	#$ConfMAC																		#Uncomment the $ConfMAC variable here and in the below ElseIf to see the list of returned interfaces. Remember that the array is null indexed so the first interface is 0, the second is 1, and so on.
	exit																			#To have this script disable a different interface change the number in the square brackets [] for all instances of $ConfMAC[0]!
	}
elseif ($ConfMAC[0] -notmatch $MAC) {
	write-host "MAC does not match Source VM MAC"
	#$ConfMAC					
	write-host "Terminating interface "$ConfMAC[0].Name
	Disable-NetAdapter -Name $ConfMAC[0].Name -Confirm:$False
	write-host "Interface disabled.... Quitting!"
	exit
	}
