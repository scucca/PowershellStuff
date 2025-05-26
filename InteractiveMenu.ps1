<#
Import-Module Microsoft.PowerShell.SecretManagement
Import-Module Microsoft.PowerShell.SecretStore

Register-SecretVault -Name PasswordKeeper -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault




#>


$delay = 10
$global:Creds = @()
$index = 0

function New-Vault {
    Register-SecretVault -Name PasswordKeeper -VaultParameters @{Authentication=$null; Interaction=$null} -ModuleName Microsoft.PowerShell.SecretStore
}
function Test-Vault {
    if ((Get-SecretStoreConfiguration | Select-Object -expand authentication) -ne "None") {
        Reset-SecretStore -Authentication None -Interaction None -PasswordTimeout 0 -Force -Confirm:$false -WarningAction SilentlyContinue
    }
    $store = Get-SecretVault -Name PasswordKeeper -ErrorAction Silentlycontinue
    if ($store -eq $null) {
        Write-host "Not found"
        New-Vault
    }
}


Get-SecretInfo -Vault Passwordkeeper

function AddKey {
    $key = Get-Credential -Message "Enter new user/pass combo"
    set-secret -vault PasswordKeeper -name $key.GetNetworkCredential().Username -Secret $key.GetNetworkCredential().Password    
}



function EditKey ($index){
    $key = get-credential -username $(get-secretinfo -vault PasswordKeeper)[$index].Name
    set-secret -vault PasswordKeeper -name $key.GetNetworkCredential().Username -Secret $key.GetNetworkCredential().Password
}

function RemoveKey ($Name){
    remove-secret -vault PasswordKeeper -name $name
}

    
function Show-EditMenu
{
    param (
    [string]$Title = 'Password Keeper - Type Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    $index = 1
    $secrets = $(get-secretinfo -vault PasswordKeeper)
    if ($secrets.count -ge 1) {
            foreach ($cred in $secrets) {
                Write-Host "Password '$index': `"$($cred.name)`"."
                $index += 1
            } 
    }
    Write-Host "Q: Press 'Q' to quit."
    $menuinput = Read-Host "Please make a selection"
    switch ($menuinput.ToLower())
    {
        {$_ -eq 'q'} {Write-Host 'You chose option - Quit';break}
        {$_ -le 9 -and $_ -ge 1} {if ($menuinput -le $secrets.count) {EditKey $($_-1)} else {Write-host "Invalid option. Try again";Read-Host}}
    }    
}

function Show-RemoveMenu
{
    param (
    [string]$Title = 'Password Keeper - Type Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    $index = 1
    $secrets = $(get-secretinfo -vault PasswordKeeper)
    if ($secrets.count -ge 1) {
            foreach ($cred in $secrets) {
                Write-Host "Password '$index': `"$($cred.name)`"."
                $index += 1
            } 
    }
    Write-Host "Q: Press 'Q' to quit."
    $menuinput = Read-Host "Please make a selection"
    switch ($menuinput.ToLower())
    {
        {$_ -eq 'q'} {Write-Host 'You chose option - Quit';break}
        {$_ -le 9 -and $_ -ge 1} {if ($menuinput -le $secrets.count) {RemoveKey $($secrets[$_-1].Name)} else {Write-host "Invalid option. Try again";Read-Host}}
    }    
}
function Show-MainMenu
{
    param (
    [string]$Title = 'Password Keeper - Main Menu'
    )
    $index = 1
    $secrets = $(get-secretinfo -vault PasswordKeeper)
    Write-Host "================ $Title ================"
        foreach ($cred in $secrets) {
            Write-Host "Password '$index': `"$($cred.name)`"."
            $index += 1
        } 
    Write-Host "A: Press 'A' to add."
    Write-Host "E: Press 'E' to edit."
    Write-Host "R: Press 'R' to remove."
    Write-Host "T: Press 'T' to Type Password."
    Write-Host "C: Press 'C' to Copy Password."
    Write-Host "Q: Press 'Q' to quit."
    $menuinput = Read-Host "Please make a selection"
    switch ($menuinput.ToLower())
    {
        {$_ -eq "a"} {Write-Host 'You chose option - New Creds';Addkey}
        {$_ -eq 'e'} {Write-Host 'You chose option - Edit Creds';Show-EditMenu} 
        {$_ -eq 'r'} {Write-Host 'You chose option - Remove Creds';Show-RemoveMenu} 
        {$_ -eq 't'} {Write-Host 'You chose option - Type Creds';Show-TypeMenu} 
        {$_ -eq 'c'} {Write-Host 'You chose option - Copy Creds';Show-CopyMenu} 
        {$_ -eq 'q'} {Write-Host 'You chose option - Quit';exit} 
    }
}

function Show-TypeMenu
{
    param (
    [string]$Title = 'Password Keeper - Type Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    $index = 1
    $secrets = $(get-secretinfo -vault PasswordKeeper)
    if ($secrets.count -ge 1) {
            foreach ($cred in $secrets) {
                Write-Host "Password '$index': `"$($cred.name)`"."
                $index += 1
            } 
    }
    Write-Host "Q: Press 'Q' to quit."
    $menuinput = Read-Host "Please make a selection"
    switch ($menuinput.ToLower())
    {
        {$_ -eq 't'} {Write-Host 'You chose option - Type Creds';Show-TypeMenu} 
        {$_ -eq 'c'} {Write-Host 'You chose option - Copy Creds';Read-Host} 
        {$_ -eq 'q'} {Write-Host 'You chose option - Quit';break}
        {$_ -le 9 -and $_ -ge 1} {if ($menuinput -le $secrets.count) {Out-Letters $($secrets[$_-1] | get-secret -asplaintext)} else {Write-host "Invalid option. Try again";Read-Host}}
    }    
}

function Show-CopyMenu
{
    param (
    [string]$Title = 'Password Keeper - Copy Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    $index = 1
    $secrets = $(get-secretinfo -vault PasswordKeeper)
    if ($secrets.count -ge 1) {
            foreach ($cred in $secrets) {
                Write-Host "Password '$index': `"$($cred.name)`"."
                $index += 1
            } 
    }
    Write-Host "Q: Press 'Q' to go back."
    $menuinput = Read-Host "Please make a selection"
    switch ($menuinput.ToLower())
    {
        {$_ -eq 'q'} {Write-Host 'You chose option - Quit';break}
        {$_ -le 9 -and $_ -ge 1} {if ($menuinput -le $secrets.count) {$secrets[$_-1] | get-secret -asplaintext | Set-Clipboard} else {Write-host "Invalid option. Try again";Read-Host}}
    }    
}



function Out-Letters {
    param (
        [string]$text
    )
    Add-Type -AssemblyName System.Windows.Forms
    Start-Sleep -Seconds 5



    foreach ($char in $text.ToCharArray()) {
        if ($char -in ("+",")","(","^","%","~","{","}")) {
            $char = "{$char}"
        }
        [System.Windows.Forms.SendKeys]::SendWait($char)
        Start-Sleep -Milliseconds $delay
    }
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

    
}

 function Main {
    Test-Vault
    do
    {
        Clear-Host
        Show-MainMenu

    }
    until ($menuinput -eq 'q')

 }
 Main




