import-module $PSScriptRoot\..\UD-function.ps1
New-UDPage -Name "Status" -Icon home -Content {
    New-UdRow {
        New-UdColumn -Size 6 -Content {
            New-UdRow {
                New-UdColumn -Size 12 -Content {
                    UD-ServerInfo
                }
            }
            New-UdRow {
                New-UdColumn -Size 3 -Content {
                    UD-Chart-MemoryByProcess
                }
                New-UdColumn -Size 3 -Content {
                    UD-Chart-CPUByProcess
                }
                New-UdColumn -Size 3 -Content {
                        UD-Chart-Handlecount
                }
                New-UdColumn -Size 3 -Content {
                    UD-Chart-ThreadCount
                }
            }
            New-UdRow {
                UD-Chart-DiskSpace
            }
        }
        New-UdColumn -Size 6 -Content {
            New-UdRow {
                New-UdColumn -Size 6 -Content {
                    UD-Monitor-CPU
                }
                New-UdColumn -Size 6 -Content {
                    UD-Monitor-Memory
                }
            }
            New-UdRow {
                New-UdColumn -Size 6 -Content {
                    UD-Monitor-Memory
                }
                New-UdColumn -Size 6 -Content {
                    UD-Monitor-Disk
                }
            }
            New-UdRow {
                New-UdColumn -Size 12 {
                    UD-Processes
                }
            }
        }
    }

}