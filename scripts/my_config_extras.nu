use "~/user_installs/nu_scripts/modules/system" *

# Load secrets
source $'($nu.default-config-dir)/secrets.nu'

def ght [] {
    $env.GITHUB_API_KEY | clip --silent --no-notify
}

def ghte [] {
    $env.GITHUB_TOKEN_ELFO | clip --silent --no-notify
}

mise use java@temurin-11
mise use node@16.14.0
mise use yarn@1.22.19

