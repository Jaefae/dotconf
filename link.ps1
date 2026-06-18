# Windows symlink creator
# Run as Administrator

$DOTFILES_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$HOME_DIR = $env:USERPROFILE

# Define symlinks as: @{source = "target"}
# source is relative to DOTFILES_DIR, target is relative to USERPROFILE
$SYMLINKS = @{
    "nvim"    = "$HOME_DIR\AppData\Local\nvim"
    "wezterm" = "$HOME_DIR\AppData\Local\wezterm"
    "nushell" = "$HOME_DIR\AppData\Local\nushell"
}

Write-Host "Creating symlinks in $HOME_DIR..." -ForegroundColor Cyan

foreach ($source in $SYMLINKS.Keys) {
    $target = $SYMLINKS[$source]
    $sourcePath = Join-Path $DOTFILES_DIR $source

    if (-not (Test-Path $sourcePath)) {
        Write-Host "⚠ Skipping $source (not found)" -ForegroundColor Yellow
        continue
    }

    # Create parent directory if needed
    $targetParent = Split-Path -Parent $target
    if (-not (Test-Path $targetParent)) {
        New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    }

    # Remove existing file/symlink and overwrite
    if (Test-Path $target -PathType Any) {
        Write-Host "Removing existing file: $target" -ForegroundColor Yellow
        Remove-Item $target -Force -Recurse
    }

    Write-Host "Linking: $sourcePath → $target" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $target -Target $sourcePath -Force | Out-Null
}

Write-Host "Done!" -ForegroundColor Green
