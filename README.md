# Remove-Stale-Profiles

This script is used to remove profiles form AD (Active Directory) joined computers where the user no longer is active in AD.

Script requires Windows RSAT tools so the ActiveDirectory Powershell module is available.

$computername is set to localhost with the idea that this script will be run on the host it's scanning via PDQ Deploy.
