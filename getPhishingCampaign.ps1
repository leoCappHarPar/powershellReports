# Import the necessary module for Excel export
if (-not (Get-Module -Name ImportExcel -ListAvailable)) {
    Install-Module -Name ImportExcel -Force -Scope CurrentUser
}
Import-Module ImportExcel

# API Configuration
$apiUrl = "https://api.caniphish.com/api/v2/reporting/phishing/get-all-campaigns"
$apiKey = "7ae9fd10-0a5e-4c26-b148-dcfb584dd8f2"
$emailAddress = "leo.cappello@harvardpartners.com"
$tenantID = "702fe935-0047-4b89-8f06-8ec2f3ccd4ef"

# Headers for the API request
$headers = @{
    "accept" = "application/json"
    "content-type" = "application/json"
    "X-API-Key" = $apiKey
    "X-Email-Address" = $emailAddress
}

# Request body
$body = @{
    "tenantID" = $tenantID
} | ConvertTo-Json -Depth 10

# API Request with Debugging
try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method POST -Headers $headers -Body $body -ContentType 'application/json'
    Write-Host "Raw response received successfully."
} catch {
    Write-Error "Failed to retrieve data: $_"
    exit
}

# Check if ActiveCampaigns data exists
if ($response -and $response.ActiveCampaigns) {
    # Define the output Excel file path
    $outputFile = "C:\Reports\Phishing_Campaign_Report.xlsx"

    # Flatten the ActiveCampaigns data
    $campaigns = $response.ActiveCampaigns | ForEach-Object {
        [PSCustomObject]@{
            CampaignGUID         = $_.campaignGUID
            CampaignName         = $_.campaignName
            TargetCount          = $_.targetCount
            StartDate            = $_.startDate
            EndDate              = $_.endDate
            EmailsSent           = $_.emailStatus.emailsSent
            EmailsViewed         = $_.emailStatus.emailsViewed
            PayloadInteractions  = $_.emailStatus.payloadInteractions
            EmployeesCompromised = $_.emailStatus.employeesCompromised
            EmailsReported       = $_.emailStatus.emailsReported
            EmailsReplied        = $_.emailStatus.emailsReplied
        }
    }

    # Export the data to Excel
    $campaigns | Export-Excel -Path $outputFile -AutoSize -WorksheetName "Campaigns"

    Write-Host "Report generated successfully at: $outputFile"
} else {
    Write-Host "No campaign data found in the response."
}
