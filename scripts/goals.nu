# goals.nu
use ~/pjs/personal/dynu/dynu.nu *
use ~/data/ctx/data.nu *

export def main [] {
    print_header "🎯 Goals"
    set_current_table "goals"
    ls_elms --show
}
