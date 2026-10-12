# PowerShell profile — Windows system shell.
# Replaces the old xonsh rc.xsh. PowerShell has native ls/cat/etc.

# Git's Unix tools (grep, sed, awk, less, ssh, ...) live in <git>\usr\bin, which
# the Git for Windows installer leaves OFF the PATH by default. Add it ourselves,
# derived from git's own location so this works on any machine. Appended (not
# prepended) so Windows' own find/sort keep priority over Git's shadowing copies.
$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if ($gitCmd) {
    $gitUsrBin = Join-Path (Split-Path (Split-Path $gitCmd.Source)) 'usr\bin'
    if ((Test-Path $gitUsrBin) -and ($env:PATH -notlike "*$gitUsrBin*")) {
        $env:PATH = "$env:PATH;$gitUsrBin"
    }
}

# ~/.local/bin on PATH (was: $PATH.append(...) in rc.xsh)
$localBin = Join-Path $HOME '.local\bin'
if ((Test-Path $localBin) -and ($env:PATH -notlike "*$localBin*")) {
    $env:PATH = "$localBin;$env:PATH"
}

# Rust toolchain (rustup/cargo/clippy) lives in ~/.cargo\bin. rustup usually adds
# this to the User PATH at install, but it can go missing; add it ourselves so
# cargo & friends resolve without depending on the installer's PATH edit.
$cargoBin = Join-Path $HOME '.cargo\bin'
if ((Test-Path $cargoBin) -and ($env:PATH -notlike "*$cargoBin*")) {
    $env:PATH = "$cargoBin;$env:PATH"
}

# winget's shims live in ~\AppData\Local\Microsoft\WinGet\Links. This can fall off
# the User PATH (e.g. a setx truncation), so re-add it here the same way as cargo.
$wingetLinks = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links'
if ((Test-Path $wingetLinks) -and ($env:PATH -notlike "*$wingetLinks*")) {
    $env:PATH = "$wingetLinks;$env:PATH"
}

# eza as a drop-in replacement for ls. `ls` is a built-in alias for
# Get-ChildItem, and aliases can't carry arguments, so remove it and define
# functions instead (@args forwards any extra flags/paths through to eza).
if (Get-Command eza -ErrorAction SilentlyContinue) {
    # Dracula colours, matching starship.toml. eza reads these for its own
    # columns (file types, permissions, size, owner, dates, git). 24-bit
    # codes are 38;2;R;G;B; palette:
    # green=80;250;123 yellow=241;250;140 red=255;85;85 blue(purple)=189;147;249
    # cyan=139;233;253 magenta=255;121;198 orange=255;184;108
    # grey(comment)=98;114;164 fg=248;248;242.
    $env:EZA_COLORS = @(
        'di=38;2;189;147;249'      # directory        -> blue (purple)
        'ln=38;2;139;233;253'      # symlink          -> cyan
        'ex=1;38;2;80;250;123'     # executable       -> bold green
        'pi=38;2;255;184;108'      # fifo             -> orange
        'so=38;2;255;121;198'      # socket           -> magenta
        'bd=38;2;241;250;140'      # block device     -> yellow
        'cd=38;2;241;250;140'      # char device      -> yellow
        'or=1;38;2;255;85;85'      # orphaned symlink -> bold red
        'ur=38;2;241;250;140'      # user  read       -> yellow
        'uw=38;2;255;85;85'        # user  write      -> red
        'ux=38;2;80;250;123'       # user  exec       -> green
        'ue=38;2;80;250;123'       # user  exec (uid) -> green
        'gr=38;2;241;250;140'      # group read       -> yellow
        'gw=38;2;255;85;85'        # group write      -> red
        'gx=38;2;80;250;123'       # group exec       -> green
        'tr=38;2;241;250;140'      # other read       -> yellow
        'tw=38;2;255;85;85'        # other write      -> red
        'tx=38;2;80;250;123'       # other exec       -> green
        'su=38;2;255;184;108'      # setuid           -> orange
        'sf=38;2;255;184;108'      # setgid           -> orange
        'xa=38;2;98;114;164'       # extended attr @  -> grey
        'sn=38;2;139;233;253'      # size number      -> cyan
        'sb=38;2;139;233;253'      # size unit        -> cyan
        'uu=38;2;80;250;123'       # owner (you)      -> green
        'un=38;2;98;114;164'       # owner (other)    -> grey
        'gu=38;2;80;250;123'       # group (yours)    -> green
        'gn=38;2;98;114;164'       # group (other)    -> grey
        'lc=38;2;98;114;164'       # link count       -> grey
        'da=38;2;98;114;164'       # date/time        -> grey
        'xx=38;2;98;114;164'       # punctuation (-)  -> grey
        'hd=1;38;2;248;248;242'    # header row       -> bold fg
        'ga=38;2;80;250;123'       # git new          -> green
        'gm=38;2;241;250;140'      # git modified     -> yellow
        'gd=38;2;255;85;85'        # git deleted      -> red
        'gv=38;2;255;121;198'      # git renamed      -> magenta
        'gt=38;2;139;233;253'      # git type change  -> cyan
        'gi=38;2;98;114;164'       # git ignored      -> grey
        'gc=38;2;255;85;85'        # git conflicted   -> red
    ) -join ':'

    Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    function ls { eza --icons -a --group-directories-first @args }
    function ll { eza --icons -la --group-directories-first @args }
}

# zoxide replaces cd with a frecency-based jumper (z/zi).
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Prompt + Dracula theming, shared with every other shell via starship.toml
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
