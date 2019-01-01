function Get-Collatz
{
    <#
    .SYNOPSIS
        Programming exercise to calculate a Collatz sequence for a given number
        
    .NOTES
        Author: Emil Holm Halldórsson (emil@8bit.is)       
        Version History:
        Version 1.0 - Date 11.10.2018
        Initial Creation
    #>
    #requires -Version 2
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [Parameter(Mandatory = $true)][int]$number
    )
    Process
    {
        do {
            Write-host -NoNewline "$number -> "
            if ($number % 2 -eq 0) {
                $number = $number / 2
            } else {
                $number = ($number * 3) + 1
            }

        } while ($number -ne 1)
       Write-host 1
    }
}

$collatz = 1
while ($true) {
    Get-Collatz $collatz
    $collatz += 1    
}
