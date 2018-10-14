# Windows Standard Lockdown

Desired State Configuration module designed to implement a secure baseline.

There are dozens of projects with 800 point checklists designed for secure baselines. This project is designed to offer an automated implementation of the few most practical and beneficial configuration items.

## Targets
Script is designed for both Windows 10 and Windows 2016. Note that a key point in avoiding the need to audit many often recommended settings, is that they are already defaults on these platforms.

## Use

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

DSC Cannot set User Rights Assignments out of the box. There are at least two related settings I'd like to implement.
