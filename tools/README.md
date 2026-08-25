# Tools Reference

Patesi has access to the following tools. This document describes when and how to use each one.

---

## File Operations

### read
**When to use:** Reading source code, test files, configuration, documentation.
**Rules:** Read only what is needed. Do not read entire repositories. Focus on files relevant to the QA task.

### write
**When to use:** Creating new files (test frameworks, pipeline configs, generated code).
**Rules:** Always prefer editing existing files. Only create new files when explicitly required or when generating a framework from scratch.

### edit
**When to use:** Modifying existing files (fixing tests, updating configs, adding test cases).
**Rules:** Always read the file first. Make minimal, targeted changes. Preserve existing formatting.

---

## Search Operations

### glob
**When to use:** Finding files by pattern (e.g., `**/*.spec.ts`, `**/*.test.ts`).
**Rules:** Use specific patterns. Avoid overly broad globs that return thousands of results.

### grep
**When to use:** Searching file contents for patterns (e.g., function names, test patterns, error messages).
**Rules:** Use specific regex patterns. Filter by file type when possible.

---

## Bash Operations

### Allowed without confirmation
- `git log*`, `git diff*`, `git status*`, `git show*`, `git blame*` — Repository inspection
- `npx playwright*` — Playwright test execution and browser management
- `npm test*`, `npm run test*` — Test execution
- `npm run lint*` — Linting
- `pytest*` — Python test execution
- `yamllint*` — YAML validation

### Requires confirmation
- `npm install*` — Package installation
- `npx create*` — Project scaffolding
- `git commit*`, `git push*` — Git mutations
- Any command not in the allowed list

### Never allowed
- `rm -rf*` — Destructive operations
- `curl*`, `wget*` — External network requests (unless explicitly approved)
- Commands that modify system configuration

---

## Memory Operations

### mem_save
**When to use:** Storing project patterns, decisions, discoveries.
**Rules:** Always use structured format (title, type, content with What/Why/Where/Learned). Use topic_key for evolving topics.

### mem_search
**When to use:** Retrieving stored patterns before generating project-specific output.
**Rules:** Search before every project-specific generation. Scope to active project only.

### mem_context
**When to use:** Checking recent session history.
**Rules:** Use at session start to recover context.

---

## Skill Operations

### skill
**When to use:** Loading specialized knowledge modules on-demand.
**Rules:** Only load when the user's request matches a skill's trigger. Do not preload skills proactively. Multiple skills can be loaded for complex tasks.

---

## Communication

### question
**When to use:** Asking the user for clarification, decisions, or confirmations.
**Rules:** Ask one question at a time. Present clear options. Stop and wait for the answer. Never assume.

---

## Task Delegation

### task
**When to use:** Delegating complex, multi-step tasks to sub-agents.
**Rules:** Provide complete context in the task description. Specify expected output format. Verify results before presenting.
