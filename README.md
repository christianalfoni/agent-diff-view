# agent-diff-view

A browser-based interactive reviewer of AI agent changes, designed for humans.
Understand and own the specific changes your agent makes — no git diffs, just clean before-and-after views of the actual code changes.

![agent-diff-view](screenshot.png)

Type `/changes` in your AI coding harness and a local browser tab opens. Browse changed files,
navigate hunks, leave targeted comments on the ones that matter, hit **⌘↵** to submit —
the agent receives a structured prompt that maps every comment to its exact file and hunk.

---

## Supported harnesses

| Harness | Command | Installs to |
|---------|---------|-------------|
| **Claude Code** | `/changes` | `~/.claude/commands/changes.md` |
| **OpenCode** | `/changes` | `~/.config/opencode/commands/changes.md` |
| **Gemini CLI** | `/changes` | `~/.gemini/commands/changes.toml` |
| **Codex CLI** (OpenAI) | `$changes` | `~/.agents/skills/changes/SKILL.md` |
| **pi.dev** | `/changes` | `~/.pi/agent/prompts/changes.md` |

> **Note:** Codex CLI uses `$changes` (not `/changes`) because it uses a skills system rather than
> slash commands. The skill is configured to only trigger when explicitly invoked — it will not
> auto-activate based on task descriptions.

---

## Install

```bash
npx agent-diff-view install
```

This opens an interactive picker — select your harness and the command is installed.

---

## Usage

```
/changes              # review uncommitted changes against HEAD
/changes --staged     # review staged changes only
/changes main         # review changes against a branch or commit
/changes v1.0..v2.0   # review a commit range
```

For Codex CLI, replace `/changes` with `$changes`.

---

## Keyboard shortcuts

| Key | Action |
|-----|--------|
| `⌘←` / `⌘→` | Previous / next hunk |
| `⌘↑` / `⌘↓` | Previous / next file |
| `⌘↵` | Submit |

---

## How it works

```
You type /changes in your AI coding harness
  The agent runs: npx agent-diff-view HEAD   ← blocks
    → parses changes into before/after view
    → starts local HTTP server
    → opens browser tab
    → waits for you to submit
  You: browse files, annotate hunks, hit ⌘↵
    → builds structured prompt
    → prints to stdout, exits
  The agent receives the output and addresses each comment
```

No background processes are left running. No npm dependencies — only Node built-ins.

---

> A QA engineer walks into a bar. Orders 1 beer. Orders 0 beers. Orders 99999999 beers.
> Orders -1 beers. Orders a lizard. Orders NULL beers.
> First real customer walks in and asks where the bathroom is. The bar bursts into flames.
