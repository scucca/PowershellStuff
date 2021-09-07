$global:BaseConfig = "config.json"

try {
    $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
    $configPath = Join-Path $scriptPath "config.json"
	$global:Config = Get-Content "$configPath" -Raw -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue | 
            ConvertFrom-Json -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

} catch {
	Write-PoshError -Message "The Base configuration file is missing!" -Stop
}
if (!($Config)) {
    Write-Error -Message "The Base configuration file contents are missing!"
}

$global:ConfigVersion = ($Config.basic.ConfigVersion)

$global:Company = ($Config.basic.Customer)

$global:environment = ($Config.basic.environment)


Write-host $global:ConfigVersion 
Write-host $global:Company
Write-host $global:environment



function Write-ToLog {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $LogLevel,
        [Parameter()]
        [string]
        $Message
    )
    begin {
        $originalForegroundColor = $host.UI.RawUI.ForegroundColor
    }
    process {
        if ($Config.LogLevel.$LogLevel.color) {
            $host.UI.RawUI.ForegroundColor = $Config.LogLevel.$LogLevel.color
            Write-Output $Message
        } else {
            Write-ToLog -LogLevel "Error" -Message "Error: Color does not exist in configuration file"
        }
    }
    end {
        $host.UI.RawUI.ForegroundColor = $originalForegroundColor
    }
}