# Prompt for the password
$password = Read-Host -AsSecureString "Enter the database password"

# Convert the secure string to an encrypted standard string
$encryptedPassword = $password | ConvertFrom-SecureString

# Save the encrypted password to a file
$encryptedPassword | Out-File "password.txt"


# Read the encrypted password from the file
$encryptedPassword = Get-Content "password.txt"

# Convert the encrypted string back to a secure string
$securePassword = $encryptedPassword | ConvertTo-SecureString

# Convert the secure string to a plain text password (if needed)
# Note: Be very careful with this, as it exposes the password in plain text
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

echo $plainPassword
# Use the secure password for your database connection (example using SQL Server)
#$credential = New-Object System.Management.Automation.PSCredential ("username", $securePassword)
