Update an existing issue to a parent issue following the template structure.

Input: $ARGUMENTS
(Provide the issue number to convert, e.g. "#42" or "42")

## Step 1: Read Existing Issue

1. Read the existing issue using `gh issue view <number>`.
   - Capture: title, body, labels, assignees
2. Read `.github/ISSUE_TEMPLATE/parent-issue.yml` to understand the required sections and format.
3. Check if the issue already has the `parent` label:
   - If yes: warn the user that this issue is already a parent issue and ask whether to proceed.

## Step 2: Draft New Content

Analyze the existing issue content and draft the 5 required sections:

- **Background**: Extract context from the original content
- **Goal**: Derive a measurable outcome
- **Requirements**: Identify functional requirements
- **Non-goals**: Determine what is out of scope
- **Success Criteria**: Define observable completion indicators

If the existing content lacks sufficient information for any section, ask the user targeted questions to fill the gaps.

**Content rules — what to write in parent issues:**

| Allowed | Example |
|---------|---------|
| Concrete outcomes | "Reduce execution time to under 3 minutes" |
| Verifiable requirements | "Support parallel file processing" |
| Observable criteria | "All existing tests pass" |
| Scope boundaries | "Excludes UI changes" |

| NOT allowed | Reason |
|-------------|--------|
| Vague goals | "Improve performance" (no measurable target) |
| Implementation details | File paths, function names, technology choices |
| Task lists | "Create file X, modify file Y" (child issue responsibility) |
| Source code | Implementation detail |

**Section guidelines:**
- **Background**: Explain the problem or opportunity with enough context for someone unfamiliar
- **Goal**: 1-3 sentences, outcome-oriented, measurable where possible
- **Requirements**: Bulleted list of verifiable functional requirements (2+ items)
- **Non-goals**: Items that could reasonably be expected but are explicitly excluded (1+ items)
- **Success Criteria**: Measurable or observable outcomes that indicate completion (1+ items)

## Step 3: Present to User for Review

Present the following to the user for confirmation:

1. **Original content** (title + body) — what will be saved as a comment
2. **New title** — proposed updated title
3. **New body** — the 5-section parent issue format

Wait for user approval before proceeding.

## Step 4: Save Original Content as Comment

Before modifying the issue, preserve the original content by adding it as a comment:

```
gh issue comment <number> --body "## Original Issue Content

**Original title:** <original title>

<original body>"
```

This step MUST complete successfully before proceeding to Step 5.

## Step 5: Update the Issue

Update the issue title, body, and label:

```
gh issue edit <number> --title "<new title>" --body "<formatted body>" --add-label "parent"
```

The body should use markdown headers matching the template sections:
```
## Background
...

## Goal
...

## Requirements
...

## Non-goals
...

## Success Criteria
...
```

## Step 6: Consistency Check

Before finalizing, verify:

- [ ] **All sections filled**: Background, Goal, Requirements, Non-goals, Success Criteria
- [ ] **No implementation details**: No file paths, function names, or source code
- [ ] **Goal is measurable**: Contains concrete outcomes, not just "improve" or "enhance"
- [ ] **Non-goals are meaningful**: Excludes items that could reasonably be expected
- [ ] **Requirements are decomposable**: Each requirement can be broken into child issues
- [ ] **Success criteria are observable**: Can be verified without reading implementation
- [ ] **Original content preserved**: Original title and body saved as a comment
- [ ] **Parent label applied**: The `parent` label is present on the issue
