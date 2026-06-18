<# Vibecoded Script... #>

$ProjectPath = $PSScriptRoot
$SRC = Join-Path $ProjectPath "src"
$ICO = Join-Path $ProjectPath "ico"

if (-not (Test-Path $SRC)) {
    Write-Error "» Source Folder not found."
    exit 1
}

if (-not (Test-Path $ICO)) {
    New-Item -ItemType Directory -Path $ICO | Out-Null
}

$pngs = Get-ChildItem -Path $SRC -Recurse -Filter "*.png"

if ($pngs.Count -eq 0) {
    Write-Host "» Source Folder is empty"
    exit 0
}

Write-Host "» Convert $($pngs.count) Files..."

foreach ($file in $pngs) {
    $rel = $file.DirectoryName.Substring($SRC.Length).TrimStart('\', '/')
    $outDir = if ($rel) { Join-Path $ICO $rel } else { $ICO }

    if (-not (Test-Path $outDir)) {
        New-Item -ItemType Directory -Path $outDir | Out-Null
    }

    $outFile = Join-Path $outDir "$($file.BaseName).ico"

    magick "$($file.FullName)" -filter point -resize 48x48! -filter point -resize 480x480! "$outFile"

    Write-Host "OK: $($file.Name) -> $outFile"
}

Write-Host "» Done."