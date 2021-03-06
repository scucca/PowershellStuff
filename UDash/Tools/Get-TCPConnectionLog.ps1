function Get-TCPConnectionLog
{
    <#
    .SYNOPSIS
        Collect TCP Connections and optionally log to file
        
    .NOTES
        Author: Emil Holm Halldórsson (emil@8bit.is)       
        Version History:
        Version 1.0 - Date 27.07.2018
        Initial Creation
    #>
    #requires -Version 2
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [Parameter(Mandatory = $false)][string]$LogPath,
        [Parameter(Mandatory = $false)][int]$Frequency = 5,
        [Parameter(Mandatory = $false)][int]$Seconds = 30,
        [Parameter(Mandatory = $false)][switch]$ResolveIP
    )
    Process
    {
        $ErrorActionPreference = "SilentlyContinue"
        Write-Output "Press Ctrl+C to stop collecting logs."
        while ($true)
        {
            #Filter Listening ports
            $filter = {$_.Localaddress -ne '::' `
                    -and $_.Localaddress -ne '0.0.0.0' `
                    -and $_.Localaddress -ne '127.0.0.1' `
            }
            #Collect all current TCP Connections according to filter
            $currentConnections = get-nettcpconnection | Where-Object $filter
            if ($lastoutput)
            {
                $newConnections = Compare-Object $lastoutput $currentConnections -passthru | Where-Object {$_.Sideindicator -eq '=>'}
            }
            else
            {
                # if first time running
                $newConnections = $currentConnections
            }
            #Move current connections to Last connections
            $lastoutput = $currentConnections
            foreach ($connection in $newConnections)
            {
                try
                {
                    $DNSName = ([System.Net.DNS]::GetHostEntry($connection.RemoteAddress)).Hostname
                }
                catch
                {
                    $DNSName = "Unknown"
                }
                
                #Resolve Process ID to Name
                try
                {
                    $ProcessName = get-process -Id $connection.OwningProcess -ErrorAction SilentlyContinue | select-object -expandproperty processname
                }
                catch
                {
                    $ProcessName = ""
                }
                

                $output = [pscustomobject] @{
                    CreationTime  = $connection.CreationTime
                    LocalAddress  = $connection.Localaddress
                    LocalPort     = $connection.LocalPort
                    RemoteAddress = $connection.RemoteAddress
                    RemotePort    = $connection.RemotePort
                    State         = $connection.State
                    ProcessID     = $connection.OwningProcess
                    ProcessName   = $ProcessName
                    DNSName       = $DNSName
                }
                #If Logpath is specified append to the file. If not write directly to console.
                if ($Logpath -ne '')
                {
                    
                    $output | Export-CSV -Append -Encoding UTF8 -NoTypeInformation -Path $LogPath
                }
                else
                {
                    Write-Output $output
                }
            }
            Start-Sleep -Seconds 5
        }
    }
}

#Get-TCPConnectionLog C:\temp\Logs\$env:Computername-TCPConnectionLog.log -ResolveIP $true
#Get-TCPConnectionLog -ResolveIP $true | ft -AutoSize