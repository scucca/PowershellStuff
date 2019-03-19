if (Test-Path $PSScriptRoot\UD-function.ps1)
{
    . ($PSScriptRoot + "\UD-function.ps1")
}
elseif (Test-Path .\UD-function.ps1)
{
    . .\UD-function.ps1
    write-host ".\udfunction.ps1"
}
else
{
    Write-Error "UD-Function.ps1 not found"
}


$PagesFiles = (Get-ChildItem -path $PSScriptRoot\Pages\)

$pages = $PagesFiles | Foreach-Object {& $_.Fullname}
if (Get-UDDashboard)
{
    Get-UDDashboard | Stop-UDDashboard
}
$MyDashboard = New-UDDashboard -Title "Hello, UDBoard" -Pages $Pages
Start-UDDashboard -Port 1000 -Dashboard $MyDashboard -AutoReload
<# try
{
    $MyDashboard = New-UDDashboard -Title "Hello, UDBoard" -Pages $Pages
    Start-UDDashboard -Port 1000 -Dashboard $MyDashboard -AutoReload
}
catch
{
    WRite-error "error"
    exit
}


 #>