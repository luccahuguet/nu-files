use ~/.config/nushell/scripts/helper.nu apply_color

def title [str] { (apply_color "yellow" $"\n($str)" ) }
def sub [str] { (apply_color "yellow" $"- ($str)")}

let quotes = [
    ["The best way to predict the future is to invent it.", "Alan Kay"]
    ["The journey of a thousand miles begins with one step.", "Lao Tzu"]
    ["When something is important enough, you do it even if the odds are not in your favor.", "Elon Musk"]
    ["Life needs to be more than just solving problems every day. You need to wake up and be excited about the future.", "Elon Musk"]
]

def get_quote [quotes] {
    let last_n = ($quotes | length) - 1    
    let random_index = random int 0..($last_n)
    let quote = $quotes | get $random_index
    let title = title $quote.0
    let sub = sub $quote.1
    return [
        [title, sub];
        [$title, $sub]
    ]
}

def print_goals [] {
    let quote = get_quote $quotes
    print ($quote.title | first) 
    print ($quote.sub | first)
}

print_goals
