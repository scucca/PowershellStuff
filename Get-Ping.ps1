function Get-Ping
{
    <#
    .SYNOPSIS
        Ping a hostname while showing jitter
        
    .NOTES
        Author: Emil Holm Halldórsson (emil@8bit.is)       
        Version History:
        Version 1.0 - Date 11.10.2018
        Initial Creation
        TODO - Get Format-Table to work
    #>
    #requires -Version 2
    [CmdletBinding(SupportsShouldProcess = $false)]
    Param(
        [Parameter(Mandatory = $false)][string]$Computername,
        [Parameter(Mandatory = $false)][int]$bufferSize = 32,
        [Parameter(Mandatory = $false)][int]$delay = 1
    )
    Process
    {
        $numberOfPings = 0
        $combinativelatency = 0
        $lastping = 0
        $ErrorActionPreference = "SilentlyContinue"
        $ping = Test-Connection -ComputerName $Computername -BufferSize $bufferSize -Delay $delay -count 1 -Quiet

        Write-Output "Press Ctrl+C to stop pinging."

        while ($true)
        {
            $ping = Test-Connection -ComputerName $Computername -BufferSize $bufferSize -Delay $delay -count 1
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

            $output
            $lastping = $ping.ResponseTime
            Start-Sleep -Seconds 1
        }
    }
}

#Get-Ping mbl.is
Get-Ping mbl.is| Format-Table