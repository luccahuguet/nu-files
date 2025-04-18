export def timer-file [] { $"($env.HOME)/.nu_data/timer" }


export def ensure-timer-dir [] {
    if not ($"($env.HOME)/.nu_data" | path exists) {
        mkdir $"($env.HOME)/.nu_data"
    }
}

export def migrate-timer-file [] {
    ensure-timer-dir
    let file = (timer-file)
    if not ($file | path exists) {
        echo "[]" | save --raw -f $file
    } else {
        let raw = (open $file --raw)
        if ($raw | str starts-with "{") {
            let trimmed = ($raw | str trim)
            let new_raw = $"[$trimmed]"
            print $new_raw | save --raw -f $file
        }
    }
}

export def "timer set" [name: string, hours?: float] {
    ensure-timer-dir
    migrate-timer-file
    let now = (date now | into int)
    let start_time = if $hours != null { $now - ($hours * 3_600_000_000_000) } else { $now }
    let file = (timer-file)
    let arr = if ($file | path exists) { open $file | from json } else { [] }
    let new = ($arr | append { name: $name, start: $start_time })
    $new | to json | save --raw -f $file
    print (apply_color "green" $"Timer '($name)' set.")
}
export def "timer ls" [] {
    migrate-timer-file
    let timer_file = (timer-file)
    if ($timer_file | path exists) {
        let arr = (open $timer_file | from json)
        if ($arr | length) == 0 {
            print (apply_color "yellow" "No timers set.")
        } else {
            for item in ($arr | enumerate) {
                let idx = ($item.index)
                let timer = ($item.item)
                let now = (date now | into int)
                let elapsed_ns = ($now - $timer.start)
                let total_hours = ($elapsed_ns // 3_600_000_000_000)
                let days = ($total_hours // 24)
                let hours = ($total_hours mod 24)
                print (
                    (apply_color "cyan" $"[($idx)]") + " " +
                    (apply_color "yellow" $"Timer '($timer.name)'") + ": " +
                    (apply_color "green" $"($days) days, ($hours) hours elapsed.")
                )
            }
        }
    } else {
        print (apply_color "yellow" "No timer set yet.")
    }
}

export def "timer rm" [idx: int] {
    migrate-timer-file
    let file = (timer-file)
    if not ($file | path exists) {
        print (apply_color "yellow" "No timers to delete.")
    } else {
        let arr = (open $file | from json)
        let len = ($arr | length)
        if ($idx < 0 or $idx >= $len) {
            print (apply_color "red" $"Invalid index: ($idx).")
        } else {
            let before = ($arr | first $idx)
            let after = ($arr | skip ($idx + 1))
            let new = (echo $before $after | flatten)
            $new | to json | save --raw -f $file
            print (apply_color "green" $"Deleted timer at index ($idx).")
        }
    }
}

