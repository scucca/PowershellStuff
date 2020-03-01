$global:ExchangeTemplate = @'
USER CREATION IN EXCHANGE:
Run the following commands in an Exchange Powershell window on the server goamsexc917 (excluding '-' characters):
------------------------
get-aduser {{username}}
## Change OOO message

------------------------
'@
$global:ADTemplate = @'
USER CREATION IN AD:
Run the following commands in a Powershell window on the Admin server (excluding '-' characters):
------------------------
get-aduser {{username}}
## Move user to Cemetery OU
## Remove Groups from user
## Change hidefromaddresslist property
------------------------
'@

#requires -Version 2
function Out-Notepad
{
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]
        [AllowEmptyString()] 
        $Text
    )

    begin
    {
        $sb = New-Object System.Text.StringBuilder
    }

    process
    {
        $null = $sb.AppendLine($Text)
    }
    end
    {
        $text = $sb.ToString()

        $process = Start-Process notepad -PassThru
        $null = $process.WaitForInputIdle()


        $sig = '
      [DllImport("user32.dll", EntryPoint = "FindWindowEx")]public static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);
      [DllImport("User32.dll")]public static extern int SendMessage(IntPtr hWnd, int uMsg, int wParam, string lParam);
    '

        $type = Add-Type -MemberDefinition $sig -Name APISendMessage -PassThru
        $hwnd = $process.MainWindowHandle
        [IntPtr]$child = $type::FindWindowEx($hwnd, [IntPtr]::Zero, "Edit", $null)
        $null = $type::SendMessage($child, 0x000C, 0, $text)
    }
}

function Start-Offboarding
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]
        [AllowEmptyString()] 
        $username
    )
    begin
    {
        
    }
    process
    {

        $exchangecommand = $global:ExchangeTemplate
        $exchangecommand = $exchangecommand.replace("{{username}}", $username)
        $exchangecommand | Out-Notepad
    }
    end
    {
        
    }
}

Start-Offboarding


