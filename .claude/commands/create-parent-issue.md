Create a parent issue from the current discussion or provided input.

Input: $ARGUMENTS
(Provide a description of the feature or bug, or leave empty to extract from conversation context)

## Step 1: Gather Context

1. Determine the source of information:
   - If `$ARGUMENTS` is provided: use it as the starting point
   - If `$ARGUMENTS` is empty: extract key points from the conversation context

2. If information is unclear or incomplete, ask the user about:
   - Background: What problem or opportunity motivates this?
   - Goal: What outcome do you want?
   - Requirements: What are the functional requirements?
   - Non-goals: What is explicitly out of scope?
   - Success criteria: How will you measure success?

## Step 2: Read the Template

Read `.github/ISSUE_TEMPLATE/parent-issue.yml` to understand the required sections and format.

## Step 3: Draft the Issue Content

Fill in all 5 sections of the parent issue template.

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

## Step 4: Present to User for Review

Present the draft to the user and ask for confirmation or modifications.
Wait for user approval before proceeding.

## Step 5: Create the Issue

Create the issue using the GitHub CLI:
```
gh issue create --label "parent" --title "<title>" --body "<formatted body>"
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
