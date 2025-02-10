$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install essentials
choco install neovim alacritty 7zip

# Install window manager
choco install komorebi whkd
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv
komorebic start --whkd --bar

# Symlink komorebi/whkd config
$files = @{
    "komorebi.json"     = "..\..\.config\komorebi\komorebi.json"
    "komorebi.bar.json" = "..\..\.config\komorebi\komorebi.bar.json"
    "whkdrc"            = "..\..\.config\whkd\whkdrc"
}
$homeConfigDir = Join-Path $HOME ".config"
if (!(Test-Path $homeConfigDir)) {
    New-Item -ItemType Directory -Path $homeConfigDir -Force | Out-Null
}

foreach ($fileName in $files.Keys) {
    $targetFile = Resolve-Path (Join-Path $scriptDir $files[$fileName]) -ErrorAction SilentlyContinue
    $symlinkPath = Join-Path $homeConfigDir $fileName

    if ($targetFile -and (Test-Path $targetFile)) {
        New-Item -ItemType SymbolicLink -Path $symlinkPath -Target $targetFile -Force | Out-Null
    } else {
        Write-Host "Target file does not exist: $targetFile"
    }
}

# Setup auto-start for komorebi
$komorebiShortcut = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\komorebi.lnk"
$komorebiPath = Get-Command komorebic-no-console.exe -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
$komorebiArgs = "start --whkd --bar"
if ($komorebiPath) {
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($komorebiShortcut)
    $shortcut.TargetPath = $komorebiPath
    $shortcut.Arguments = $komorebiArgs
    $shortcut.Save()
    Write-Host "Shortcut updated successfully: $komorebiShortcut -> $komorebiPath $komorebiArgs"
} else {
    Write-Host "Error: Could not find komorebic-no-console.exe on the system."
}

# End of script announcements
Write-Host "You must do the following manually:"
Write-Host "Go to 'Control Panel', search for 'animation' and disable animations"
Write-Host " "
