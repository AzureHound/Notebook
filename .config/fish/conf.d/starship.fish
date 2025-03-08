# Left prompt
function starship_transient_prompt_func
  starship module character
end

# Right prompt
function starship_transient_rprompt_func
  starship module time
end

# Initialize Starship for Fish shell.
starship init fish | source
enable_transience
