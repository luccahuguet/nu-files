
use std *

alias ciu = cargo install-update
alias ze = zellij edit
alias za = zellij action
alias zr = zellij run
alias zp = zellij plugin

# source ~/.config/nushell/scripts/mise.nu
# source ~/.config/nushell/scripts/.zoxide.nu
source ~/.config/nushell/scripts/on_startup.nu

# use ~/pjs/nu/dynu/dynu.nu
use "~/user_installs/nu_scripts/modules/system" *
# use "~/user_installs/nu_scripts/modules/docker/docker.nu" *

# mkdir ~/.cache/starship
# starship init nu | save ~/.cache/starship/init.nu -f
# use ~/.cache/starship/init.nu

def nu_usb [] {
    lsusb | 
    lines | 
    parse --regex 'Bus (?P<bus>\d{3}) Device (?P<device>\d{3}): ID (?P<id>[0-9a-f]{4}:[0-9a-f]{4}) (?P<name>.+)'
}


def ght [] {
    $env.GITHUB_API_KEY | clip --silent --no-notify
}


def lscargo [] {
    cargo install --list | lines | where ($it | str starts-with " ") == false | parse "{name} {ver}:"
}

def vfetch [] {
  let versions = [
      [Component Version];
      [OS $"(sys host | get name) (sys host | get os_version)"]
      [DE $"($env.XDG_CURRENT_DESKTOP | default 'Unknown')"]
      [Zellij (zellij --version | str trim | split row ' ' | last)]
      [Helix (hx --version | str trim)]
      [Nushell (version | get version)]
      [Zoxide (zoxide --version | str trim | split row ' ' | last)]
      [Yazi (yazi --version | str trim | split row ' ' | get 1)]
      [WezTerm (wezterm --version | str trim | split row ' ' | get 1)]
    ] 
    
    $versions | to md --pretty | clip
}
