# Windows Standard Lockdown

Desired State Configuration module designed to implement a secure baseline.

There are dozens of projects with 800 point checklists designed for secure baselines. This project is designed to offer an automated implementation of the few most practical and beneficial configuration items.

The intention is that, by being less intimidating than large frameworks, this baseline can be more appealing.

## Targets
Script is designed for both Windows 10 and Windows 2016. Note that a key point in avoiding the need to audit many often recommended settings, is that they are already defaults on these platforms.

## Use
You will need a required module to build the script:
```
     install-module SecurityPolicyDsc
     install-module NetworkingDsc
```
Edit the .ps1 script as required, and recompile:
```
. .\JSLockdown.ps1
JSLockdown
```
If you are happy with the existing rules, skip to running it:
```
Start-DscConfiguration -Path .\JSLockdown\ -Verbose -Wait -Force
```
## Bugs

Office Macro settings are per user settings, and thus cannot be set by DSC. They are however critical to security. Please implement a suitable lockdown.
