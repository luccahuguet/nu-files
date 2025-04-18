# house.nu
use ~/pjs/personal/dynu/dynu.nu *
use ~/data/ctx/data.nu *

export def main [] {
    print_header "🏠 House"
    set_current_table "house"
    ls_elms --show
}