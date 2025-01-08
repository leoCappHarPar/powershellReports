# Connect to Microsoft Graph
Connect-MgGraph -Scopes "RoleManagement.Read.Directory"

# Define the Global Administrator Role ID
$globalAdminRoleId = "62e90394-69f5-4237-9190-012177145e10"

# Get all members assigned to the Global Administrator role
$globalAdmins = Get-MgRoleManagementDirectoryRoleAssignment -Filter "RoleDefinitionId eq '$globalAdminRoleId'" | ForEach-Object {
    Get-MgUser -UserId $_.PrincipalId
}

# Define the output file path
$outputFile = "C:\Reports\Global_Admin_Report.csv"

# Select relevant properties
$adminReport = $globalAdmins | Select-Object DisplayName, UserPrincipalName, Mail

# Export the data to a CSV file
$adminReport | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "Global Admin report generated successfully at: $outputFile"