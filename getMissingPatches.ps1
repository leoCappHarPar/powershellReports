# Connect to Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

# Define the output file path
$outputFile = "C:\Reports\Intune_Missing_Windows_Patches.csv"

# Ensure the output directory exists
$outputDir = Split-Path -Path $outputFile
if (-not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force
}

# Retrieve all managed devices with patch compliance information
$devices = Get-MgDeviceManagementManagedDevice -All -Property DeviceName, ComplianceState, OperatingSystem, OsVersion, WindowsProtectionState

# Filter devices with missing patches or non-compliant states
$patchReport = $devices | Where-Object {
    $_.WindowsProtectionState.DeviceHealthReportLevel -eq "NonCompliant"
} | Select-Object DeviceName, OperatingSystem, OsVersion, @{Name="MissingUpdates"; Expression={$_.WindowsProtectionState.PatchStatusSummary.MissingCount}}

# Export to CSV
$patchReport | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "Missing patches report generated successfully at: $outputFile"