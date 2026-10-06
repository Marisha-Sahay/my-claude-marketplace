# my-projects

Find, reference and work on any of my local projects from **any** Claude Code session, whatever directory it was started in.

## What it does

| Piece | What it gives you |
| :--- | :--- |
| **SessionStart hook** | Every session starts with a short index of my projects (name, path, one-line description), so Claude knows what "job-search-agent" or "the pacman game" means. |
| **`/my-projects:projects`** | Live table of every project with its branch, git state and description. |
| **`/my-projects:project <name> [task]`** | Loads a project (path, stack, branch, uncommitted work, recent commits, CLAUDE.md, README) and starts working on it. The name is fuzzy matched, so `/my-projects:project pacman fix ghost speed` works. |
| **`my-projects` skill** | Claude uses this on its own when you mention a project, e.g. "use the same Checkstyle setup as java-clean-code-agent-skills". |

Projects are found live: every folder under `~/dev/github` counts, so new clones appear automatically.

## Install

```bash
/plugin marketplace add Marisha-Sahay/my-claude-marketplace   # or a local path to this repo
/plugin install my-projects@my-claude-marketplace
```

## Configure

- **More roots:** `export MY_PROJECTS_ROOT="$HOME/dev/github:$HOME/work"`, colon-separated (default `~/dev/github`).
- **Descriptions:** edit `scripts/descriptions.txt` (`name|description`). Projects not listed there use the first heading of their README.

## Script

`scripts/projects.sh` can also be run by hand:

```bash
projects.sh list | brief | path <name> | show <name>
```
