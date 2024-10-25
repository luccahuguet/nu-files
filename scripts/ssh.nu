# ~/.config/nushell/scripts/ssh.nu

# SSH agent setup with error handling
export def setup-ssh-agent [] {
    let agent_output = (ssh-agent -c | lines | first 2)
    if ($agent_output | is-empty) {
        echo "Failed to start ssh-agent"
        return
    }
    $agent_output | parse "setenv {name} {value};" | transpose -i -r -d | load-env
    ssh-add ~/.ssh/id_ed25519 out+err> /dev/null
}
