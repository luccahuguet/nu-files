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
    let file = (timer-file)
    let arr = if ($file | path exists) { open $file | from json } else { [] }
    let new = ($arr + [{ name: $name, start: $start_time }])
    $new | to json | save --raw -f $file
    echo $"Timer '($name)' set."
}
export def "timer ls" [] {
    let timer_file = (timer-file)
    if ($timer_file | path exists) {
        let arr = (open $timer_file | from json)
        if ($arr | length) == 0 {
            echo "No timers set."
        } else {
            for [idx, timer] in ($arr | enumerate) {
                let now = (date now | into int)
                let elapsed_ns = ($now - $timer.start)
                let total_hours = ($elapsed_ns // 3_600_000_000_000)
                let days = ($total_hours // 24)
                let hours = ($total_hours mod 24)
                print $"[$idx] Timer '($timer.name)': ($days) days, ($hours) hours elapsed."
            }
        }
    } else {
        echo "No timer set yet."
    }
}

export def "timer del" [idx: int] {
    let file = (timer-file)
    if not ($file | path exists) {
        echo "No timers to delete."
    } else {
        let arr = (open $file | from json)
        let len = ($arr | length)
        if ($idx < 0 || $idx >= $len) {
            echo $"Invalid index: ($idx)."
        } else {
            let before = ($arr | first $idx)
            let after = ($arr | skip ($idx + 1))
            let new = ($before + $after)
            $new | to json | save --raw -f $file
            echo $"Deleted timer at index ($idx)."
        }
    }
}

export def main [] {
    timer ls
}
main
