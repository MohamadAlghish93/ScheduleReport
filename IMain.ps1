# Main function
################################

$ApplicationLocation = "C:\Users\nvss2\Downloads\Moj-Report-Users"
$SettingsPath = "$ApplicationLocation\settings.json"

. "$ApplicationLocation\Ilogs.ps1"
. "$ApplicationLocation\IDatabase.ps1"
. "$ApplicationLocation\ISettings.ps1"
. "$ApplicationLocation\IEmail.ps1"

Try {
    #Read-Settings
    $Setting = Read-Settings -SettingsPath $SettingsPath
    $DateYYYYMM = (Get-Date).ToString("yyyyMM")

    $ActiveUsersQuery = "select distinct dt.FLDUSERNAME, u.fldFirstName + ' ' + u.fldFamilyName FullName, u.fldEmail from TSDOCUMENTTRANSACTION dt inner join tblUsers u on u.fldName=dt.FLDUSERNAME where dt.FLDACTIONDATE like '202%' and  dt.FLDUSERNAME in ( 	select distinct dt.FLDUSERNAME from TSDOCUMENTTRANSACTION dt 	where dt.FLDACTIONDATE like '$DateYYYYMM%' )	"

    $NonActiveUsersQuery = "select distinct dt.FLDUSERNAME, u.fldFirstName + ' ' + u.fldFamilyName FullName, u.fldEmail from TSDOCUMENTTRANSACTION dt inner join tblUsers u on u.fldName=dt.FLDUSERNAME where dt.FLDACTIONDATE like '202%' and  dt.FLDUSERNAME not in ( 	select distinct dt.FLDUSERNAME from TSDOCUMENTTRANSACTION dt 	where dt.FLDACTIONDATE like '$DateYYYYMM%' )	"


    $ResultNonActive = SQL-Select -sqlText $NonActiveUsersQuery -database $Setting.database -server $Setting.server -username $Setting.username -password $Setting.password
    $ResultActive = SQL-Select -sqlText $ActiveUsersQuery -database $Setting.database -server $Setting.server -username $Setting.username -password $Setting.password


    $ResNonActive =  Join-Path -Path $ApplicationLocation -ChildPath "\Temps\MOJ-inactive-users_$DateYYYYMM.csv" 
    $ResActive =  Join-Path -Path $ApplicationLocation -ChildPath "\Temps\MOJ-active-users_$DateYYYYMM.csv"    
    ## Convert to CSV
    $ResultNonActive | Select-Object FLDUSERNAME, FullName, fldEmail | Export-Csv -Encoding UTF8 -Path $resNonActive
    $ResultActive | Select-Object FLDUSERNAME, FullName, fldEmail | Export-Csv -Encoding UTF8 -Path $ResActive

    ## Zip File
    $ResNonActiveZip = Join-Path -Path $ApplicationLocation -ChildPath "\Temps\MOJ-inactive-users_$DateYYYYMM.zip"
    Compress-Archive -Path $ResNonActive -Update -DestinationPath $ResNonActiveZip
    $ResActiveZip = Join-Path -Path $ApplicationLocation -ChildPath "\Temps\MOJ-active-users_$DateYYYYMM.zip"
    Compress-Archive -Path $ResActive -Update -DestinationPath $ResActiveZip
    
    ## Send Email
    Send-Email -emailTo $Setting.email.forwardTo -attachmentpath  $ResNonActiveZip -username $Setting.email.address -password $Setting.email.password -bodyEmail "" -subject "" -emailFrom $Setting.email.address -emailHost $Setting.email.host -port $Setting.email.port -domain $Setting.email.domain
    Send-Email -emailTo $Setting.email.forwardTo -attachmentpath  $ResActiveZip -username $Setting.email.address -password $Setting.email.password -bodyEmail "" -subject "" -emailFrom $Setting.email.address -emailHost $Setting.email.host -port $Setting.email.port -domain $Setting.email.domain

}
Catch {
    Log-Message "Error: $($_.Exception.Message)" "Error"         
}
