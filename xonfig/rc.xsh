from pygments.token import Token, Comment, Keyword, Name, String, Number, Operator, Punctuation
from xonsh.pyghooks import register_custom_pygments_style

$PATH.append($HOME + '/.local/bin')

register_custom_pygments_style(
    'tokyo-night-storm',
    {
        Token:              '#c0caf5',
        Comment:            'italic #565f89',
        Keyword:            '#bb9af7',
        Keyword.Constant:   '#ff9e64',
        Keyword.Namespace:  '#89ddff',
        Name.Builtin:       '#7dcfff',
        Name.Class:         '#7aa2f7',
        Name.Constant:      '#ff9e64',
        Name.Decorator:     '#7aa2f7',
        Name.Exception:     '#f7768e',
        Name.Function:      '#7aa2f7',
        Operator:           '#89ddff',
        Operator.Word:      '#bb9af7',
        Punctuation:        '#c0caf5',
        String:             '#9ece6a',
        Number:             '#ff9e64',
    },
    background_color='#1f2335',
    highlight_color='#292e42',
)
$XONSH_COLOR_STYLE = 'tokyo-night-storm'
$PROMPT = '{YELLOW}{env_name} {BOLD_GREEN}{cwd} {gitstatus}{RESET} {prompt_end} '
xontrib load coreutils
