function Get-Ping
{
    <#
    .SYNOPSIS
        Ping a hostname while showing jitter
        
    .NOTES
        Author: Emil Holm Halldórsson (emil@8bit.is)       
        Version History:
        Version 1.2 - Date 11.10.2018
        Added log support
    #>
    #requires -Version 2
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [Parameter(Mandatory = $false,ValueFromPipeline = $true)][string[]]$Computername,
        [Parameter(Mandatory = $false)][int]$bufferSize = 32,
        [Parameter(Mandatory = $false)][int]$delay = 1,
        [Parameter(Mandatory = $false)][string]$LogPath
    )
    Process
    {
        $numberOfPings = 0
        $combinativelatency = 0
        $lastping = 0
        $ErrorActionPreference = "SilentlyContinue"
        Write-Output "Press Ctrl+C to stop pinging."
        while ($true)
        {
            $ping = Test-Connection -Computername $Computername -BufferSize $bufferSize -Delay $delay -count 1
            $time = Get-Date
            $numberOfPings += 1
            $combinativelatency += $ping.ResponseTime
            [int]$average = $combinativelatency / $numberOfPings
            $jitter = [Math]::Abs($ping.ResponseTime - $lastping)
            $output = [pscustomobject] @{
                Time          = $time
                RemoteAddress = $ping.Address
                RemoteIP      = $ping.IPV4Address
                BufferSize    = $ping.BufferSize
                ResponseTime  = $ping.ResponseTime
                Average       = $average
                Jitter        = $jitter
            }
            if ($Logpath -ne '')
            {
                
                $output | Export-CSV -Append -Encoding UTF8 -NoTypeInformation -Path $LogPath
            }
            else
            {
                Write-Output $output
            }
            Start-Sleep -Seconds $delay
        }
    }
}

Get-Ping mbl.is -LogPath "C:\temp\ping.csv"
