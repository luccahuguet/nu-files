# ~/.config/nushell/my_config.nu

# Import standard library
use std *

# Initialize starship prompt
starship init nu | save -f ~/.config/nushell/scripts/init.nu
use scripts/init.nu

# Source all script modules
use scripts/ssh.nu *
use scripts/cargo_utils.nu *
use scripts/system_utils.nu *
source scripts/mise.nu
source scripts/aliases.nu
source scripts/.zoxide.nu
source scripts/on_startup.nu
source scripts/my_config_extras.nu

# Initialize SSH agent on startup
setup-ssh-agent
