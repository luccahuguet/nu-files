# ~/.config/nushell/scripts/aliases.nu

# Zellij-related aliases
export alias ze = zellij edit
export alias za = zellij action
export alias zr = zellij run
export alias zp = zellij plugin

def cursor [] {
    ^bash -c "nohup ~/UserPrograms/cursor.AppImage >/dev/null 2>&1 &"
}

