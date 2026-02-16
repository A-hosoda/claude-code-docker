Break down a parent issue or task into child issues.

Input: $ARGUMENTS
(Provide an issue number like "#1", a URL, or a description of the task to break down)

## Step 1: Information Gathering

1. Read the input issue or task:
   - If an issue number is given: `gh issue view <number>`
   - If a URL is given: fetch and read it
   - If a description is given: use it directly

2. Explore the codebase to understand:
   - Project structure (directories, key files)
   - Existing modules and their responsibilities
   - Coding conventions and patterns in use

3. Check for existing related issues:
   - `gh issue list --state open`

4. Read the issue templates to understand required sections:
   - `.github/ISSUE_TEMPLATE/child-feature.yml` (for feature work)
   - `.github/ISSUE_TEMPLATE/child-bugfix.yml` (for bug fixes)

## Step 2: Child Issue Breakdown Rules

**Granularity:**
- 1 issue = 1 PR
- Guideline: 1 file creation or modification per issue
- If a feature requires multiple files, split into separate issues with explicit dependencies

**Content rules — what to write in child issues:**

| Allowed | Example |
|---------|---------|
| Function signature tables | `detect_languages` / Detect languages / stdout: one per line |
| Output format examples | `[INFO] Detected language: typescript` |
| Decision logic tables | `package.json + .ts -> TypeScript` |
| Processing flow steps | `1. File check -> 2. Detect -> 3. Output` |

| NOT allowed | Reason |
|-------------|--------|
| Pseudocode (if-else, for loops) | Implementation detail |
| Shell script / code fragments | Source code |
| Complete function bodies | Source code |

**Test cases are mandatory:**
- Classify every test case as: **normal** / **error** / **boundary**
- Each case must have: input + expected output (or expected behavior)
- For bugfix issues, classify as: **fix verification** / **regression**

**Dependencies:**
- Explicitly state which issues must be completed first
- Reference existing modules that should be reused

## Step 3: Create Child Issues

For each child issue, use the appropriate template format:
- Feature work -> Follow `child-feature.yml` structure
- Bug fixes -> Follow `child-bugfix.yml` structure

Create issues using `gh issue create` with the template structure as the body.

## Step 4: Update Parent with Tracking Info

After creating all child issues, add a comment to the parent issue (or create a tracking issue) with:

1. **Child issue list** with numbers and titles
2. **Implementation order** (sequential dependency chain)
3. **Parallel opportunities** (issues that can be worked on simultaneously)

Format:
```
## Implementation Plan

### Dependency Order
1. #XX - <title> (no dependencies)
2. #YY - <title> (depends on #XX)
3. #ZZ - <title> (depends on #XX)
   - #YY and #ZZ can be parallelized

### Child Issues
- [ ] #XX - <title>
- [ ] #YY - <title>
- [ ] #ZZ - <title>
```

## Step 5: Consistency Check

Before finalizing, verify:

- [ ] **Coverage:** Every requirement in the parent issue is addressed by at least one child issue
- [ ] **No circular dependencies:** Dependency graph is a DAG
- [ ] **Independent implementation:** Each child issue can be implemented and tested in isolation (given its dependencies are met)
- [ ] **No source code:** No pseudocode or script fragments in any child issue
- [ ] **Test completeness:** Every child issue has test cases with normal/error/boundary classification
- [ ] **Acceptance criteria:** Every child issue has high-level merge criteria separate from test cases
