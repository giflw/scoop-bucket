foreach ($app in (scoop list 6>$null)) {
    Write-Host "Cheking $($app.Name) manifest"
    $prefix = scoop prefix $app.Name
    $path = Convert-Path "$prefix\install.json"
    $in = Get-Content $path -Raw | ConvertFrom-Json
    if ($in.bucket -ne 'giflw') {
        $in.bucket = 'giflw'
        ConvertTo-Json $in | Set-Content -Path $path -Encoding Ascii
        Write-Host "    New install.json: $in"
    } else {
        Write-Output '    No changes made'
    }
    Write-Host
}
