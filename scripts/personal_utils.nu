# ~/.config/nushell/scripts/system_utils.nu

# USB device listing with formatted output
export def nu_usb [] {
    lsusb | 
    lines | 
    parse --regex 'Bus (?P<bus>\d{3}) Device (?P<device>\d{3}): ID (?P<id>[0-9a-f]{4}:[0-9a-f]{4}) (?P<name>.+)'
}

# System version information fetcher
export def print_yazelix_versions [] {
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
        [Ghostty (ghostty +version | lines | first | split row ' ' | get 1)]
    ] 
    
    $versions | to md --pretty | clip
}

export def print_evo_versions [] {
    let programs = [
        {name: 'Node.js', cmd: 'node --version'},
        {name: 'npm', cmd: 'npm --version'},
        {name: 'Maven', cmd: 'mvn --version | lines | first'},
        {name: 'Java', cmd: 'java --version | lines | first | str split " " | get 1'},
        {name: 'Yarn', cmd: 'yarn --version'}
    ]

    for program in $programs {
        let version = match $program.name {
            'Node.js' => (node --version | str trim),
            'npm' => (npm --version | str trim),
            'Maven' => (mvn --version | lines | first | str trim),
            'Java' => (java --version | lines | first | str trim),
            'Yarn' => (yarn --version | str trim)
        }

        print $"($program.name) Version: ($version)"
    }
}

export def bp_calc [eating_score: int, sleeping_score: int, fitness_score: int] {
    let total = $eating_score + $sleeping_score + $fitness_score
    let average = ($total / 3) | math round
    $"Average health score: ($average)"
}

export def evoclip [] {
    open ~/Downloads/evotable/table.csv | to md | clip
}

export def json_from_col [$this_col] {
    parse "json::{obj}" | get obj | each {from json} | where ($this_col in ($it | columns)) | get $this_col

}
