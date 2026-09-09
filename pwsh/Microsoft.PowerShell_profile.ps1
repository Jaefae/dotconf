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
    # Gruvbox colours (bright variants), matching starship.toml. eza reads
    # these for its own columns (file types, permissions, size, owner,
    # dates, git). 24-bit codes are 38;2;R;G;B; palette:
    # green=184;187;38 yellow=250;189;47 red=251;73;52 blue=131;165;152
    # cyan(aqua)=142;192;124 magenta(purple)=211;134;155 orange=254;128;25
    # grey=146;131;116 fg=235;219;178.
    $env:EZA_COLORS = @(
        'di=38;2;131;165;152'      # directory        -> blue
        'ln=38;2;142;192;124'      # symlink          -> cyan
        'ex=1;38;2;184;187;38'     # executable       -> bold green
        'pi=38;2;254;128;25'       # fifo             -> orange
        'so=38;2;211;134;155'      # socket           -> magenta
        'bd=38;2;250;189;47'       # block device     -> yellow
        'cd=38;2;250;189;47'       # char device      -> yellow
        'or=1;38;2;251;73;52'      # orphaned symlink -> bold red
        'ur=38;2;250;189;47'       # user  read       -> yellow
        'uw=38;2;251;73;52'        # user  write      -> red
        'ux=38;2;184;187;38'       # user  exec       -> green
        'ue=38;2;184;187;38'       # user  exec (uid) -> green
        'gr=38;2;250;189;47'       # group read       -> yellow
        'gw=38;2;251;73;52'        # group write      -> red
        'gx=38;2;184;187;38'       # group exec       -> green
        'tr=38;2;250;189;47'       # other read       -> yellow
        'tw=38;2;251;73;52'        # other write      -> red
        'tx=38;2;184;187;38'       # other exec       -> green
        'su=38;2;254;128;25'       # setuid           -> orange
        'sf=38;2;254;128;25'       # setgid           -> orange
        'xa=38;2;146;131;116'      # extended attr @  -> grey
        'sn=38;2;142;192;124'      # size number      -> cyan
        'sb=38;2;142;192;124'      # size unit        -> cyan
        'uu=38;2;184;187;38'       # owner (you)      -> green
        'un=38;2;146;131;116'      # owner (other)    -> grey
        'gu=38;2;184;187;38'       # group (yours)    -> green
        'gn=38;2;146;131;116'      # group (other)    -> grey
        'lc=38;2;146;131;116'      # link count       -> grey
        'da=38;2;146;131;116'      # date/time        -> grey
        'xx=38;2;146;131;116'      # punctuation (-)  -> grey
        'hd=1;38;2;235;219;178'    # header row       -> bold fg
        'ga=38;2;184;187;38'       # git new          -> green
        'gm=38;2;250;189;47'       # git modified     -> yellow
        'gd=38;2;251;73;52'        # git deleted      -> red
        'gv=38;2;211;134;155'      # git renamed      -> magenta
        'gt=38;2;142;192;124'      # git type change  -> cyan
        'gi=38;2;146;131;116'      # git ignored      -> grey
        'gc=38;2;251;73;52'        # git conflicted   -> red
    ) -join ':'

    Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    function ls { eza --icons -a --group-directories-first @args }
    function ll { eza --icons -la --group-directories-first @args }
}

# Prompt + Gruvbox theming, shared with every other shell via starship.toml
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
