# Install Microsoft Graph module if not installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    #Install-Module -Name Microsoft.Graph -Scope CurrentUser -Force
}

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "RoleManagement.Read.Directory"

# Define the Global Administrator Role ID
$globalAdminRoleId = "62e90394-69f5-4237-9190-012177145e10"

# Get all members assigned to the Global Administrator role
$globalAdmins = Get-MgRoleManagementDirectoryRoleAssignment -Filter "RoleDefinitionId eq '$globalAdminRoleId'" | ForEach-Object {
    Get-MgUser -UserId $_.PrincipalId -Property DisplayName, UserPrincipalName, Mail, AccountEnabled
}

# Filter for active users and ensure Mail and UserPrincipalName match
$filteredAdmins = $globalAdmins | Where-Object {
    $_.AccountEnabled -eq $true -and $_.Mail -eq $_.UserPrincipalName
}

# Define the output file path
$outputFile = "C:\Reports\Active_Global_Admin_Report.csv"

# Select relevant properties
$adminReport = $filteredAdmins | Select-Object DisplayName, UserPrincipalName, Mail

# Export the data to a CSV file
$adminReport | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "Global Admin report generated successfully at: $outputFile"