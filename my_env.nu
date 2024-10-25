
# Environment variables
$env.CUDA_HOME = "/usr/lib/cuda-11.2"
# $env.JAVA_HOME = "/usr/lib/jvm/jdk-11.0.25+9"
$env.PNPM_HOME = $"($env.HOME)/Library/pnpm"
$env.MODULAR_HOME = $"($env.HOME)/.modular"
$env.ANDROID_HOME = $"($env.HOME)/Android/Sdk"
$env.ANDROID_SDK_ROOT = $env.ANDROID_HOME
$env.BUN_INSTALL = $"($env.HOME)/.bun"
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
    $"($env.HOME)/.deno/bin",
    $"($env.HOME)/user_installs/apache-maven/bin",
    $"($env.HOME)/($hx_path)",
    # $"($env.JAVA_HOME)/bin",
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

$env.PATH = ($env.PATH | split row (char esep) | prepend $all_paths)

# CUDA configuration
# let cuda_lib_paths = [
#     "$env.CUDA_HOME/lib64",
#     "$env.CUDA_HOME/targets/x86_64-linux/lib",
#     "$env.CUDA_HOME/extras/CUPTI/lib64"
# ] | str join ':'

# $env.LD_LIBRARY_PATH = $cuda_lib_paths

#
