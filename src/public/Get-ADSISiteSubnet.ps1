﻿function Get-ADSISiteSubnet
{
<#
.SYNOPSIS
    Function to retrieve the Active Directory Site subnets

.DESCRIPTION
    Function to retrieve the Active Directory Site subnets

.PARAMETER Credential
    Specifies alternative credential to use. Default is the current user.

.PARAMETER ForestName
    Specifies the ForestName to query. Default is the current one

.PARAMETER SubnetName
    Specifies the Site Name to find.

.EXAMPLE
    Get-ADSISiteSubnet

.EXAMPLE
    Get-ADSISiteSubnet -ForestName lazywinadmin.com

.EXAMPLE
    Get-ADSISiteSubnet -Credential (Get-Credential superAdmin) -Verbose

.EXAMPLE
    Get-ADSISiteSubnet -ForestName lazywinadmin.com -Credential (Get-Credential superAdmin) -Verbose

.EXAMPLE
    Get-ADSISiteSubnet -Name 'Azure'

.OUTPUTS
    System.DirectoryServices.ActiveDirectory.ActiveDirectorySubnet

.NOTES
    https://github.com/lazywinadmin/ADSIPS
#>

    [CmdletBinding()]
    [OutputType('System.DirectoryServices.ActiveDirectory.ActiveDirectorySubnet')]
    param
    (
        [Alias("RunAs")]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,

        $ForestName = [System.DirectoryServices.ActiveDirectory.Forest]::Getcurrentforest(),

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias("Name")]
        [String]$SubnetName
    )
    begin
    {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement

        # Create Context splatting
        $ContextSplatting = @{ ContextType = "Forest" }

        if ($PSBoundParameters['Credential'])
        {
            $ContextSplatting.Credential = $Credential
        }
        if ($PSBoundParameters['ForestName'])
        {
            $ContextSplatting.ForestName = $ForestName
        }

        $Context = New-ADSIDirectoryContext @ContextSplatting -contextType Forest
    }
    process
    {
        try
        {
            if ($PSBoundParameters['SubnetName'])
            {
                [System.DirectoryServices.ActiveDirectory.ActiveDirectorySubnet]::FindByName($Context, $SubnetName)
            }
            if (-not $PSBoundParameters['SubnetName'])
            {
                (Get-ADSISite @PSBoundParameters).subnets
            }
        }
        catch
        {
            $pscmdlet.ThrowTerminatingError($_)
        }
    }
}