param (
    [switch]$buildDeps, # -buildDeps build deps
    [switch]$fullBuild, # -fullBuild
    [switch]$buildTest  # -buildTest only build code and zip single
)

$workingDir = Get-Location
$languageDirs = Get-ChildItem "$workingDir\assets\languages" -Directory

$packageJsonPath = "$workingDir\package.json"
$bootJsonPath = "$workingDir\boot.json"

# Load package and boot data
$packageData = Get-Content $packageJsonPath -Raw | ConvertFrom-Json
$pkgName = $packageData.name
$pkgVersion = $packageData.version

$bootData = Get-Content $bootJsonPath -Raw | ConvertFrom-Json
$bootData.version = $pkgVersion


# Function to handle dependencies (currently a placeholder)
function BuildDependencies {
    Write-Host "[Build] Building dependencies" -ForegroundColor Gray
    # Add dependency build logic here
}

# Function to handle zipping files
function CompressFiles($langCode, $zipFile, $itemsToZip) {
    Write-Host "[Build] Compressing items to $zipFile" -ForegroundColor Green
    foreach ($item in $itemsToZip) {
        Write-Output "  → $item"
    }
    Compress-Archive -Path $itemsToZip -DestinationPath $zipFile
    Write-Host ""
}

function CleanDist() {
    Remove-Item $workingDir\dist -Recurse -Force
    Write-Host "[clean] Cleanup dist" -ForegroundColor Yellow
}


# Function to clean up all .zip files in the dist directory
function CleanZipFiles {
    $zipFiles = Get-ChildItem "$workingDir\dist" -Filter "*.zip" -File
    if ($zipFiles.Count -gt 0) {
        Write-Host ""
        Write-Host "[Build] Cleaning up dist folder" -ForegroundColor Yellow
        foreach ($zip in $zipFiles) {
            Write-Host "[Clean] Removing $($zip.FullName)" -ForegroundColor Yellow
            Remove-Item $zip.FullName -Force
        }
        Write-Host ""
    }
}

function Build() {
    foreach ($langDir in $languageDirs) {
        $langFiles = Get-ChildItem $langDir

        if ($langFiles.Count -gt 0) {
            $langCode = $langDir.Name

            # Check if there are variants or just a single file
            if ($langFiles.Count -eq 1) {
                # Handle single file (no variants)
                $zipFile = "$workingDir\dist\$pkgName-$pkgVersion-$langCode.mod.zip"
                $itemsToZip = @(
                    "$workingDir\dist\dol-languages-mod",
                    "$workingDir\assets\img",
                    "$workingDir\boot.json",
                    "$workingDir\src\main.css",
                    $langFiles.FullName
                )
                CompressFiles $langCode $zipFile $itemsToZip
            }
            else {
                # Handle multiple files with variants
                foreach ($variant in $langFiles) {
                    if ($variant.Name -match '^translates\.(.+?)\.json$') {
                        $variantName = $matches[1]  # Extract variant (e.g., dolp)
                        $fileName = $variant.FullName
                        $zipFile = "$workingDir\dist\$pkgName-$pkgVersion-$langCode-$variantName.mod.zip"
                        $itemsToZip = @(
                            "$workingDir\dist\dol-languages-mod",
                            "$workingDir\assets\img",
                            "$workingDir\boot.json",
                            "$workingDir\src\main.css",
                            $fileName
                        )
                        if ($buildTest) {
                            Write-Host "Skip $itemsToZip"
                        }
                        else {
                            CompressFiles $langCode $zipFile $itemsToZip
                        }
                    }
                    else {
                        # Handle non-variant files
                        $fileName = $variant.FullName
                        $zipFile = "$workingDir\dist\$pkgName-$pkgVersion-$langCode.mod.zip"
                        $itemsToZip = @(
                            "$workingDir\dist\dol-languages-mod",
                            "$workingDir\assets\img",
                            "$workingDir\boot.json",
                            "$workingDir\src\main.css",
                            $fileName
                        )
                        CompressFiles $langCode $zipFile $itemsToZip
                    }
                }
            }
        }
    }
}

# entry
if ($buildDeps) {
    BuildDependencies
}

if ($buildTest) {
    Write-Host "[Build] Building test"
    CleanDist
    pnpm build
    Build
}

if ($fullBuild) {
    Write-Host "[Build] Building dol-languages-mod" -ForegroundColor Green
    CleanZipFiles
    CleanDist
    pnpm build
    Build
}
