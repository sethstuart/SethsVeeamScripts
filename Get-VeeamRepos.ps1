Add-PSSnapin VeeamPSSnapin
$Session = Get-VBRServerSession | Select *

if($Session.Port -ne $null){
echo "Cool beans, We have an existing session"
$RepoArray = @()
$Repository = @()
$RepoObject = new-object PSObject | select Name, About, DNSName, Spot
$Repository += Get-VBRServer -type Windows

For($a = 0; $a -lt $Repository.count; $a++){
$ErrorActionPreference = "SilentlyContinue" 
$RepoObject.Name = $Repository[$a].Info.Name
$RepoObject.About = $Repository[$a].Info.TypeDescription
$RepoObject.DNSName = $Repository[$a].Info.DnsName
$RepoObject.Spot = $a
$RepoObject
$RepoArray += $RepoObject   #After hours of tinkering I cannot for the goddamn life of me figure why $RepoArray will not contain the cumulitive data from RepoObject. My current script just displays repoobject and thats it. 
	}
	write-host "#############################"
	$RepoArray
	write-host "#############################"
}

Elseif($Session.Port -eq $null){
$cred = Get-Credential
Connect-VBRServer -Credential $cred
$RepoArray = @()
$Repository = @()
$RepoObject = new-object PSObject | select Name, About, DNSName, Spot
$Repository += Get-VBRServer -type Windows

For($a = 0; $a -lt $Repository.count; $a++){
$ErrorActionPreference = "SilentlyContinue" 
$RepoObject.Name = $Repository[$a].Info.Name
$RepoObject.About = $Repository[$a].Info.TypeDescription
$RepoObject.DNSName = $Repository[$a].Info.DnsName
$RepoObject.Spot = $a
$RepoObject
$RepoArray += $RepoObject   #After hours of tinkering I cannot for the goddamn life of me figure why $RepoArray will not contain the cumulitive data from RepoObject. My current script just displays repoobject and thats it. 
	}
	write-host "#############################"
	$RepoArray
	write-host "#############################"
}


#Disconnect-VBRServer