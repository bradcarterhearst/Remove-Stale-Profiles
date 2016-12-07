# Imports
Import-Module ActiveDirectory

$computer = "localhost"
#Test network connection before making connection
If ($computer -ne $Env:Computername) {
    If (!(Test-Connection -comp $computer -count 1 -quiet)) {
        Write-Warning "$computer is not accessible, please try a different computer or verify it is powered on."
        Break
        }
    }

# Get profiles on the computer
Try {
    $users = Get-WmiObject -ComputerName $computer Win32_UserProfile -filter "LocalPath Like 'C:\\Users\\%'" -ea stop
    }
Catch {
    Write-Warning "$($error[0]) "
    Break
    }    

$num_users = $users.count

For ($i=0;$i -lt $num_users; $i++) {

    # check if the user is a an active AD member, if not delete the profile.
    try     {
            $userBaseName = (New-Object System.Security.Principal.SecurityIdentifier($users[$i].SID)).Translate([System.Security.Principal.NTAccount]).Value.Split("\")[-1]
            if (-Not ((Get-ADUser $userBaseName).Enabled)) {
                Write-Host "Removing AD user:  "$userBaseName}
            }
    catch   {
                # Exception is raised
            if ($user.LocalPath.contains("localadmin")) {
                Write-Host "Deleting non AD user:  "$users[$i].LocalPath}
                (Get-WmiObject Win32_UserProfile | Where {$_.LocalPath -like $users[$i].LocalPath).Delete()

            }
}
