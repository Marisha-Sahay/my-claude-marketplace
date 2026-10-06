---
description: Load one of my projects and start working on it from the current session
argument-hint: <project-name> [what to do]
allowed-tools: Bash(*/scripts/projects.sh *)
---

The user wants to work on one of their projects. Arguments: `$ARGUMENTS`
The first word is the project name (fuzzy matched); anything after it is the task.

## How to proceed

1. Load the project context by running this with the Bash tool, substituting the project name:
   `${CLAUDE_PLUGIN_ROOT}/scripts/projects.sh show <project-name>`
   If no project name was given, run `${CLAUDE_PLUGIN_ROOT}/scripts/projects.sh list` and ask which one.
2. If the lookup failed or was ambiguous, show the candidates and ask which project they meant. Stop there.
3. Otherwise give a short orientation: what the project is, its stack, current branch, any uncommitted work, and what the last few commits were about.
4. Work on the project from this session using its **absolute path**:
   - Read/Edit/Write files using absolute paths under the project path.
   - Run git with `git -C <path> ...` and build/test commands with `cd <path> && ...`.
   - Follow the project's own CLAUDE.md / AGENTS.md / CONTRIBUTING.md conventions if present.
   - Tell the user they can run `/add-dir <path>` to give this session full access to the project without repeated permission prompts, or start a dedicated session with `cd <path> && claude`.
5. If a task was given after the project name, start on it. Otherwise ask what they'd like to do.
