# ~/.config/nushell/scripts/aliases.nu

module aliases {
    # Zellij-related aliases
    export alias ze = zellij edit
    export alias za = zellij action
    export alias zr = zellij run
    export alias zp = zellij plugin

    # Cargo-related aliases
    export alias ciu = cargo install-update
}
