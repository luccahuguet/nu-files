# ~/.config/nushell/scripts/system_utils.nu

# USB device listing with formatted output
export def nu_usb [] {
    lsusb | 
    lines | 
    parse --regex 'Bus (?P<bus>\d{3}) Device (?P<device>\d{3}): ID (?P<id>[0-9a-f]{4}:[0-9a-f]{4}) (?P<name>.+)'
}

# System version information fetcher
export def yazelix_versions [] {
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
