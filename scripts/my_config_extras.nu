
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
            let copy_command = "\\copy (" ++ $clean_query ++ ") TO STDOUT WITH CSV HEADER"

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
