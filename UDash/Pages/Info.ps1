New-UDPage -Name "Info" -Icon clipboard -Content { 
    New-UdRow {
        New-UdColumn -Size 6 -Content {
            UD-ServerInfo
        }
        New-UdColumn -Size 6 -Content {
            UD-Info-Services
        }
    }
}