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

export def "main" [] {
    let timer_file = (timer-file)
    if not ($timer_file | path exists) {
        echo "No timer set yet."
    } else {
        let timer = (open $timer_file | from json)
        let now = (date now | into int)
        let elapsed_ns = ($now - $timer.start)
        let total_hours = ($elapsed_ns // 3_600_000_000_000)  # Integer hours
        let days = ($total_hours // 24)                      # Whole days
        let hours = ($total_hours mod 24)                   # Whole hours (0-23)
        print $"\nTimer '($timer.name)': ($days) days, ($hours) hours elapsed."
    }
}

main
