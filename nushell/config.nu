# Nushell configuration
# Cross-platform compatible for Windows and macOS

# === FIX FOR TERMINAL SCROLLING ISSUE ===
# Disable kitty protocol on Windows (causes unwanted scrolling)
# Enable it only on macOS with compatible terminals
let use_kitty = false

$env.config = {
  # Edit mode configuration
  edit_mode: vi

  # REPL rendering (fixes scrolling issues)
  use_kitty_protocol: $use_kitty

  # Buffer editor setup
  buffer_editor: "nvim"

  # Keybindings
  keybindings: [
    {
      name: quit_application
      modifier: alt
      keycode: f4
      mode: emacs
      event: { send: ctrlc }
    }
    {
      name: quit_application
      modifier: alt
      keycode: f4
      mode: vi_normal
      event: { send: ctrlc }
    }
  ]

  # History configuration
  history: {
    max_size: 100000
    sync_on_enter: true
    file_format: "sqlite"
    isolation: false
  }

  # Completion settings
  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
    external: {
      enable: true
      max_results: 100
      completer: null
    }
  }

  # Shell integration
  # Disable OSC 133 prompt markers: on WezTerm (Windows) they cause the
  # buffer to scroll up on every keypress. See nushell#13410 / wezterm#6175.
  shell_integration: {
    osc2: true
    osc7: true
    osc8: true
    osc9_9: false
    osc133: false
    osc633: false
    reset_application_mode: true
  }

  # Shell behavior
  show_banner: false
  display_errors: {
    exit_code: false
  }
}

# Aliases for common commands
alias ll = ls -la
alias la = ls -a
alias l = ls
alias cls = clear
alias cd.. = cd ..
alias ... = cd ../..
alias .... = cd ../../..

# Custom prompt
$env.PROMPT_COMMAND = {||
  let home = $nu.home-dir
  let dir = (pwd)
  let prompt_dir = if ($dir == $home) {
    "~"
  } else if ($dir | str starts-with $home) {
    "~" + ($dir | str substring ($home | str length)..)
  } else {
    $dir
  }

  $prompt_dir
}

$env.PROMPT_COMMAND_RIGHT = {|| "" }
$env.PROMPT_INDICATOR = { || "" }
$env.PROMPT_INDICATOR_VI_NORMAL = { || "" }
$env.PROMPT_INDICATOR_VI_INSERT = { || "" }
