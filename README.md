# claude-diff-view

A browser-based interactive git diff reviewer for [Claude Code](https://claude.ai/code).

![claude-diff-view](screenshot.png)

Type `/changes` in Claude Code and a local browser tab opens. Browse changed files,
navigate hunks, leave targeted comments on the ones that matter, hit **⌘↵** to submit —
Claude receives a structured prompt that maps every comment to its exact file and hunk.

---

## Install

```bash
npx claude-diff-view
```

That's it. On first run it installs the `/changes` slash command into `~/.claude/commands/` automatically.

---

## Usage

### In Claude Code

```
/changes              # review uncommitted changes against HEAD
/changes --cached     # review staged changes only
/changes main         # review changes against a branch or commit
/changes v1.0..v2.0   # review a commit range
```

### Standalone

```bash
npx claude-diff-view HEAD~3
npx claude-diff-view main..feature-branch
```

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
You type /changes in Claude Code
  Claude runs: npx claude-diff-view HEAD   ← blocks
    → parses git diff
    → starts local HTTP server
    → opens browser tab
    → waits for you to submit
  You: browse files, annotate hunks, hit ⌘↵
    → builds structured prompt
    → prints to stdout, exits
  Claude receives the output and addresses each comment
```

No background processes are left running. No npm dependencies — only Node built-ins.
