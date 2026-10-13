$username = "" #Enter the username for the user here

$storagedevicename = "" #Change Storage Device Name
$nasprefix = "\\$storagedevicename\"
$drivemappings = [ordered]@{
M = "cTEC"
N = "Customers"
O = "BOM"
P = "Scans"
Q = "QuickBooks"
R = "Reference Materials"
S = "Software"
T = "SOP"
V = "Vendors"
X = "Calibration Forms"
}

$usernamecred = "$storagedevicename\$username"

$cred = New-Object System.Management.Automation.PSCredential($usernamecred, $password)

foreach ($driveletter in $drivemappings.Keys){
    $folder = $drivemappings[$driveletter]
    $networkPath = "\\$storagedevicename\$folder"
    Write-Host "Processing $driveLetter`: -> $networkPath"

    if (Get-PSDrive -Name $driveLetter -ErrorAction SilentlyContinue) {
         Write-Host "Removing existing mapping $driveLetter`:"

    & net.exe use "${driveLetter}:" /delete /y

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Failed to remove mapping ${driveLetter}:"
        continue
    }

        continue
    }
    try {
        New-PSDrive -Name $driveletter -PSProvider FileSystem -Root $networkPath -Credential $cred -Persist -ErrorAction Stop | Out-Null

        Write-Host "Successfully mapped $driveLetter`: " -ForegroundColor Green
    }
    catch {
    Write-Warning "Failed to map $driveLetter`: $($_.Exception.Message)"
    }

}
