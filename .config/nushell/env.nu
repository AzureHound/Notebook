# Env
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.buffer_editor = "nvim"

# Carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash'
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# Time

# Prompt
$env.PROMPT_COMMAND_RIGHT = {||}
$env.PROMPT_INDICATOR_VI_INSERT = " ➜ "
$env.PROMPT_INDICATOR_VI_NORMAL = " : "
$env.PROMPT_MULTILINE_INDICATOR = " ❯ "

# Transient Prompt
$env.TRANSIENT_PROMPT_COMMAND = " ➜ "
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = null
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = " ❯ "
$env.TRANSIENT_PROMPT_INDICATOR = ""
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = ""
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = ""

# Cursor
$env.config.cursor_shape = {
        vi_insert: blink_line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
}

# vivid
$env.LS_COLORS = (vivid generate catppuccin-macchiato)
