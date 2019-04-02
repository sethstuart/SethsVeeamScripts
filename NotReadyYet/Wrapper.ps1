#$Domain = ""
$User = ""
$Password = ""
$VEM = ""

$VEM = read-host -Prompt "Please enter the IP or Domain name of the VEM you wish to connect to. (Do not add https:// or a port number please)"
$User = $Domain += read-host -Prompt "Please enter your SecuredCloud Username"
$Password = read-host -Prompt "Enter your SecuredCloud Password" -AsSecureString

#Thanks to Morgan from https://www.morgantechspace.com/2014/12/Powershell-Convert-SecureString-to-PlainText.html
$PwdPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
$PlainTextPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto($PwdPointer)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($PwdPointer)

$Uri = "http://" + $VEM + ":9399/api/sessionMngr/?v=latest"
$Pair = "$($User):$($PlainTextPassword)"
$Bytes = [System.Text.Encoding]::ASCII.GetBytes($Pair)
$Cred = 'Basic ' + [System.Convert]::ToBase64String($Bytes)

$header = @{ Authorization = $Cred; Accept = 'application/xml'}

write-host "Attempting to log into $Uri as $User."
$AuthXML = invoke-restmethod -Method Post -Headers $header -Uri $Uri

if($AuthXML -ne $null){
write-host "Logged into $VEM successfully"
}
else{
write-host "you suck"
}
