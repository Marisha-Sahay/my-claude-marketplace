# US Bank Holidays Plugin

This Claude Code plugin provides a handy slash command to look up the official Federal Reserve bank holiday schedules for 2026 and 2027.

## Usage

You can invoke the command directly in Claude Code by passing the desired year as an argument:

```
/bank-holidays 2026
```

or 

```
/bank-holidays 2027
```

If you don't provide a year, the command will prompt you for one. The plugin strictly outputs a clean markdown table of the holidays for the requested year, including the day of the week and any weekend observance notes.

## Installation

If this plugin is part of your local marketplace, you can install it into Claude Code using:

```bash
claude plugin install us-bank-holidays@my-claude-marketplace
```
*(adjust the marketplace name based on your configuration)*
