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
    # Kanagawa "wave" colours, matching starship.toml. eza reads these for its
    # own columns (file types, permissions, size, owner, dates, git).
    # 24-bit codes are 38;2;R;G;B; palette: green=118;148;106 yellow=192;163;110
    # red=195;64;67 blue=126;156;216 cyan=106;149;137 magenta=149;127;184
    # orange=255;160;102 grey=114;113;105 fg=220;215;186.
    $env:EZA_COLORS = @(
        'di=38;2;126;156;216'      # directory        -> blue
        'ln=38;2;106;149;137'      # symlink          -> cyan
        'ex=1;38;2;118;148;106'    # executable       -> bold green
        'pi=38;2;255;160;102'      # fifo             -> orange
        'so=38;2;149;127;184'      # socket           -> magenta
        'bd=38;2;192;163;110'      # block device     -> yellow
        'cd=38;2;192;163;110'      # char device      -> yellow
        'or=1;38;2;195;64;67'      # orphaned symlink -> bold red
        'ur=38;2;192;163;110'      # user  read       -> yellow
        'uw=38;2;195;64;67'        # user  write      -> red
        'ux=38;2;118;148;106'      # user  exec       -> green
        'ue=38;2;118;148;106'      # user  exec (uid) -> green
        'gr=38;2;192;163;110'      # group read       -> yellow
        'gw=38;2;195;64;67'        # group write      -> red
        'gx=38;2;118;148;106'      # group exec       -> green
        'tr=38;2;192;163;110'      # other read       -> yellow
        'tw=38;2;195;64;67'        # other write      -> red
        'tx=38;2;118;148;106'      # other exec       -> green
        'su=38;2;255;160;102'      # setuid           -> orange
        'sf=38;2;255;160;102'      # setgid           -> orange
        'xa=38;2;114;113;105'      # extended attr @  -> grey
        'sn=38;2;106;149;137'      # size number      -> cyan
        'sb=38;2;106;149;137'      # size unit        -> cyan
        'uu=38;2;118;148;106'      # owner (you)      -> green
        'un=38;2;114;113;105'      # owner (other)    -> grey
        'gu=38;2;118;148;106'      # group (yours)    -> green
        'gn=38;2;114;113;105'      # group (other)    -> grey
        'lc=38;2;114;113;105'      # link count       -> grey
        'da=38;2;114;113;105'      # date/time        -> grey
        'xx=38;2;114;113;105'      # punctuation (-)  -> grey
        'hd=1;38;2;220;215;186'    # header row       -> bold fg
        'ga=38;2;118;148;106'      # git new          -> green
        'gm=38;2;192;163;110'      # git modified     -> yellow
        'gd=38;2;195;64;67'        # git deleted      -> red
        'gv=38;2;149;127;184'      # git renamed      -> magenta
        'gt=38;2;106;149;137'      # git type change  -> cyan
        'gi=38;2;114;113;105'      # git ignored      -> grey
        'gc=38;2;195;64;67'        # git conflicted   -> red
    ) -join ':'

    Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    function ls { eza --icons -a --group-directories-first @args }
    function ll { eza --icons -la --group-directories-first @args }
}

# Prompt + Kanagawa theming, shared with every other shell via starship.toml
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
