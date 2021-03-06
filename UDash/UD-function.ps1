function UD-Processes
{
    New-UdGrid -Title "Processes" -Headers @("Name", "ID", "Working Set", "CPU") -Properties @("Name", "Id", "WorkingSet", "CPU") -AutoRefresh -RefreshInterval 60 -Endpoint {
        Get-Process | Out-UDGridData
    }
}
function UD-ServerInfo
{
    New-UDTable -Title "Server Information" -Headers @(" ", " ") -Endpoint {
        @{
            'Computer Name' = $env:COMPUTERNAME
            'Operating System' = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
            'Total Disk Space (C:)' = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GBs " }
            'Free Disk Space (C:)' = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'").FreeSpace / 1GB | ForEach-Object { "$([Math]::Round($_, 2)) GBs " }
        }.GetEnumerator() | Out-UDTableData -Property @("Name", "Value")
    }
}
function UD-Info-Services
{
    New-UDTable -Title "Server Information" -Headers @("Name", "Status", "StartType") -Endpoint {
        Get-Service | Select Name, @{Name = 'Status'; Expr = {$_.Status.Tostring()}}, @{Name = 'StartType'; Expr = {$_.StartType.Tostring()}} | Out-UDTableData -Property @("Name", "Status", "StartType")
    }
}
function UD-Monitor-CPU
{
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
        Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
    }
}
function UD-Monitor-Memory
{
    New-UdMonitor -Title "Memory (% in use)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#8028E842' -ChartBorderColor '#FF28E842'  -Endpoint {
        try
        {
            Get-Counter '\memory\% committed bytes in use' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
        }
        catch
        {
            0 | Out-UDMonitorData
        }
    }
}
function UD-Monitor-Memory
{
    New-UdMonitor -Title "Network (IO Read Bytes/sec)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80E8611D' -ChartBorderColor '#FFE8611D'  -Endpoint {
        try
        {
            Get-Counter '\Process(_Total)\IO Read Bytes/sec' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
        }
        catch
        {
            0 | Out-UDMonitorData
        }
    }
}
function UD-Monitor-Disk
{
    New-UdMonitor -Title "Disk (% disk time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80E8611D' -ChartBorderColor '#FFE8611D'  -Endpoint {
        try
        {
            Get-Counter '\physicaldisk(_total)\% disk time' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
        }
        catch
        {
            0 | Out-UDMonitorData
        }
    }
}
function UD-Chart-DiskSpace
{
    New-UdChart -Title "Disk Space by Drive" -Type Bar -AutoRefresh -Endpoint {
        Get-CimInstance -ClassName Win32_LogicalDisk | ForEach-Object {
            [PSCustomObject]@{ DeviceId = $_.DeviceID;
                Size = [Math]::Round($_.Size / 1GB, 2);
                FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); 
            } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
            New-UdChartDataset -DataProperty "Size" -Label "Size" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23"
            New-UdChartDataset -DataProperty "FreeSpace" -Label "Free Space" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
        )
    }
}
function UD-Animals
{
    $Data = @(
        [PSCustomObject]@{Animal = "Frog"; Order = "Anura"; Article = (New-UDLink -Text "Wikipedia" -Url "https://en.wikipedia.org/wiki/Frog")}
        [PSCustomObject]@{Animal = "Tiger"; Order = "Carnivora"; Article = (New-UDLink -Text "Wikipedia" -Url "https://en.wikipedia.org/wiki/Tiger")}
        [PSCustomObject]@{Animal = "Bat"; Order = "Chiroptera"; Article = (New-UDLink -Text "Wikipedia" -Url "https://en.wikipedia.org/wiki/Bat")}
        [PSCustomObject]@{Animal = "Fox"; Order = "Carnivora"; Article = (New-UDLink -Text "Wikipedia" -Url "https://en.wikipedia.org/wiki/Fox")}
    )
    New-UDGrid -Title "Animals" -Headers @("Animal", "Order", "Wikipedia") -Properties @("Animal", "Order", "Article") -Endpoint {
        $Data | Out-UDGridData
    }
}

function UD-Chart-Handlecount
{
    New-UdChart -Title "Handle Count by Process" -Type Doughnut -RefreshInterval 5 -Endpoint {
        Get-Process | Out-UDChartData -DataProperty "HandleCount" -LabelProperty Name
    } -Options @{
        legend = @{
            display = $false
        }
    }
}

function UD-Chart-ThreadCount
{
    New-UdChart -Title "Threads by Process" -Type Doughnut -RefreshInterval 5 -Endpoint {
        Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } |  Out-UDChartData -DataProperty "Threads" -LabelProperty Name
    } -Options @{
        legend = @{
            display = $false
        }
    }
}

function UD-Chart-MemoryByProcess
{
    New-UdChart -Title "Memory by Process" -Type Doughnut -RefreshInterval 5 -Endpoint {
        Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; WorkingSet = [Math]::Round($_.WorkingSet / 1MB, 2) }} |  Out-UDChartData -DataProperty "WorkingSet" -LabelProperty Name
    } -Options @{
        legend = @{
            display = $false
        }
    }
}
function UD-Chart-CPUByProcess
{
    New-UdChart -Title "CPU by Process" -Type Doughnut -RefreshInterval 5 -Endpoint {
        Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; CPU = $_.CPU } } |  Out-UDChartData -DataProperty "CPU" -LabelProperty Name
    } -Options @{
        legend = @{
            display = $false
        }
    }
}
function UD-Button-TCPLogStream
{
    New-UDHeading -Size 5 -Id "ShowOnClick" -Text "test"
    New-UDButton -Text "TCPLog2" -OnClick {
        Set-UDElement -Id "Output" -content {get-process}
        #  New-UDTable -Title "Server Information" -AutoRefresh -Content  {
        #      Get-TCPConnectionLog -ResolveIP $true |  New-UDTextbox -Label "Output"
        #  }
        Show-UDToast -Message "Clicked!"
        
    }
}
function UD-Textbox-TCPLogStream
{
    # New-UDTextbox -id "TCPLOG" -Content {
    #     Get-TCPConnectionLog -ResolveIP $true
    # }

}