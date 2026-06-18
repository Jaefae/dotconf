# Nushell environment configuration
# Cross-platform compatible

def --wrapped nu_main [
  ...rest
] {
  # Load environment variables and path setup
  if ($nu.os-info.name == "windows") {
    $env.PATHEXT = ".COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC"
  }
}

# LS command colors
$env.LS_COLORS = "di=1;34:ex=1;32:*.rs=1;31:*.toml=1;33"

# XDG Base Directory compliance
# $nu.default-config-dir is the nushell subdir (<root>/nushell), so XDG_CONFIG_HOME
# must be its parent — otherwise apps like nvim look under <root>/nushell/<app>.
let xdg_root = ($nu.default-config-dir | path dirname)
$env.XDG_CONFIG_HOME = $xdg_root
$env.XDG_DATA_HOME = ($xdg_root | path join "share")
$env.XDG_CACHE_HOME = ($xdg_root | path join "cache")

nu_main
