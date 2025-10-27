
# Load secrets
source $'($nu.default-config-dir)/secrets.nu'

def set_evoclinica_versions [] {
    mise use java@temurin-11
    mise use node@16.14.0
    mise use yarn@1.22.19
    mise use npm:npm@8.3.1
}

# Corrected pg function (v4, definitive)
export def pg [
    query: string, # The SQL query to execute
    --raw          # If set, return raw, unparsed output from psql
] {
    if $raw {
        psql -U postgres -d evoclinica -h localhost -t -A -F"|" -c $query
    } else {
        try {
            # 1. Aggressively clean the query string in one pipeline:
            #    - Replace newlines with spaces.
            #    - Replace all semicolons with nothing.
            #    - Trim any leading/trailing whitespace.
            let clean_query = ($query | str replace --all "\n" " " | str replace --all ";" "" | str trim)

            # 2. Construct the final command using explicit string concatenation (++)
            #    This is the most important fix to ensure the parentheses are included.
            # let copy_command = "\\copy (" ++ $clean_query ++ ") TO STDOUT WITH CSV HEADER"
            let copy_command = "\\copy (" ++ $clean_query ++ ") TO STDOUT"

            # You can leave this debug line in or comment it out. It's helpful.
            # print $"DEBUG: Final psql command string: ($copy_command)"

            # 3. Execute the command.
            psql -U postgres -d evoclinica -h localhost -c $copy_command | from csv
        } catch {
            # Fallback logic remains the same.
            print "Info: \\copy command failed. Falling back to separator parsing."
            let separators = ["|", "~", "^", ";"]
            for sep in $separators {
                try {
                    print $"Trying separator: ($sep)"
                    let result = (psql -U postgres -d evoclinica -h localhost -t -A -F$sep -c $query | from csv --separator $sep)

                    if ($result | length) > 0 {
                        let column_count = ($result | columns | length)
                        print $"Success with separator: ($sep), parsed ($column_count) columns"
                        return $result
                    } else {
                        error make { msg: "Parsed an empty table" }
                    }
                } catch {
                    print $"Failed with separator: ($sep)"
                    continue
                }
            }
            error make {msg: "Failed to parse with \\copy or any separator. Check data for special characters or query syntax."}
        }
    }
}

# Checks the distribution of separator characters in CSV files to help identify inconsistencies.
export def check_csv [
    separator: string = "," # The character used to separate columns in the CSV
    file?: string           # (Optional) The specific CSV file to check. If not provided, checks all .csv files in the directory.
] {
    # Determine which files to process: either the provided file or all .csv files
    let files = if ($file != null) { [$file] } else { (ls *.csv | get name) }
    $files | each { |file|
        # Read the file, split each line by the separator, and count the number of separators per line
        let result = (
            open $file --raw
            | lines
            | enumerate
            | each { |it|
                # Count how many times the separator appears in this line
                ($it.item | split chars | where $it == $separator | length)
            }
            | histogram # Summarize the distribution of separator counts
        )
        # Print results only if there is more than one unique separator count (indicating possible inconsistencies)
        if ($result | length) > 1 {
            print $"=== ($file) ==="
            print $result
            print ""
        }
    }
}

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

export def "from mdtable" []: string -> table {
  let lines = $in | lines

  # Validate input has minimum required lines (header + separator)
  if ($lines | length) < 2 {
    error make {msg: "Invalid markdown table: requires at least header and separator rows"}
  }

  # Extract and clean column headers
  let headers = (
    $lines
    | get 0
    | split row '|'
    | slice 1..-2         # Remove leading and trailing empty cells
    | each { str trim }   # Clean whitespace from headers
  )

  # Validate headers were found
  if ($headers | is-empty) {
    error make {msg: "No column headers found in markdown table"}
  }

  # Parse data rows manually (skip header row 0 and separator row 1)
  $lines
  | skip 2
  | each { |line|
      # Split the line by pipe and extract cells
      let cells = (
        $line
        | split row '|'
        | slice 1..-2       # Remove leading and trailing empty cells
        | each { str trim } # Trim each cell value
      )

      # Create a record by zipping headers with cell values
      $headers
      | enumerate
      | reduce -f {} { |it, acc|
          let value = if $it.index < ($cells | length) {
            $cells | get $it.index
          } else {
            ""  # Use empty string if cell is missing
          }
          $acc | insert $it.item $value
        }
    }
}


export def mdfmt [
    file: string    # Path to markdown table file to format
    --in-place (-i) # Modify file in place (default: print to stdout)
    --pretty (-p)
] {
    # Validate file exists
    if not ($file | path exists) {
        error make {msg: $"File not found: ($file)"}
    }

    # Read, parse, and reformat the markdown table
    let formatted = if $pretty {
        open $file | from mdtable | to md --pretty
    } else {
        open $file | from mdtable | to md
    }

    # Either save in place or print to stdout
    if $in_place {
        $formatted | save -f $file
        print $"Formatted ($file)"
    } else {
        print $formatted
    }
}
