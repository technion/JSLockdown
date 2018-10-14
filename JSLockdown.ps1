Configuration JSLockdown
{
    # Reference guides: https://adsecurity.org/?p=3377 , https://adsecurity.org/?p=3299

    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SecurityPolicyDsc
    Node 'localhost' {

        # Kills legacy scripting, including .bat, .js and .vbs. Commonly used as executable downloads, to avoid a .exe download
        Registry KillWSH
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Script Host\Settings"
            ValueName = "Enabled"
            Hex = $true
            ValueData = "0"
        }

        # Force NTLMv2 only. Legacy protocols are commonly abused.
        Registry ForceNTLMv2
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa\"
            ValueName = "LmCompatibilityLevel"
            Hex = $true
            ValueData = "5"
        }

        # Force LSA Protection
        Registry AuditLSASS
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa"
            ValueName = "RunAsPPL"
            Hex = $true
            ValueData = "1"
        }

        # We should all have killed SMB1 by now
        WindowsOptionalFeature SMB1 {
            Ensure = 'Disable'
            Name = 'SMB1Protocol'
        }
        
        # Prevent local administrator accounts accessing network
        UserRightsAssignment Denyaccesstothiscomputerfromthenetwork {
            Policy   = 'Deny_access_to_this_computer_from_the_network'
            Identity = 'S-1-5-114' # NT AUTHORITY\Local account and member of Administrators group
        }

    }
}