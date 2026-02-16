#!/bin/bash
# Verify Docker environment setup for Claude Code
# Usage: verify-docker-env.sh
# Exit code: 0 if all checks pass, 1 if any check fails

set -euo pipefail

# --- Constants ---
PASS_COUNT=0
FAIL_COUNT=0
TOTAL_COUNT=0
LABEL_WIDTH=35

# --- Output helpers ---
print_result() {
    local label="$1"
    local status="$2"
    local padding

    padding=$(printf '%*s' $((LABEL_WIDTH - ${#label})) '' | tr ' ' '.')
    if [ "$status" = "ok" ]; then
        printf "[CHECK] %s %s OK\n" "$label" "$padding"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        printf "[CHECK] %s %s FAIL\n" "$label" "$padding"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
}

# --- Check functions ---
check_command() {
    local label="$1"
    local cmd="$2"

    if command -v "$cmd" > /dev/null 2>&1; then
        print_result "$label" "ok"
    else
        print_result "$label" "fail"
    fi
}

check_file() {
    local label="$1"
    local dir="$2"
    local file_count

    if [ -d "$dir" ]; then
        file_count=$(find "$dir" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
        if [ "$file_count" -gt 0 ]; then
            print_result "$label" "ok"
        else
            print_result "$label" "fail"
        fi
    else
        print_result "$label" "fail"
    fi
}

check_json() {
    local label="$1"
    local path="$2"

    if [ -f "$path" ] && jq empty "$path" > /dev/null 2>&1; then
        print_result "$label" "ok"
    else
        print_result "$label" "fail"
    fi
}

check_gh_auth() {
    local label="$1"

    if gh auth status > /dev/null 2>&1; then
        print_result "$label" "ok"
    else
        print_result "$label" "fail"
    fi
}

check_gh_extension() {
    local label="$1"
    local ext="$2"

    if gh "$ext" --help > /dev/null 2>&1; then
        print_result "$label" "ok"
    else
        print_result "$label" "fail"
    fi
}

# --- Main ---
main() {
    echo "========================================"
    echo " Docker Environment Verification"
    echo "========================================"
    echo ""

    check_command   "gh CLI"                    "gh"
    check_gh_auth   "gh auth"
    check_gh_extension "gh-pr-unresolved"       "pr-unresolved"
    check_gh_extension "gh-auto-review-fix"     "auto-review-fix"
    check_gh_extension "gh-pr-check"            "pr-check"
    check_gh_extension "gh-ai-review"           "ai-review"
    check_json      "Claude Code settings"      "/workspace/.claude/settings.local.json"
    check_file      "Custom commands"           "/workspace/.claude/commands"

    echo ""
    echo "========================================"
    printf "Result: %d/%d checks passed\n" "$PASS_COUNT" "$TOTAL_COUNT"
    echo "========================================"

    if [ "$FAIL_COUNT" -gt 0 ]; then
        exit 1
    fi
}

main
