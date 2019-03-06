$AllTheThings = @()
$SystemDrives[0] | foreach{

$NewDrive = new-object PSObject -Property @{
Num = $_.ID;
Descr = $_.Description;
Proto = $Protocol;
SrcIP = $_.SourceIP;
SrcPort = $_.SourcePort;
DstIP = $_.DestinationIP;
DstPortRange = $_.DestinationPortRange;
Policy = $_.Policy;
Direction = "";
isEnabled = $_.IsEnabled;
EnableLogging = $_.EnableLogging;
MatchOnTranslate = $_.MatchOnTranslate;
 
}
$AllTheThings += $NewDrive
}
}
 
$AllTheThings | Export-CSV -Path $csvFile -NoType


$AllTheThings = @()
$SystemDrives[0] | foreach{

$NewDrive = new-object PSObject | select Num, Descr, Proto, SrcIp, SrcPort, DstIP, DstPortRange, Policy

$NewDrive.Num = $Something
 
}
$AllTheThings += $NewDrive
}
}
 
$AllTheThings | Export-CSV -Path $csvFile -NoType


