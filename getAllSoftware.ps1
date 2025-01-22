# Connect to Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementApps.Read.All"

# Define the output file path
$outputFile = "C:\Reports\Intune_Software_Report.csv"

# Ensure the output directory exists
$outputDir = Split-Path -Path $outputFile
if (-not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force
}

# Retrieve all applications from Intune
$apps = Get-MgDeviceAppManagementMobileApp -All -Property DisplayName, Publisher, IsFeatured, CreatedDateTime, LastModifiedDateTime

# Select relevant properties
$appReport = $apps | Select-Object DisplayName, Publisher, IsFeatured, CreatedDateTime, LastModifiedDateTime

# Export to CSV
$appReport | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "Intune software report generated successfully at: $outputFile"
