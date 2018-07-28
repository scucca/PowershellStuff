import-module $PSScriptRoot\UD-function.ps1

$PagesFiles = (Get-ChildItem -path $PSScriptRoot\Pages\)

$pages = $PagesFiles | Foreach-Object {& $_.Fullname}

$MyDashboard = New-UDDashboard -Title "Hello, UDBoard" -Pages $Pages

Start-UDDashboard -Port 1000 -Dashboard $MyDashboard -AutoReload