# Copyright (c)
## Developer by the Alghish
### Read Settings class
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
$jsonserial = New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer
$jsonserial.MaxJsonLength = [int]::MaxValue



Function Read-Settings {
    param
    (
        [Parameter(Mandatory=$true)] [string] $SettingsPath
    )
    # config file
    Try {
        $PowerShellObject = $jsonserial.DeserializeObject($(Get-Content -Path $SettingsPath))
        # Convert the encrypted string back to a secure string
        $securePassword = $PowerShellObject.password | ConvertTo-SecureString

        # Convert the secure string to a plain text password (if needed)
        # Note: Be very careful with this, as it exposes the password in plain text
        $PowerShellObject.password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

        # Email Password
        #$securePassword = $PowerShellObject.email.password | ConvertTo-SecureString
        #$PowerShellObject.email.password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

        return $PowerShellObject
    }
    Catch {
        Log-Message "Error: $($_.Exception.Message)" "Error"         
    }
}