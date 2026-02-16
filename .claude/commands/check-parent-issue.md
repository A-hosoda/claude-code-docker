Validate that a parent issue follows the required template structure and quality standards.

Input: $ARGUMENTS
(Provide an issue number like "#14" or a URL)

## Step 1: Read the Issue

1. Fetch the issue: `gh issue view <number>`
2. Read the template for reference: `.github/ISSUE_TEMPLATE/parent-issue.yml`
3. Verify the issue has the `parent` label
   - If no `parent` label: flag as warning, continue checking content

## Step 2: Section Completeness Check

Verify these required sections exist and are non-empty:

| # | Section | Check |
|---|---------|-------|
| 1 | Background | Exists and explains the problem or opportunity |
| 2 | Goal | 1-3 sentences describing the desired outcome |
| 3 | Requirements | Bulleted list with 2+ verifiable items |
| 4 | Non-goals | Bulleted list with 1+ items |
| 5 | Success Criteria | 1+ measurable or observable outcomes |

## Step 3: Content Quality Check

Evaluate each section for quality:

- **Background**: Does it provide enough context for someone unfamiliar with the project?
- **Goal**: Is it specific and outcome-oriented? (not just "improve" or "enhance")
- **Requirements**: Are they verifiable? Are they requirements, not implementation tasks?
- **Non-goals**: Are the exclusions reasonable and meaningful?
- **Success Criteria**: Are they measurable? Do they align with the Goal?

## Step 4: Anti-pattern Detection

Scan the issue body for these anti-patterns:

**Implementation details — flag if found:**
- File paths (e.g. `lib/foo.sh`, `src/bar.ts`)
- Function names or signatures (e.g. `parse_args()`, `handleClick`)
- Source code or pseudocode
- Technology choices that belong in child issues

**Vague content — flag if found:**
- Goals containing only "improve", "enhance", "optimize" without measurable targets
- Requirements that cannot be verified (e.g. "make it better")
- Success criteria that are not observable

**Scope issues — flag if found:**
- Too narrow: Single task that should be a child issue (1 requirement, no breakdown needed)
- Too broad: 10+ requirements suggesting the issue should be split into multiple parent issues

## Step 5: Output Report

Output the result using this format:

```
## Issue #XX Check Result

**Type:** Parent Issue
**Verdict:** ✅ LGTM / ⚠️ FIXABLE / ❌ REWRITE NEEDED

### Section Completeness
- ✅ Background
- ✅ Goal
- ❌ Requirements — only 1 item (minimum 2 required)
...

### Content Quality
- ✅ Background — provides sufficient context
- ⚠️ Goal — "improve performance" lacks measurable target
...

### Anti-pattern Detection
- ❌ Line 15: contains file path `lib/parser.sh` (implementation detail)
- (none) if clean

### Scope Assessment
- ✅ Appropriate scope (X requirements, decomposable into child issues)

### Suggested Fixes
1. Add measurable target to Goal (e.g. "reduce response time to under 500ms")
2. Remove file path reference on line 15
3. Add at least one more requirement
```

**Verdict criteria:**
- ✅ **LGTM**: All checks pass
- ⚠️ **FIXABLE**: Minor issues that can be fixed with small edits (e.g. vague wording in one section)
- ❌ **REWRITE NEEDED**: Missing required sections, significant implementation details, or scope issues
