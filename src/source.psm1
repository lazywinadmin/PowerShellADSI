
# Try to add necessary assembly during module import - fixes issue where params rely on types within this assembly
# If this assembly was not loaded prior to running Get-ADSIGroup, for example, you were not able to use that function
# If adding this assembly fails, we still allow the user to import the module, but we show them a helpful warning
TRY
{
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
}
CATCH
{
    Write-Warning "[AdsiPS] Unable to add assembly 'System.DirectoryServices.AccountManagement'.`r`nPlease manually add this assembly into your session or you may encounter issues! `r`n`r`nRun the following command: 'Add-Type -AssemblyName System.DirectoryServices.AccountManagement'"
}