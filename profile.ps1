trap {continue}
$Global:MyBreakpoint = $Global:Clipboard = `
    Set-PSBreakpoint -Variable Clipboard -Mode Read -Action {
    Set-Variable clipboard ([Windows.clipboard]::GetText()) `
        -Option ReadOnly, AllScope -Scope Global -Force
}
$jsonFilePath = "$PSScriptRoot\Commandlinefu-commands.json"


function New-CMDFuFile {
    # Check if the file exists
    if (Test-Path -Path $jsonFilePath) {
        Write-Host "File found: $jsonFilePath"
    } else {
        Write-Host "File not found: $jsonFilePath"
$commands = @"
{
"commands": [
{
    "command": "Get-Process | Select-Object -First 10",
    "comment": "Get the first 10 processes running on the system"
},
{
    "command": "Get-Service | Where-Object { $_.Status -eq 'Running' }",
    "comment": "List all running services"
},
{
    "command": "Get-EventLog -LogName Application -Newest 5",
    "comment": "Retrieve the 5 most recent application event logs"
},
{
    "command": "Test-Connection -ComputerName google.com -Count 4",
    "comment": "Ping Google 4 times to check the connection"
}
]
}
"@
        $commands | out-file $jsonFilePath
    }
}
function Get-CMDFu {
    param (
        $ListAll=$true,
        [string]$Search
    )
    if (get-variable jsonFilePath) {
        if (Test-path $jsonFilePath) {
            $jsonData = Get-Content -Path $jsonFilePath | ConvertFrom-Json

            if ($Search) {
                $ListAll = $false
                foreach ($entry in $jsonData.commands) {
                    if ($($entry.commend -match $Search)){
                        Write-Host "Comment: $($entry.comment)"
                        Write-Host -ForegroundColor green -BackgroundColor Black "Command: $($entry.command)"
                        Write-Host "-------------------------"
                    }
                }
            }
            if($true -eq $ListAll){
                foreach ($entry in $jsonData.commands) {
                    Write-Host "Comment: $($entry.comment)"
                    Write-Host -ForegroundColor green -BackgroundColor Black "Command: $($entry.command)"
                    Write-Host "-------------------------"
                }
            }
        } else {
            Write-Error "jsonFilePath $jsonFilePath does not exist. Please run `"New-CMDFuFile`" to create one"    
        }
    } else {
        Write-Error "Variable `$jsonFilePath not set. Please check your profile.ps1"
    }
}

function Add-CMDFu {
    param (
    )
    if (get-variable jsonFilePath) {
        if (Test-path $jsonFilePath) {
            $jsonData = Get-Content -Path $jsonFilePath | ConvertFrom-Json

            $command = Read-host -Prompt "Input the command here"
            $comment = Read-host -Prompt "Input the comment here"

            $newCommand = @{
                command = $command
                comment = $comment
            }
            
            # Add the new entry to the commands array
            $jsonData.commands += $newCommand
            
            # Convert the updated object back to JSON and save it to the file
            $jsonData | ConvertTo-Json -Depth 3 | Set-Content -Path $jsonFilePath
            
        } else {
            Write-Error "jsonFilePath $jsonFilePath does not exist. Please run `"New-CMDFuFile`" to create one"    
        }
    } else {
        Write-Error "Variable `$jsonFilePath not set. Please check your profile.ps1"
    }
}