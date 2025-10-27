def docker_log [
    --tail: int = 100      # Number of lines to show from the end (default: 100)
] {
    # Get list of running containers
    let containers = (docker ps --format json
        | from json --objects 
        | select Names ID Image
        | insert display { |row| $"($row.Names) \(($row.Image)\)" })

    # Check if any containers are running
    if ($containers | is-empty) {
        error make {msg: "No running containers found"}
    }

    # Prompt user to select a container
    let selected_container = ($containers 
        | input list --fuzzy --display display "Select a container")

    # Check if selection was made (handles abort with esc or q)
    if ($selected_container | is-empty) {
        error make {msg: "No container selected"}
    }

    # Get the container ID from the selected container
    let container = ($selected_container | get ID)

    # Check if container ID is valid
    if ($container | is-empty) {
        error make {msg: "Failed to retrieve container ID"}
    }

    # Follow logs with specified tail
    docker logs -f --tail $tail $container
}