# cmd_scripts

A collection of Windows command-line (`.bat`) scripts for common developer tasks.

## Scripts

### `update_all_git_repos.bat`

Iterates over every subdirectory in a configured root folder and, for each Git repository found, runs a standard update-and-maintenance sequence.

**What it does, for each repository:**

1. Prints the repository name and path.
2. Runs `git status --short` to show any local changes.
3. Runs `git pull --ff-only` to pull the latest changes (fast-forward only).
   - If the pull fails (e.g. due to local modifications or conflicts), the repository is skipped and a warning is printed.
4. Runs `git gc` to clean up loose objects.
5. Runs `git repack -a -d` to optimize the pack files.

**Configuration:**

Edit the `ROOT` variable at the top of the script to point to the folder that contains your cloned repositories:

```bat
set "ROOT=C:\Users\ssanders\Documents\GitHub"
```

**Usage:**

Double-click `update_all_git_repos.bat`, or run it from a Command Prompt:

```bat
update_all_git_repos.bat
```

The script pauses at the end so you can review the output before the window closes.

## Requirements

- Windows (Command Prompt / `cmd.exe`)
- Git installed and available on the system `PATH`

## License

See [LICENSE](LICENSE) if present, otherwise all rights reserved.
