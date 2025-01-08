# Connect to Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

# Define the output file path
$outputFile = "C:\Reports\Intune_Hardware_Report.csv"

# Ensure the output directory exists
$outputDir = Split-Path -Path $outputFile
if (-not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force
}

# Retrieve all managed devices with valid properties
$devices = Get-MgDeviceManagementManagedDevice -All -Property DeviceName, OperatingSystem, OsVersion, Manufacturer, Model, SerialNumber, ComplianceState

# Select relevant properties
$deviceReport = $devices | Select-Object DeviceName, OperatingSystem, OsVersion, Manufacturer, Model, SerialNumber, ComplianceState

# Export to CSV
$deviceReport | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "Intune hardware report generated successfully at: $outputFile"