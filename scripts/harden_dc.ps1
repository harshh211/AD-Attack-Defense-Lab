# DC Hardening Script
# Run as Administrator after completing attack phases

# 1. Re-enable Windows Defender real-time protection
Set-MpPreference -DisableRealtimeMonitoring $false
Write-Host "[+] Defender real-time protection enabled" -ForegroundColor Green

# 2. Re-enable Windows Firewall across all profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Write-Host "[+] Windows Firewall enabled on all profiles" -ForegroundColor Green

# 3. Enforce LDAP Signing (2 = Required)
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\NTDS\Parameters" `
  -Name "LDAPServerIntegrity" -Value 2
Write-Host "[+] LDAP signing enforced" -ForegroundColor Green

# 4. Add privileged accounts to Protected Users group
# Protected Users: prevents NTLM auth, enforces Kerberos AES, no credential caching
Add-ADGroupMember -Identity "Protected Users" -Members "madmin","Harsh21"
Write-Host "[+] Privileged accounts added to Protected Users group" -ForegroundColor Green

# 5. Enforce strong password policy
Set-ADDefaultDomainPasswordPolicy -Identity "lab.local" `
  -MinPasswordLength 14 `
  -ComplexityEnabled $true `
  -MaxPasswordAge (New-TimeSpan -Days 90) `
  -LockoutThreshold 5
Write-Host "[+] Strong password policy enforced" -ForegroundColor Green

# 6. Disable NTLM authentication (optional - may break legacy apps)
# Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LmCompatibilityLevel" -Value 5

Write-Host "`nHardening complete!" -ForegroundColor Cyan
Write-Host "Additional recommendations:" -ForegroundColor Yellow
Write-Host "  - Enable Credential Guard via Group Policy"
Write-Host "  - Deploy Microsoft Sentinel for SIEM"
Write-Host "  - Implement MFA for all admin accounts"
Write-Host "  - Set up Privileged Access Workstations (PAWs)"
