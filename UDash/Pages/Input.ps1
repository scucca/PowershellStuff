New-UDPage -Name "input" -Icon home -Content {
    New-UDInput -Title "Input" -Endpoint {
        param($Text, [bool]$CheckBox, [System.DayOfWeek]$SelectBox, [ValidateSet("One", "Two", "Three")]$SelectBox2) 

        New-UDInputAction -Toast "Clicked!"
    }
    New-UDInput -Title "Input" -Endpoint {
        param($Text) 
        
        New-UDInputAction -Content @(
            New-UDCard -Title $Text -Text "This is text"
        )
    }
}