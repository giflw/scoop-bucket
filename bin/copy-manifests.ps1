$workspace = Split-Path -Parent $PSScriptRoot
Write-Output "Workspace: ${workspace}"

$scoopPrefix = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent "$(scoop prefix *)"))
Write-Output "Scoop Prefix: ${scoopPrefix}"

Write-Output "=========================================="
Write-Output "Copying installed manifests even if exists"
Write-Output "=========================================="

foreach ($app in (scoop list 2>$null 3>$null 4>$null 5>$null 6>$null)) {
    $name = "$($app.Name)"
    $bucket = "$($app.Source)"
    Write-Output "Installed app: ${bucket}/${name}"
    Write-Output "    Copying manifest..."
    $manifest = "${scoopPrefix}\buckets\${bucket}\bucket\${name}.json"
    if (Test-Path -Path "${manifest}") {
        Copy-Item -Path "${manifest}" -Destination "${workspace}\bucket\${app.json}"
    } else {
        Write-Output "    Error: manifest file not found!"
        Write-Output "        ${manifest}"
        Write-Output "        Name: '${name}'    Bucket: '${bucket}'"
    }
}


Write-Output "============================================="
Write-Output "Copying manifests from buckets if exists here"
Write-Output "============================================="

$bucketsDir = (Resolve-Path "$(scoop prefix scoop)/../../../buckets")
foreach ($app in (Get-ChildItem "$workspace/bucket")) {
    foreach ($bucket in ("main", "extras", "versions", "nerd-fonts")) {
        $name = "$($app.Name.Split(".")[0])"
        Write-Output "Bucketed manifest: ${bucket}/${name}"
        $manifest = "${bucketsDir}\${bucket}\bucket\${name}.json"
        #Write-Output "    ${manifest}"
        if (Test-Path -Path "${manifest}") {
            Write-Output "    Copying manifest..."
            Copy-Item -Path "${manifest}" -Destination "${workspace}\bucket\${name}.json"
        }
    }
}
