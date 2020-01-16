<#
.Synopsis
   Move file, renaming if non-unique
.DESCRIPTION
   Moves a source file to a specific destination, renaming with a numbered suffix 
   if the filename in the destination already exists
.EXAMPLE
   Move-ItemWithUniqueName -source ".\1\1.txt" -destination ".\2\"
.INPUTS
   File path, full or relative
.OUTPUTS
   None.
.NOTES
    Author: Emil Holm Halldórsson (emil@8bit.is)       
    Version History:
    Version 1.0 - Date 16.01.2020
    Initial Creation
#>
function Move-ItemWithUniqueName
{
    [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1', 
        SupportsShouldProcess = $true, 
        PositionalBinding = $false,
        HelpUri = 'http://www.microsoft.com/',
        ConfirmImpact = 'Medium')]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true, 
            Position = 0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]
        $source,

        # Param2 help description
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true, 
            Position = 0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String]
        $destination


    )

    Begin
    {
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            #$file = Get-ChildItem ".\1\1.txt"
            $file = Get-ChildItem $source
            $filename = $file.Name
            $basename = $file.basename
            $ext = $file.extension
            #$destination = ".\2\"
            $destinationpath = join-path -Path $destination -ChildPath $filename
            Write-Verbose $destinationpath
            $num = 1
            while (Test-Path $destinationpath)
            {
                $destinationpath = Join-Path -Path $destination -ChildPath $($basename + "-$num" + $ext)
                $num += 1
            }
            Move-Item -path $file -Destination $destinationpath 
        }
    }
    End
    {
    }
}
