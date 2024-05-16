$AppId = 'a1e95c17-fda4-475c-9248-84c7113755d1'
$ClientSecret = $env:ClientSecret
$TenantId = '679761e2-ffc2-4942-a4c0-70d1aa60ae1a'


$SecureClientSecret = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AppId, $SecureClientSecret


$splat = @{
    'ServicePrincipal' = $true
    'Credential' = $Credential
    'TenantId' = $TenantId
}
Connect-AzAccount @splat