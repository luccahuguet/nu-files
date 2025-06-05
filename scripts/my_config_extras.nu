
# Load secrets
source $'($nu.default-config-dir)/secrets.nu'

def set_evoclinica_versions [] {
    mise use java@temurin-11
    mise use node@16.14.0
    mise use yarn@1.22.19
}

