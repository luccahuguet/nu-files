export def timer-file [] { $"($env.HOME)/.nu_data/timer" }

export def ensure-timer-dir [] {
    if not ($"($env.HOME)/.nu_data" | path exists) {
        mkdir $"($env.HOME)/.nu_data"
    }
}

export def "timer set" [name: string, hours?: float] {
    ensure-timer-dir
    let now = (date now | into int)
    let start_time = if $hours != null { $now - ($hours * 3_600_000_000_000) } else { $now }
    { name: $name, start: $start_time } | to json | save --raw -f (timer-file)
    echo $"Timer '($name)' set."
}
export def "timer ls" [] {
    let timer_file = (timer-file)
    if ($timer_file | path exists) {
        open $timer_file | from json | to json
    } else {
        echo "No timer set yet."
    }
}

export def "timer delete" [] {
    let timer_file = (timer-file)
    if ($timer_file | path exists) {
        rm $timer_file
        echo "Timer deleted."
    } else {
        echo "No timer to delete."
    }
}

export def main [] {
    help commands timer
}
main
