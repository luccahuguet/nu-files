# ~/.config/nushell/my_config.nu

# Import standard library
use std *

# Initialize starship prompt
starship init nu | save -f ~/.config/nushell/scripts/init.nu
use scripts/init.nu

# Source all script modules
source scripts/my_config_extras.nu
source scripts/mise.nu
source scripts/aliases.nu
source scripts/.zoxide.nu
source scripts/print_cool_quote.nu
use scripts/ssh.nu *
use scripts/cargo_utils.nu *
use scripts/personal_utils.nu *

use scripts/ctx/house.nu *
use scripts/ctx/me.nu *
use scripts/ctx/goals.nu *

source scripts/timer.nu

# use ~/pjs/personal/dynu/dynu.nu
# use ~/pjs/personal/nutask/task.nu

# Initialize SSH agent on startup
setup-ssh-agent
