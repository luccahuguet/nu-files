# Load secrets
source $'($nu.default-config-dir)/secrets.nu'

# Environment variables
$env.CUDA_HOME = "/usr/lib/cuda-11.2"
$env.JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64"
$env.PNPM_HOME = $"($env.HOME)/Library/pnpm"
$env.MODULAR_HOME = $"($env.HOME)/.modular"
$env.ANDROID_HOME = $"($env.HOME)/Android/Sdk"
$env.ANDROID_SDK_ROOT = $env.ANDROID_HOME
$env.BUN_INSTALL = $"($env.HOME)/.bun"
$env.HANDLER = "openai"
$env.LOCAL_FILES_SERVING_ENABLED = 1
$env.LOCAL_FILES_DOCUMENT_ROOT = $"($env.HOME)/pjs/elfo/python/label_studio_pj"
$env.LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED = 1
$env.LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT = $"($env.HOME)/pjs/elfo/python/label_studio_pj"
$env.GTK_IM_MODULE = "cedilha"

# Custom paths
let hx_path = "user_installs/helix"

# Helix dependent paths
$env.EDITOR = $"($env.HOME)/($hx_path)/target/release/hx"
$env.HELIX_RUNTIME = $"($env.HOME)/($hx_path)/runtime"

# Path configuration
let static_paths = [
    '/nix/var/nix/profiles/default/bin',
    '/var/lib/flatpak/exports/bin',
    '/snap/bin',
    '/usr/bin/',
    '/usr/sbin/',
    '/usr/local/go/bin',
]

let dynamic_paths = [
    $"($env.HOME)/.nix-profile/bin",
    $"($env.HOME)/.cargo/bin",
    $"($env.HOME)/.local/bin",
    $"($env.HOME)/.cargo/env",
    $"($env.HOME)/($hx_path)",
    $"($env.JAVA_HOME)/bin",
    $"($env.CUDA_HOME)/bin",
    $env.PNPM_HOME,
    $"($env.MODULAR_HOME)/pkg/packages.modular.com_mojo/bin",
    $env.ANDROID_HOME,
    $"($env.ANDROID_HOME)/emulator",
    $"($env.ANDROID_HOME)/platform-tools",
    $"($env.BUN_INSTALL)/bin"
    # $"(/home/lucca/.pyenv/bin/pyenv root)/shims"
]

let all_paths = $static_paths ++ $dynamic_paths
$all_paths | each { |path| path add $path }

# CUDA configuration
# let cuda_lib_paths = [
#     "$env.CUDA_HOME/lib64",
#     "$env.CUDA_HOME/targets/x86_64-linux/lib",
#     "$env.CUDA_HOME/extras/CUPTI/lib64"
# ] | str join ':'

# $env.LD_LIBRARY_PATH = $cuda_lib_paths

# FNM (Fast Node Manager) configuration
# if not (which fnm | is-empty) {
#     ^fnm env --json | from json | load-env
#     let path = if 'Path' in $env { $env.Path } else { $env.PATH }
#     let node_path = if (sys host).name == 'Windows' {
#         $"($env.FNM_MULTISHELL_PATH)"
#     } else {
#         $"($env.FNM_MULTISHELL_PATH)/bin"
#     }
#     $env.PATH = ($path | prepend [$node_path])
# }

# SSH agent configuration
ssh-agent -c | lines | first 2 | parse "setenv {name} {value};" | transpose -i -r -d | load-env
ssh-add ~/.ssh/id_ed25519 out+err> /dev/null
