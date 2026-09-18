# `my-claude-marketplace`

A custom Claude Code plugin marketplace hosted on GitHub, providing extensions, tools, and custom slash commands for Claude Code.

---

## Table of Contents

- [Overview](#overview)
- [How to Add This Marketplace](#how-to-add-this-marketplace)
- [How to Install Plugins](#how-to-install-plugins)
- [Available Plugins](#available-plugins)
- [How to Add New Plugins](#how-to-add-new-plugins)
- [Validating Manifests](#validating-manifests)
- [Repository Structure](#repository-structure)

---

## Overview

This repository conforms to Anthropic's official Claude Code plugin marketplace specification. It indexes plugins maintained in this repository (and can also point to external repositories), allowing users to seamlessly register the marketplace and install plugins with standard Claude Code CLI commands.

---

## How to Add This Marketplace

Inside a Claude Code session or via the terminal, run:

```bash
/plugin marketplace add <owner>/<repo>
```

For example, once pushed to your GitHub account:

```bash
/plugin marketplace add Marisha-Sahay/my-claude-marketplace
```

Or using the full GitHub repository URL:

```bash
/plugin marketplace add https://github.com/Marisha-Sahay/my-claude-marketplace.git
```

To view all registered marketplaces:

```bash
/plugin marketplace list
```

---

## How to Install Plugins

Once the marketplace is registered in Claude Code, install any available plugin using the `<plugin>@<marketplace-name>` syntax:

```bash
/plugin install <plugin>@my-claude-marketplace
```

For example, to install the included `hello-world` starter plugin:

```bash
/plugin install hello-world@my-claude-marketplace
```

After installing, run `/hello-world` in Claude Code to execute the command.

---

## Available Plugins

| Plugin | Version | Description | Source |
| :--- | :--- | :--- | :--- |
| **`hello-world`** | `1.0.0` | Simple starter plugin demonstrating custom slash commands | [`./plugins/hello-world`](./plugins/hello-world) |
| **`us-bank-holidays`** | `1.0.0` | Provides US bank (Federal Reserve) holidays for a given year | [`./plugins/us-bank-holidays`](./plugins/us-bank-holidays) |

---

## How to Add New Plugins

You can easily expand this marketplace with new plugins using `plugins/hello-world` as a template:

### 1. Copy the Starter Template
Duplicate the `plugins/hello-world` folder and rename it with your new plugin's identifier:
```bash
cp -r plugins/hello-world plugins/my-new-plugin
```

### 2. Update Plugin Metadata
Edit `plugins/my-new-plugin/.claude-plugin/plugin.json`:
```json
{
  "name": "my-new-plugin",
  "description": "Description of what this plugin does",
  "version": "1.0.0",
  "author": {
    "name": "marisha",
    "email": "marishasahay@gmail.com"
  }
}
```

### 3. Add Your Commands, Skills, Agents, or Hooks
Add your custom functionality inside `plugins/my-new-plugin/`:
- **Slash Commands**: Add markdown files under `commands/` (e.g. `commands/do-something.md`).
- **Skills**: Add skill definitions under `skills/` with a `SKILL.md`.
- **Agents**: Add custom agent configs under `agents/`.
- **MCP Servers**: Add external MCP server definitions in `.mcp.json`.
- **Hooks**: Add event hook scripts under `hooks/`.

### 4. Register the Plugin in `marketplace.json`
Add an entry to the `plugins` array in `.claude-plugin/marketplace.json`:
```json
{
  "name": "my-new-plugin",
  "description": "Description of what this plugin does",
  "source": "./plugins/my-new-plugin",
  "author": {
    "name": "marisha",
    "email": "marishasahay@gmail.com"
  },
  "category": "utilities"
}
```

### 5. Validate Before Publishing
Run validation to ensure there are no syntax or schema issues:
```bash
claude plugin validate plugins/my-new-plugin
claude plugin validate .
```

---

## Validating Manifests

You can validate both the marketplace manifest and individual plugin manifests using the Claude CLI:

```bash
# Validate the marketplace manifest and indexed plugins from repository root
claude plugin validate .

# Strict validation (treats warnings as errors)
claude plugin validate --strict .

# Validate a specific plugin
claude plugin validate plugins/hello-world
```

---

## Repository Structure

```
my-claude-marketplace/
├── .claude-plugin/
│   └── marketplace.json         # Marketplace catalog manifest
├── plugins/
│   └── hello-world/             # Example plugin template
│       ├── .claude-plugin/
│       │   └── plugin.json      # Plugin manifest & metadata
│       ├── commands/
│       │   └── hello-world.md   # Slash command definition
│       └── README.md            # Plugin documentation
├── .gitignore                   # Git ignore rules
└── README.md                    # Marketplace documentation
```

---

## Author & Maintainer

- **Maintainer**: marisha
- **Email**: [marishasahay@gmail.com](mailto:marishasahay@gmail.com)
