# me.nu
use ~/pjs/personal/dynu/dynu.nu *
use ~/data/ctx/data.nu *

export def main [] {
    print_header "👤 Me"
    set_current_table "me"
    ls_elms --show
}