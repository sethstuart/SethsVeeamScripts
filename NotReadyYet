$tacos = @()
$tacos = invoke-restmethod -method 'GET' -Uri http://phx0-vccem.securedcloud.local:9399/api/ -contenttype "application/xml"
$burritos = $tacos.EnterpriseManager.Links.Link.href[1]
$fuck = Get-Credential
[System.Convert]::ToBase64String($fuck)
invoke-restmethod -method 'POST' -Uri $burritos
