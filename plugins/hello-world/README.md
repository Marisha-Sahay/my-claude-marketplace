# Hello World Plugin Template

A simple starter plugin template for Claude Code demonstrating custom slash commands.

## Features

- **Command**: `/hello-world` — prints `"hello world!"`

## Directory Structure

```
hello-world/
├── .claude-plugin/
│   └── plugin.json     # Plugin manifest & metadata
├── commands/
│   └── hello-world.md  # Slash command definition
└── README.md
```

## How to Test Locally

You can validate this plugin using the Claude CLI:

```bash
claude plugin validate ./plugins/hello-world
```
