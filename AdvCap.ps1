function Click-MouseButton
{
param(
[string]$Button, 
[switch]$help)
$HelpInfo = @'

Function : Click-MouseButton
By       : John Bartels
Date     : 12/16/2012 
Purpose  : Clicks the Specified Mouse Button
Usage    : Click-MouseButton [-Help][-Button x]
           where      
                  -Help         displays this help
                  -Button       specify the Button You Wish to Click {left, middle, right}

'@ 

if ($help -or (!$Button))
{
    write-host $HelpInfo
    return
}
else
{
    $signature=@' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@ 

    $SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru 
    if($Button -eq "left")
    {
        $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
        $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
    }
    if($Button -eq "right")
    {
        $SendMouseClick::mouse_event(0x00000008, 0, 0, 0, 0);
        $SendMouseClick::mouse_event(0x00000010, 0, 0, 0, 0);
    }
    if($Button -eq "middle")
    {
        $SendMouseClick::mouse_event(0x00000020, 0, 0, 0, 0);
        $SendMouseClick::mouse_event(0x00000040, 0, 0, 0, 0);
    }

}


}
function Check-ScrollLock {
    Add-Type -MemberDefinition @'
[DllImport("user32.dll")] 
public static extern short GetKeyState(int nVirtKey);
'@ -Name keyboardfuncs -Namespace user32

    # 0x91 = 145, the virtual key code for the Scroll Lock key 
    # see http://www.foreui.com/articles/Key_Code_Table.htm
    if([user32.keyboardfuncs]::GetKeyState(0x91) -eq 1){
        return $true
    }
    else {
        
        return $false
    }
    
}
function AutoClick {
    param (
        [int]$delay
    )
    Write-Host "AutoClick is Active. Press Ctrl-C to stop (Make sure scroll lock is disabled)"
    while ($true) {
        if (Check-ScrollLock -eq $true) {
            Click-MouseButton "left"
            
        }
        start-sleep -milliseconds $delay
    }

}