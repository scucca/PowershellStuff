<#
.SYNOPSIS
    Download TV shows from the National Broadcasting Service of 
    
.NOTES
    Author: Emil Holm Halldórsson (emil@8bit.is)       
    Version History:
    Version 1.0 - Date 14.03.2019
    Initial Creation
#>
#requires -Version 2
[CmdletBinding(SupportsShouldProcess = $true)]
Param(

)
Process
{
    $baseDir = "\\server-pc\f\Video\Eydis\Sarpur\"

    $showlistRaw = "https://api.ruv.is/api/programs/all"
    $showlisthtml = Invoke-WebRequest $showlistRaw

    $showlist = $showlisthtml | ConvertFrom-Json

    $showSlugList = get-content $($baseDir + "thaettir.txt")

    $shows = $showlist | Where-Object {$_.slug -in $showsluglist}

    foreach ($show in $shows)
    {
        if ($null -eq $show.id)
        {
            Write-Error "Show ---$showslug--- does not exist!!!"
        }
        else
        {
            $showURL = "https://api.ruv.is/api/programs/program/" + $show.id + "/all"
            
            try
            {
                $showinfoRaw = Invoke-WebRequest $showURL
            }
            catch
            {
                write-error "Bad Request for URL $showURL. show slug: $showslug"
            }
            
            $showinfo = $showinfoRaw | ConvertFrom-Json
            Write-Debug "$($show.id) - $($show.slug)"
            foreach ($episode in $showinfo.episodes)
            {
                $epName = $episode.title
                if ($null -ne $episode.slug)
                {
                    $filename = $episode.slug + ".mp4"
                }
                else
                {
                    $filename = $show.slug + '.mp4'
                }

                $showdir = "$basedir" + $show.slug 
                
                if (!(Test-Path $showdir))
                {
                    New-Item -ItemType directory -Path $showdir -InformationAction SilentlyContinue
                }
                $outputFilePath = "$showdir\" + "$filename"
                if (!(Test-Path $outputFilePath))
                {
                    Write-Debug $episode.file
                    if ( $episode.file -match 'manifest')
                    {
                        $null = $episode.file -match '^.+(?=manifest)'

                        $URLprefix = $Matches[0]

                        $URLsuffixes = $episode.file -split ',' | select -skip 1
                        $bestURLSuffix = ''
                        $highest = 0
                        foreach ($suffix in $URLsuffixes)
                        {
                            $quality, $suffixCandidate = [int]($suffix -split ':')[-1], ($suffix -split ':')[0]

                            if ($quality -ge $highest)
                            {
                                $highest = $quality
                                $bestURLSuffix = $suffixCandidate
                            }

                        }
                        
                        $URL = [string]($URLprefix + $bestURLSuffix)
                    }
                    else
                    {
                        $URL = $episode.file
                    }
                    #Write-Debug "Copy URL $URL to path $outputfilepath" 
                    #Write-Output "Copy URL $URL to path $outputfilepath" 
                    C:\Users\Emil\Source\MusicBot\ffmpeg.exe -y -i $URL $outputFilePath
                }
            }
        }

    }
}