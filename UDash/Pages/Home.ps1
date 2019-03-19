. $PSScriptRoot\..\UD-function.ps1
New-UDPage -Name "Home" -Icon home -Content {
    New-UDCard -Title "Hello, Universal Dashboard" 
    New-UdRow {
        New-UdColumn -Size 6 -Content {
            UD-Button-TCPLogStream
        }

    }
    New-UdRow {
        New-UdColumn -Size 6 -Content {
            New-UDCard -Id 'Output' -title 'Output' -Content {

            }
        }
    }
}