

[Collections.ArrayList]$Creds = @()

function AddKey {
    $key = Get-Credential -Message "Enter new user/pass combo"
    $user = $key.GetNetworkCredential().UserName
    $pass = $key.GetNetworkCredential().Password
    #$global:Creds += @{$($global:creds.count+1),$user,$pass}
    $global:Creds += [PSCustomObject]@{
        Number = $global:Creds.Count+1
        User = $user
        Pass = $pass
    }
}

function EditKey {
    $key = Get-Credential -Message "Enter new user/pass combo"
    $user = $key.GetNetworkCredential().UserName | ConvertFrom-SecureString
    $pass = $key.GetNetworkCredential().Password | ConvertFrom-SecureString
}
    

function Show-MainMenu
{
    param (
    [string]$Title = 'Password Keeper - Main Menu'
    )
    
    Write-Host "================ $Title ================"
    $i = 0
    if ($global:Creds.count -ge 2) {
        foreach ($Cred in $global:Creds) {
            Write-Host "Password '$($cred.Number)': `"$($Cred.User)`"."
        } 
    } elseif ($global:Creds.count -eq 1) {
        Write-Host "Password 1: `"$($global:Creds[0].user)`"."
    }
    Write-Host "A: Press 'A' to add."
    Write-Host "E: Press 'E' to edit."
    Write-Host "T: Press 'T' to Type Password."
    Write-Host "C: Press 'C' to Copy Password."
    Write-Host "Q: Press 'Q' to quit."
    $menuinput = Read-Host "Please make a selection"
    switch ($menuinput.ToLower())
    {
        {$_ -eq "a"} {Write-Host 'You chose option - New Creds';Addkey}
        {$_ -eq 'e'} {Write-Host 'You chose option - Edit Creds';Read-Host} 
        {$_ -eq 't'} {Write-Host 'You chose option - Type Creds';Show-TypeMenu} 
        {$_ -eq 'c'} {Write-Host 'You chose option - Copy Creds';Show-CopyMenu} 
        {$_ -eq 'q'} {Write-Host 'You chose option - Quit';exit} 
        #{$_ -le 9 -and $_ -ge 1} {if (($global:Creds) -and ($menuinput -le $global:Creds.count)) {Type-Letters $Creds[$_-1].Values} else {Write-host "Invalid option. Try again";Read-Host}}
    }
}

function Show-TypeMenu
{
    param (
    [string]$Title = 'Password Keeper - Type Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    $i = 0
    if ($global:creds.count -ge 2) {
        foreach ($Cred in $global:Creds) {
            $i += 1
            Write-Host "Press '$($cred.number)' to Type password: `"$($Cred.user)`"."
        } 
    } elseif ($global:creds.count -eq 1) {
        Write-Host "Password 1: `"$($global:Creds[0].User)`"."
    }
    Write-Host "Q: Press 'Q' to quit."
    $menuinput = Read-Host "Please make a selection"
    switch ($menuinput.ToLower())
    {
        {$_ -eq 't'} {Write-Host 'You chose option - Type Creds';Show-TypeMenu} 
        {$_ -eq 'c'} {Write-Host 'You chose option - Copy Creds';Read-Host} 
        {$_ -eq 'q'} {Write-Host 'You chose option - Quit';break}
        {$_ -le 9 -and $_ -ge 1} {if (($global:Creds) -and ($menuinput -le $global:Creds.count)) {Type-Letters $global:Creds[$_-1].Pass} else {Write-host "Invalid option. Try again";Read-Host}}
    }    
}
function Show-CopyMenu
{
    param (
    [string]$Title = 'Password Keeper - Copy Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    $i = 0
    if ($global:creds.count -ge 2) {
        foreach ($Cred in $global:Creds) {
            $i += 1
            Write-Host "Press '$($cred.number)' to Copy password: `"$($Cred.user)`"."
        } 
    } elseif ($global:creds.count -eq 1) {
        Write-Host "Password 1: `"$($global:Creds.User)`"."
    }
    Write-Host "Q: Press 'Q' to go back."
    $menuinput = Read-Host "Please make a selection"
    switch ($menuinput.ToLower())
    {
        {$_ -eq 'q'} {Write-Host 'You chose option - Quit';break}
        {$_ -le 9 -and $_ -ge 1} {if (($global:Creds) -and ($menuinput -le $global:Creds.count)) {$global:Creds[$_-1].Pass | Set-Clipboard} else {Write-host "Invalid option. Try again";Read-Host}}
    }    
}


function Type-Letters {
    param (
        [string]$text
    )
    Add-Type -AssemblyName System.Windows.Forms
    Start-Sleep -Seconds 5



    foreach ($char in $text.ToCharArray()) {
        [System.Windows.Forms.SendKeys]::SendWait($char)
    }
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

    
}

 function Main {
    do
    {
        Clear-Host
        Show-MainMenu

    }
    until ($menuinput -eq 'q')

 }
 Main




