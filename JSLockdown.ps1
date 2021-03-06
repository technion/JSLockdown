﻿Configuration JSLockdown
{
    # Reference guides: https://adsecurity.org/?p=3377 , https://adsecurity.org/?p=3299

    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName SecurityPolicyDsc
    Import-DscResource -ModuleName NetworkingDsc

    Node 'localhost' {

        # Kills legacy scripting, including .bat, .js and .vbs. Commonly used as executable downloads, to avoid a .exe download
        Registry KillWSH
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows Script Host\Settings"
            ValueName = "Enabled"
            ValueType = "Dword"
            ValueData = "0"
        }

        # Force NTLMv2 only. Legacy protocols are commonly abused.
        Registry ForceNTLMv2
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa\"
            ValueName = "LmCompatibilityLevel"
            ValueType = "Dword"
            ValueData = "5"
        }

        # Force LSA Protection
        Registry ProtectLSASS
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa"
            ValueName = "RunAsPPL"
            ValueType = "Dword"
            ValueData = "1"
        }

        # We should all have killed SMB1 by now
        WindowsOptionalFeature SMB1 {
            Ensure = 'Disable'
            Name = 'SMB1Protocol'
        }

        # Remove Internet Explorer
        WindowsOptionalFeature IE {
            Ensure = 'Disable'
            Name = 'Internet-Explorer-Optional-amd64'
        }
        
        # Prevent local administrator accounts accessing network
        # Prevents pivots from other compromised desktops
        UserRightsAssignment Denyaccesstothiscomputerfromthenetwork {
            Policy   = 'Deny_access_to_this_computer_from_the_network'
            Identity = 'S-1-5-114' # NT AUTHORITY\Local account and member of Administrators group
        }

        # Underrated - Block psexec.exe. I've seen this abused by many malware
        # https://guyrleech.wordpress.com/2017/06/28/petya-disabling-remote-execution-of-psexec/
        Registry BlockPsexec
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\PSEXESVC.exe"
            ValueName = "Debugger"
            ValueData = "svchost.exe"
        }

        # Disable WPAD - https://googleprojectzero.blogspot.com/2017/12/apacolypse-now-exploiting-windows-10-in_18.html?m=1
        HostsFile HostEntry
        {
            HostName  = 'wpad'
            IPAddress = '255.255.255.255'
            Ensure    = 'Present'
        }

        # Disable LLMNR
        Registry DisableLLMNR
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
            ValueName = "EnableMulticast"
            ValueType = "Dword"
            ValueData = "0"
        }
    }
}
