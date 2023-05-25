$workspace = Split-Path -Parent $PSScriptRoot
Write-Output "Workspace: ${workspace}"

$scoopPrefix = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent "$(scoop prefix *)"))
Write-Output "Scoop Prefix: ${scoopPrefix}"

foreach($app in (scoop list 2>$null 3>$null 4>$null 5>$null 6>$null)) {
    $name = "$($app.Name)"
    $bucket = "$($app.Source)"
    Write-Output "Installed app: ${bucket}/${name}"
    if (Test-Path -Path "${workspace}\bucket\${name}.json") {
        Write-Output "    Manifest exists."
    } else {
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
}
