# AD Lab Setup Script
# Run as Administrator on Domain Controller after AD DS role is installed

# Create Organizational Units
New-ADOrganizationalUnit -Name "Employees" -Path "DC=lab,DC=local"
New-ADOrganizationalUnit -Name "IT" -Path "OU=Employees,DC=lab,DC=local"
New-ADOrganizationalUnit -Name "HR" -Path "OU=Employees,DC=lab,DC=local"

# Create users with weak password (intentional for lab)
$password = ConvertTo-SecureString "Password123!" -AsPlainText -Force

New-ADUser -Name "John Smith" -SamAccountName "jsmith" `
  -UserPrincipalName "jsmith@lab.local" `
  -Path "OU=IT,OU=Employees,DC=lab,DC=local" `
  -AccountPassword $password -Enabled $true

New-ADUser -Name "Sarah Jones" -SamAccountName "sjones" `
  -UserPrincipalName "sjones@lab.local" `
  -Path "OU=HR,OU=Employees,DC=lab,DC=local" `
  -AccountPassword $password -Enabled $true

New-ADUser -Name "Mike Admin" -SamAccountName "madmin" `
  -UserPrincipalName "madmin@lab.local" `
  -Path "OU=IT,OU=Employees,DC=lab,DC=local" `
  -AccountPassword $password -Enabled $true

# Add madmin to Domain Admins
Add-ADGroupMember -Identity "Domain Admins" -Members "madmin"

# Set SPN on jsmith (makes it Kerberoastable)
Set-ADUser -Identity "jsmith" -ServicePrincipalNames @{Add="HTTP/webserver.lab.local"}

# Weaken password policy (for lab purposes only)
Set-ADDefaultDomainPasswordPolicy -Identity "lab.local" `
  -MinPasswordLength 4 -ComplexityEnabled $false -MaxPasswordAge 0

Write-Host "AD lab setup complete!" -ForegroundColor Green
