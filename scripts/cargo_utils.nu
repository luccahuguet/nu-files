# ~/.config/nushell/scripts/cargo_utils.nu

# List installed cargo packages
export def lscargo [] {
    cargo install --list | 
    lines | 
    where ($it | str starts-with " ") == false | 
    parse "{name} {ver}:"
}

# Update all installed cargo packages
export def upcargo [] {
    cargo install --list
    | parse "{package} v{version}:"
    | get package
    | each {|p| cargo install $p}   
}
