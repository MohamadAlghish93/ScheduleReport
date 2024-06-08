# Copyright (c)
## Developer by the Alghish
### Write logs class


$CurrentRunningPath = Split-Path $psise.CurrentFile.FullPath

Function Log-Message()
{
 param
    (
        [Parameter(Mandatory=$true)] [string] $Message,
        [Parameter(Mandatory=$true)] [string] $Type
    )
    
    Try {
        #Get the current date
        $LogDate = (Get-Date).tostring("yyyyMMdd")
 
        #Get the Location of the script
        $CurrentDir = $CurrentRunningPath
        $CurrentDir = $CurrentDir + "\Logs"

        # $CurrentDir = "C:\Users\Administrator\Desktop\Logs"

        If(!(test-path -PathType container $CurrentDir))
        {
              New-Item -ItemType Directory -Path $CurrentDir
        }
 
        #Frame Log File with Current Directory and date
        $Extenstion = ".txt"
        if ($Type -eq "Error") {
            <# Action to perform if the condition is true #>
            $Extenstion = ".error"
        }
        $LogFile = $CurrentDir+ "\" + $LogDate + $Extenstion
 
        #Add Content to the Log File
        $TimeStamp = (Get-Date).toString("dd/MM/yyyy HH:mm:ss:fff tt")
        $Line = "$TimeStamp - $Type - $Message"
        Add-content -Path $Logfile -Value $Line
 
        # Write-host "Message: '$Message' Has been Logged to File: $LogFile"
    }
    Catch {
        Write-host -f Red "Error:" $_.Exception.Message 
    }
}