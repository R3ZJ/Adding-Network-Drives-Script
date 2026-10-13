# NAS settings
$storagedevicename = "ctecservicesnas"
$_username = "" #Put Username here
$username = "$storagedevicename\$_username"

# Prompt for NAS password securely
$securePassword = Read-Host "Password:" -AsSecureString
$credential = New-Object System.Management.Automation.PSCredential(
    $username, $securePassword
)

# Convert SecureString for net use
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)

try {
    $password = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)

    # Drive letter to share mappings
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

    foreach ($driveletter in $drivemappings.Keys) {
        $folder = $drivemappings[$driveletter]
        $networkPath = "\\$storagedevicename\$folder"

        Write-Host "`nProcessing ${driveletter}: -> $networkPath"

        # Remove existing mapping if present
        & net.exe use "${driveletter}:" /delete /y 2>$null | Out-Null

        # Create persistent mapping
        $output = & net.exe use "${driveletter}:" "$networkPath" `
            "/user:$username" $password /persistent:yes 2>&1

        if ($LASTEXITCODE -eq 0) {
            Write-Host "Successfully mapped ${driveletter}:" -ForegroundColor Green
        }
        else {
            Write-Warning "Failed to map ${driveletter}:"
            $output | ForEach-Object { Write-Host $_ }
        }
    }
}
finally {
    if ($bstr -ne [IntPtr]::Zero) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
    }

    $password = $null
    $securePassword = $null
}

Write-Host "`nCurrent network mappings:"
& net.exe use