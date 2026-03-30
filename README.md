# changes-for-claude

A browser-based interactive git diff reviewer for [Claude Code CLI](https://claude.ai/code).

Type `/changes` in Claude Code and a local browser tab opens. Browse changed files,
navigate hunks, leave targeted comments on the ones that matter, click **Submit** —
Claude receives a structured prompt that maps every comment to its exact file and hunk.

---

## How it works

```
You type /changes in Claude Code
  Claude runs: changes HEAD          ← subprocess starts, blocks
    → parses git diff
    → starts local HTTP server
    → opens browser tab
    → waits for you to submit
  You: browse files, annotate hunks, click Submit
    → server builds structured prompt
    → prints to stdout, exits
  Claude receives the output and addresses each comment
```

The output prompt format is identical to the one produced by the [pi coding agent](https://github.com/mariozechner/pi-coding-agent) changes extension, so Claude already understands it perfectly.

---

## Install

**Requires Node.js** — already present on any machine with Claude Code installed
(Claude Code itself ships as an npm package).

```bash
git clone https://github.com/yourname/changes-for-claude
cd changes-for-claude
./install.sh
```

This copies two files:

| File | Destination |
|------|-------------|
| `changes` | `~/.local/bin/changes` |
| `.claude/commands/changes.md` | `~/.claude/commands/changes.md` |

If `~/.local/bin` is not on your `PATH`, add this to your shell profile:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

---

## Usage

### In Claude Code

```
/changes              # review uncommitted changes against HEAD
/changes --cached     # review staged changes only
/changes main         # review changes against a branch or commit
/changes v1.0..v2.0   # review a commit range
```

### Standalone (outputs prompt to stdout)

```bash
changes HEAD~3
changes main..feature-branch
```

---

## Browser UI

```
┌─────────────────────────────────────────────────────┐
│  🔍 Changes Review              2 comments  [Submit] │
├─────────────────┬───────────────────────────────────┤
│ Files           │  src/server.go  hunk 2 of 4        │
│                 │  [← Prev]  [Next →]                │
│ ± server.go  2  │─────────────────────────────────── │
│ + handler.go    │  @@ -45,7 +45,9 @@                 │
│ - old.go        │                                    │
│                 │  BEFORE                            │
│                 │  ┌─────────────────────────────┐  │
│                 │  │  old code                   │  │
│                 │  └─────────────────────────────┘  │
│                 │  AFTER                             │
│                 │  ┌─────────────────────────────┐  │
│                 │  │  new code                   │  │
│                 │  └─────────────────────────────┘  │
│                 │                                    │
│                 │  ✎ COMMENT FOR THIS HUNK           │
│                 │  ┌─────────────────────────────┐  │
│                 │  │ Why was this limit changed?  │  │
│                 │  └─────────────────────────────┘  │
└─────────────────┴───────────────────────────────────┘
```

**Keyboard shortcuts** (when not typing in a comment box):

| Key | Action |
|-----|--------|
| `←` / `→` | Previous / next hunk |
| `↑` / `↓` | Previous / next file |

---

## Output format

The structured prompt sent to Claude looks like this:

```
Please review the following code changes and address my comments:

**src/server.go** — hunk 2/4: `@@ -45,7 +45,9 @@`
```
  maxRetries := 5
  timeout := 30 * time.Second
```
Comment: Why was the timeout doubled? This might cause slow test runs.

---

**src/handler.go** — hunk 1/1: `@@ -12,4 +12,6 @@`
```
  if err != nil {
      return nil, fmt.Errorf("failed: %w", err)
  }
```
Comment: Missing unit test for this error path.
```

---

## How the blocking works

`changes` starts a minimal HTTP server on a random localhost port using Node's built-in
`http` module, opens the browser with the platform's native open command (`open` / `xdg-open`
/ `start`), then awaits a `Promise` that resolves when the browser `POST`s to `/submit`.
The server closes, the prompt is written to stdout, and the process exits. Claude Code's
bash tool captures that stdout and continues the conversation.

No background processes are left running.
# claude-diff-view
