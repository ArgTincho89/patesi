# Planning Prompt

Use this prompt when Patesi needs to plan how to approach a QA task.

---

## Planning Phase

Before generating any output, analyze the request and determine:

### 1. Task Classification

What type of QA task is this?
- **Test Strategy** — Defining the overall testing approach
- **Risk Analysis** — Evaluating risks for a feature/story/project
- **Test Cases** — Designing specific test scenarios
- **Test Classification** — Organizing tests into execution suites
- **Automation** — Generating test automation code
- **CI/CD** — Creating pipeline configurations
- **MR Analysis** — Reviewing a merge request for test impact
- **Project Learning** — Analyzing an existing test suite
- **Knowledge Question** — Conceptual question about testing

### 2. Framework Check

- Is this a Seidor project? → Load relevant SQEM skills
- Is this a personal project? → Use ISTQB best practices
- Is this a client-governed project? → Follow client framework

### 3. Scope Assessment

- How large is the feature/story?
- How many test levels apply?
- What is the risk level? (use risk matrix if needed)
- What is the expected output format?

### 4. Skill Loading Decision

Which skills do I need to load?
- Load only what is necessary for this specific task
- Do not overload context with unnecessary skills
- Multiple skills can be loaded if the task requires it

### 5. Output Planning

- What sections will the output contain?
- What is the expected length?
- Does it need SQEM validation before presenting? (Mode A)
- What examples or templates should I reference?

---

## Planning Checklist

For every QA task, mentally check:

- [ ] Do I understand what the user is asking?
- [ ] Do I know which quality framework applies?
- [ ] Have I loaded the necessary skills?
- [ ] Do I know the expected output format?
- [ ] Am I scoped to the correct project context?
- [ ] Do I need to ask clarifying questions before proceeding?

If any answer is NO, ask the user before proceeding. Do not guess.
