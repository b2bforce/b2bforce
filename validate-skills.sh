#!/bin/bash

# Validates Agent Skills in .agents/skills/ against agentskills.io spec.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SKILLS_DIR=".agents/skills"
ISSUES=0
WARNINGS=0
PASSED=0

echo "Auditing Skills Against Agent Skills Specification"
echo "=================================================="
echo ""
echo "Skills directory: ${SKILLS_DIR}"
echo "Reference: https://agentskills.io/specification"
echo ""

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo -e "${RED}ERROR: ${SKILLS_DIR} not found${NC}"
  exit 1
fi

shopt -s nullglob
skill_dirs=("$SKILLS_DIR"/*/)
if [[ ${#skill_dirs[@]} -eq 0 ]]; then
  echo -e "${RED}ERROR: No skills found in ${SKILLS_DIR}${NC}"
  exit 1
fi

for skill_dir in "${skill_dirs[@]}"; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"
    skill_errors=()
    skill_warnings=()

    if [[ ! -f "$skill_file" ]]; then
        echo -e "${RED}FAIL ${skill_name}${NC}"
        echo "   Missing SKILL.md"
        ((ISSUES++))
        continue
    fi

    frontmatter=$(awk '/^---$/{count++; next} count==1' "$skill_file")

    if [[ -z "$frontmatter" ]]; then
        echo -e "${RED}FAIL ${skill_name}${NC}"
        echo "   Missing YAML frontmatter (---)"
        ((ISSUES++))
        continue
    fi

    name_in_file=$(echo "$frontmatter" | grep "^name:" | sed 's/^name: //' | tr -d ' ')

    if [[ -z "$name_in_file" ]]; then
        skill_errors+=("Missing 'name' field in frontmatter")
    elif [[ "$name_in_file" != "$skill_name" ]]; then
        skill_errors+=("Name mismatch: directory='$skill_name' but frontmatter='$name_in_file'")
    elif ! [[ "$name_in_file" =~ ^[a-z0-9]([a-z0-9-]{0,62}[a-z0-9])?$ ]]; then
        skill_errors+=("Invalid name format: '$name_in_file'")
    fi

    description=$(echo "$frontmatter" | grep "^description:" | head -1)
    if [[ $description == *'description: "'* ]] || [[ $description == *"description: '"* ]]; then
        description=$(echo "$description" | sed -E 's/^description: ["'\''](.*)["'\'']/\1/')
    else
        description=$(echo "$description" | sed 's/^description: //')
    fi

    if [[ -z "$description" ]]; then
        skill_errors+=("Missing 'description' field in frontmatter")
    else
        desc_len=${#description}
        if [[ $desc_len -lt 1 || $desc_len -gt 1024 ]]; then
            skill_errors+=("Description length invalid: $desc_len chars (must be 1-1024)")
        fi
        # Check trigger phrases across the whole frontmatter (folded YAML
        # descriptions span multiple lines, so scan the full block).
        if ! echo "$frontmatter" | grep -qi "when\|use"; then
            skill_warnings+=("Description lacks clear trigger phrases ('when', 'use')")
        fi
    fi

    line_count=$(wc -l < "$skill_file" | tr -d ' ')
    if [[ $line_count -gt 500 ]]; then
        skill_warnings+=("SKILL.md is $line_count lines (should be <500)")
    fi

    if [[ ${#skill_errors[@]} -gt 0 ]]; then
        echo -e "${RED}FAIL ${skill_name}${NC}"
        for error in "${skill_errors[@]}"; do
            echo -e "   Error: $error"
        done
        for warning in "${skill_warnings[@]}"; do
            echo -e "   Warning: $warning"
        done
        ((ISSUES++))
    elif [[ ${#skill_warnings[@]} -gt 0 ]]; then
        echo -e "${YELLOW}WARN ${skill_name}${NC}"
        for warning in "${skill_warnings[@]}"; do
            echo -e "   Warning: $warning"
        done
        ((WARNINGS++))
    else
        echo -e "${GREEN}OK ${skill_name}${NC}"
        ((PASSED++))
    fi
done

echo ""
echo "Summary: passed=$PASSED warnings=$WARNINGS issues=$ISSUES"
echo ""

if [[ $ISSUES -eq 0 ]]; then
    echo -e "${GREEN}All skills are valid.${NC}"
    exit 0
else
    echo -e "${RED}Found $ISSUES issue(s) that need fixing.${NC}"
    exit 1
fi
