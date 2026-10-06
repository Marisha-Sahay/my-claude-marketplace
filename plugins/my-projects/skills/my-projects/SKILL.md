---
name: my-projects
description: Locate and use Marisha's local projects (under ~/dev/github) from any directory. Use when the user mentions one of their projects by name (e.g. bitcoin, langchain4j-spring, job-search-agent, multirail-fx-agent, pacman, portfolio site), asks to compare with, copy from, or refer to code in another of their projects, or asks to work on / switch to one of their projects.
---

# My projects

A session-start hook already injected a short index of the user's projects. For anything beyond that index, use the helper script:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/projects.sh" list          # all projects: branch, git state, description
"${CLAUDE_PLUGIN_ROOT}/scripts/projects.sh" path <name>   # absolute path (fuzzy: exact > prefix > substring)
"${CLAUDE_PLUGIN_ROOT}/scripts/projects.sh" show <name>   # path, stack, git state, recent commits, CLAUDE.md, README
```

If `CLAUDE_PLUGIN_ROOT` is not set in your shell, the projects live directly under `~/dev/github/<name>`.

## Referring to a project

When the user asks about code in another project ("how did I do X in job-search-agent?", "use the same Checkstyle config as java-clean-code-agent-skills"):

1. Resolve the path with `projects.sh path <name>`.
2. Search and read inside that absolute path with Grep/Glob/Read. Do not edit it unless the user asked you to.
3. Cite files as `<absolute-path>:<line>`.

## Working on a project

When the user wants to work on a project, run `projects.sh show <name>`, give a 3–5 line orientation (purpose, stack, branch, uncommitted work, recent commits), then work through absolute paths: `git -C <path>`, `cd <path> && <build/test>`, and Read/Edit on absolute file paths. Respect that project's CLAUDE.md / CONTRIBUTING.md. Suggest `/add-dir <path>` if permission prompts get in the way.

## Notes

- Several repos are forks of upstream projects (bitcoin, langchain4j-spring, system-design-primer) and `langchain4j` is an upstream clone. Check the current branch before changing anything, and don't push without asking.
- Additional scan roots can be set with `MY_PROJECTS_ROOT=/path/a:/path/b`.
- Custom descriptions live in `${CLAUDE_PLUGIN_ROOT}/scripts/descriptions.txt`. New projects fall back to their README title.
