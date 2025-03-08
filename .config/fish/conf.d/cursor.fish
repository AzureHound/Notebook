if status is-interactive
  set fish_cursor_default     line     blink
  set fish_cursor_insert      line     blink
  set fish_cursor_replace_one line     blink
  set fish_cursor_visual      line    blink

  function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
  end
end
