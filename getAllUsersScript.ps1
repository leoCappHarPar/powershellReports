# Install Microsoft Graph module if not installed
#if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    #Install-Module -Name Microsoft.Graph -Scope CurrentUser -Force
#}

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All"

# Define the output file path
$outputFile = "C:\Reports\EntraID_Users_Report.csv"

# Ensure the output directory exists
$outputDir = Split-Path -Path $outputFile
if (-not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force
}

# Retrieve all users
$users = Get-MgUser -All -Property DisplayName,UserPrincipalName,Mail,AccountEnabled

# Select relevant properties
$userReport = $users | Select-Object DisplayName, UserPrincipalName, Mail, AccountEnabled

# Export to CSV
$userReport | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "User report generated successfully at: $outputFile"

