# 🧪 Patesi

**SDET AI Agent for [opencode](https://opencode.ai)** — QA engineer with ISTQB knowledge, test strategy, automation, and project learning.

Patesi is a modular, skill-based AI agent that brings professional Software Development Engineer in Test (SDET) capabilities to any project through [opencode](https://opencode.ai). It applies ISTQB-certified methodologies to help developers and QA engineers build better software.

## ✨ Features

| Skill | Description |
|-------|-------------|
| **ISTQB Knowledge** | Foundation + Advanced Core reference for testing terminology and techniques |
| **Test Strategy** | Generates comprehensive test strategies from user stories |
| **Risk Analysis** | Analyzes features for testing risks with weighted scoring |
| **Test Cases** | Generates structured, traceable test cases |
| **Test Classification** | Classifies tests into S/M/L/XL suites for CI/CD |
| **Automation** | Generates Playwright + TypeScript frameworks |
| **CI/CD** | Creates pipeline configs (GitHub Actions, GitLab CI, Jenkins) |
| **MR Analysis** | Analyzes merge requests for test impact |
| **Project Learning** | Stores project-specific QA patterns via Engram |

## 🚀 Quick Start

### Prerequisites

- [opencode](https://opencode.ai) installed and configured
- Node.js 20+ (for Playwright test execution)

### Installation

#### Option 1: Install Script (Recommended)

**Linux/macOS:**
```bash
git clone https://github.com/ArgTincho89/patesi.git
cd patesi
bash scripts/install.sh
```

**Windows:**
```powershell
git clone https://github.com/ArgTincho89/patesi.git
cd patesi
.\scripts\install.ps1
```

#### Option 2: Manual Installation

1. Copy `agents/sdet.md` to `~/.config/opencode/agents/`
2. Copy all `skills/sdet-*/` directories to `~/.config/opencode/skills/`
3. Add the agent configuration to your `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "patesi": {
      "description": "Patesi — SDET AI Agent for test strategy, ISTQB knowledge, case generation, automation, and quality analysis",
      "mode": "primary",
      "prompt": "{file:./agents/sdet.md}",
      "tools": {
        "edit": true,
        "write": true
      }
    }
  }
}
```

4. Restart opencode

#### Option 3: Using `skills.paths` (No Copy)

Add the cloned repo to your opencode config:

```json
{
  "skills": {
    "paths": ["/path/to/patesi/skills"]
  }
}
```

### Usage

1. Start opencode in your project
2. Switch to **Patesi** agent using the **Tab** key (or type `@patesi`)
3. Ask QA-related questions:

```
# Test Strategy
"Create a test strategy for user authentication"

# Risk Analysis
"Analyze risks for the payment processing feature"

# Test Cases
"Generate test cases for password reset"

# Automation
"Generate a Playwright framework for the login page"

# CI/CD
"Create a GitHub Actions workflow for my test suite"

# MR Analysis
"Analyze this MR for potential breakage"
```

## 📁 Project Structure

```
patesi/
├── agents/
│   └── sdet.md                    # Main agent prompt
├── skills/
│   ├── sdet-istqb/
│   │   └── SKILL.md               # ISTQB knowledge reference
│   ├── sdet-test-strategy/
│   │   └── SKILL.md               # Test strategy generator
│   ├── sdet-risk-analysis/
│   │   └── SKILL.md               # Risk analysis engine
│   ├── sdet-test-cases/
│   │   └── SKILL.md               # Test case generator
│   ├── sdet-test-classification/
│   │   └── SKILL.md               # Test suite classifier
│   ├── sdet-automation/
│   │   └── SKILL.md               # Playwright+TS framework
│   ├── sdet-cicd/
│   │   └── SKILL.md               # CI/CD pipeline generator
│   ├── sdet-mr-analysis/
│   │   └── SKILL.md               # MR analyzer
│   └── sdet-project-learning/
│       └── SKILL.md               # Project pattern learning
├── scripts/
│   ├── install.sh                 # Linux/macOS installer
│   └── install.ps1                # Windows installer
├── examples/
│   └── opencode.json              # Example config
├── istqb-syllabi/
│   └── README.md                  # ISTQB syllabi download links
├── README.md
├── LICENSE
└── .gitignore
```

## 🔧 Configuration

### Agent Permissions

Patesi requires these permissions:

| Permission | Value | Reason |
|-----------|-------|--------|
| `read` | allow | Must read code and specs |
| `edit` | allow | Must create/edit test files |
| `write` | allow | Must generate framework files |
| `bash` | ask | Most commands need approval |
| `skill` | allow | Must load skills on-demand |

### Model Recommendation

Patesi works best with:
- **Primary**: `anthropic/claude-sonnet-4-6` (best balance of quality and speed)
- **Alternative**: `anthropic/claude-haiku-4-5` (faster, good for simple tasks)

Set in your `opencode.json`:
```json
{
  "model": "anthropic/claude-sonnet-4-6"
}
```

## 🧠 Engram Integration (Optional)

Patesi can learn project-specific QA patterns using [Engram](https://github.com/nicholasgriffintn/engram) persistent memory.

### Setup

1. Add Engram MCP to your `opencode.json`:

```json
{
  "mcp": {
    "engram": {
      "command": ["engram", "mcp"],
      "enabled": true,
      "type": "local"
    }
  }
}
```

2. Use Patesi's project learning skill:

```
"Learn from this project's test suite"
"Remember that we use fixtures, not page objects"
"What patterns does this project use?"
```

### Without Engram

Patesi works perfectly without Engram. All skills are independent and don't require memory. You just won't have cross-session pattern recall.

## 🌍 Multi-Project Support

### Global Installation (Default)

Installed to `~/.config/opencode/` — available in all projects.

### Per-Project Overrides

Override skills for specific projects by creating `.opencode/skills/sdet-{name}/SKILL.md` in your project root. Project skills take precedence over global skills.

### Cross-Machine Setup

Patesi is just markdown files — portable across machines:

1. Clone this repo on each machine
2. Run the install script, or
3. Use `skills.paths` to point to the repo location

## 🤝 Contributing

Contributions welcome! See the [CONTRIBUTING.md](CONTRIBUTING.md) guide.

### Adding a New Skill

1. Create `skills/sdet-{name}/SKILL.md`
2. Follow the frontmatter format (name, description with triggers, license, metadata)
3. Include trigger keywords in the description
4. Add example inputs/outputs
5. Submit a PR

### Improving ISTQB Knowledge

The `sdet-istqb` skill contains condensed knowledge. To expand:

1. Add new sections to `skills/sdet-istqb/SKILL.md`
2. Keep the skill under 4K tokens for context efficiency
3. Reference the ISTQB syllabus version

## 📄 License

Apache License 2.0 — see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- [ISTQB](https://www.istqb.org/) for the testing methodology
- [opencode](https://opencode.ai) for the AI agent platform
- [Playwright](https://playwright.dev/) for the testing framework
- The open-source community for sharing AI agent skills

## 📚 Resources

- [ISTQB Syllabi](https://www.istqb.org/certifications/) — Official certification syllabi
- [Playwright Documentation](https://playwright.dev/docs/intro) — Testing framework docs
- [opencode Documentation](https://opencode.ai/docs) — Agent platform docs
- [GitHub Actions](https://docs.github.com/en/actions) — CI/CD documentation

---

Built with ❤️ by [ArgTincho89](https://github.com/ArgTincho89)
