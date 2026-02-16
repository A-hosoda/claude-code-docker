Validate that a child issue follows the required template structure and rules.

Input: $ARGUMENTS
(Provide an issue number like "#12" or a URL)

## Step 1: Read the Issue

1. Fetch the issue: `gh issue view <number>`
2. Read the issue templates for reference:
   - `.github/ISSUE_TEMPLATE/child-feature.yml`
   - `.github/ISSUE_TEMPLATE/child-bugfix.yml`
3. Determine the issue type from labels:
   - `feature` label → check against child-feature template
   - `bug` label → check against child-bugfix template
   - No matching label → flag as warning, infer type from content

## Step 2: Section Completeness Check

**For feature issues, verify these required sections exist and are non-empty:**

| # | Section | Check |
|---|---------|-------|
| 1 | Parent Issue / Prerequisites | Issue number or "none" is stated |
| 2 | Summary | 1-3 sentences, describes what to implement |
| 3 | Specification | Contains tables, bullet points, or output examples |
| 4 | Implementation Target | File paths and function signature table present |
| 5 | Test Cases | Categorized into normal / error / boundary |
| 6 | Acceptance Criteria | High-level criteria, distinct from test cases |

**For bugfix issues, verify these required sections exist and are non-empty:**

| # | Section | Check |
|---|---------|-------|
| 1 | Related Issue / Prerequisites | Issue number is stated |
| 2 | Bug Description | Incorrect behavior described |
| 3 | Reproduction Steps | Steps + expected vs actual |
| 4 | Expected Behavior | Correct behavior after fix |
| 5 | Investigation Notes | (optional — skip if absent) |
| 6 | Fix Target Files | File paths with change description |
| 7 | Test Cases | Categorized into fix verification / regression |
| 8 | Acceptance Criteria | High-level criteria |

## Step 3: Content Rules Violation Check

Scan the issue body for violations:

**Source code check — flag if found:**
- `if [`, `if (`, `else`, `elif`, `fi` (shell conditionals)
- `for `, `while `, `do`, `done` (shell loops)
- `function `, `() {` (function definitions)
- `#!/` (shebang lines)
- Multi-line code blocks that contain implementation logic (not output examples)

**Allowed content — do NOT flag:**
- Function signature tables (name / purpose / input / output)
- Output format examples (e.g. `[INFO] ...`)
- Decision logic tables
- Processing flow steps (numbered lists)
- Single-line command examples for reproduction steps (bugfix only)

## Step 4: Test Cases Quality Check

Verify test case quality:

**For feature issues:**
- [ ] Has at least 1 **normal** case
- [ ] Has at least 1 **error** case
- [ ] Has at least 1 **boundary** case
- [ ] Each case specifies input and expected output/behavior

**For bugfix issues:**
- [ ] Has at least 1 **fix verification** case
- [ ] Has at least 1 **regression** case
- [ ] Each case specifies input and expected output/behavior

## Step 5: Granularity Check

- [ ] Issue targets 1 file creation or modification (guideline, not strict)
- [ ] If multiple files are involved, dependencies on other issues are stated
- [ ] Scope is achievable in 1 PR

## Step 6: Output Report

Output the result using this format:

```
## Issue #XX Check Result

**Type:** Feature / Bugfix
**Verdict:** ✅ LGTM / ⚠️ FIXABLE / ❌ REWRITE NEEDED

### Section Completeness
- ✅ Parent Issue / Prerequisites
- ✅ Summary
- ❌ Test Cases — missing boundary cases
...

### Content Rule Violations
- ❌ Line 42: contains shell conditional `if [ -f ... ]`
- (none) if clean

### Test Cases Quality
- ✅ Normal: 3 cases
- ✅ Error: 2 cases
- ❌ Boundary: 0 cases (minimum 1 required)

### Granularity
- ✅ Single file target
- ✅ Dependencies stated

### Suggested Fixes
1. Add boundary test cases (e.g. empty input, max length)
2. Remove shell conditional on line 42, replace with decision logic table
```

**Verdict criteria:**
- ✅ **LGTM**: All checks pass
- ⚠️ **FIXABLE**: Minor issues that can be fixed with small edits (e.g. missing 1 boundary case)
- ❌ **REWRITE NEEDED**: Missing required sections or significant source code violations
