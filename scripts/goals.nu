# goals.nu
use ~/data/ctx/data.nu *

# Check if dependencies are met for a goal
def check_dependencies [goal] {
  let dependencies = $goal | get depends_on?
  if ($dependencies | is-empty) {
    return true
  }

  $dependencies | all { |dep|
    let parent_goal = ($me.goals | find id $dep | first)
    $parent_goal.status == "done"
  }
}

# Format a goal for display
def format_goal [goal] {
  let emoji = ($status_emoji | get $goal.status)
  let dependency_status = if ($goal | get depends_on? | is-empty) {
    ""
  } else if (check_dependencies $goal) {
    " (Ready to Start)"
  } else {
    " (Blocked by: " + ($goal.depends_on | str join ", ") + ")"
  }
  let status_color = if (check_dependencies $goal) {
    $colors.content
  } else {
    $colors.blocked
  }
  let color = match $goal.status {
    "done" => $colors.done,
    "in progress" => $colors.in_progress,
    _ => $status_color
  }
  apply_color $color $"($emoji) ($goal.goal)($dependency_status)"
}

# Main entrypoint for the goals module
export def main [] {
  print_header "🎯 Goals"
  
  $me.goals | each { |goal|
    print (apply_color $colors.content $"-  (format_goal $goal)")
  }
  print ""
}
