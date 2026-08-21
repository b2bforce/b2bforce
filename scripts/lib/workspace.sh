# shellcheck shell=bash
# Shared helpers for the workspace validators in scripts/.
#
# Source this after resolving ROOT_DIR and cd-ing to the repo root:
#
#   source "${ROOT_DIR}/scripts/lib/workspace.sh"
#
# It sets WS from B2BFORCE_ROOT (default: workspace/) and defines the frontmatter,
# section, date, and brand-path helpers every validator shares. Validators keep only
# their own rules; anything two of them need lives here.

WS="${B2BFORCE_ROOT:-workspace}"

require_workspace() {
  [[ -d "${WS}" ]] || {
    echo "B2BFORCE_ROOT is not a directory: ${WS}"
    exit 1
  }
}

# --- Frontmatter --------------------------------------------------------------

# Prints the value of a top-level frontmatter key, with wrapping quotes and
# backticks stripped. Empty output when the key is absent.
frontmatter_value() {
  local file="$1"
  local key="$2"
  awk -v key="${key}" '
    BEGIN { in_fm = 0; seen = 0 }
    /^---[[:space:]]*$/ {
      if (!seen) { in_fm = 1; seen = 1; next }
      if (in_fm) { exit }
    }
    in_fm && $0 ~ "^" key ":" {
      sub("^" key ":[[:space:]]*", "")
      gsub(/^"|"$/, "")
      gsub(/^`|`$/, "")
      print
      exit
    }
  ' "${file}"
}

# Prints items of a YAML list, one per line — block form ("key:" followed by
# "  - value" lines) or inline form ("key: [a, b]").
frontmatter_list() {
  local file="$1"
  local key="$2"
  awk -v key="${key}" '
    BEGIN { in_fm = 0; seen = 0; in_list = 0 }
    /^---[[:space:]]*$/ {
      if (!seen) { in_fm = 1; seen = 1; next }
      if (in_fm) { exit }
    }
    !in_fm { next }
    $0 ~ "^" key ":" {
      rest = $0
      sub("^" key ":[[:space:]]*", "", rest)
      gsub(/[][]/, "", rest)
      if (rest != "") {
        n = split(rest, parts, ",")
        for (i = 1; i <= n; i++) {
          item = parts[i]
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", item)
          gsub(/^"|"$/, "", item)
          if (item != "") print item
        }
        exit
      }
      in_list = 1
      next
    }
    in_list && /^[[:space:]]*-[[:space:]]*/ {
      sub(/^[[:space:]]*-[[:space:]]*/, "")
      gsub(/^"|"$/, "")
      print
      next
    }
    in_list && /^[^[:space:]]/ { in_list = 0 }
  ' "${file}"
}

# Counts items of a YAML block list, or of an inline [a, b] list.
frontmatter_list_count() {
  frontmatter_list "$1" "$2" | grep -c '[^[:space:]]' || true
}

is_empty_value() {
  local value="$1"
  [[ -z "${value}" || "${value}" == "null" || "${value}" == "~" ]]
}

# --- Body and sections --------------------------------------------------------

# Prints the file body with the frontmatter block removed.
body_text() {
  awk '
    BEGIN { in_fm = 0; seen = 0; done_fm = 0 }
    /^---[[:space:]]*$/ {
      if (!seen) { in_fm = 1; seen = 1; next }
      if (in_fm) { in_fm = 0; done_fm = 1; next }
    }
    done_fm || !seen { print }
  ' "$1"
}

# Prints the body of a "## Heading" section, up to the next H2.
section_body() {
  awk -v heading="## $2" '
    $0 == heading { in_section = 1; next }
    in_section && /^## / { exit }
    in_section { print }
  ' "$1"
}

# A heading holding only a placeholder (none, n/a, tbd, todo, -) counts as empty.
section_is_empty() {
  local body
  body="$(section_body "$1" "$2" | sed -e 's/^[[:space:]]*//' -e '/^$/d')"
  body="$(printf "%s\n" "${body}" | grep -viE '^(none\.?|n/a|tbd|todo|-)$' || true)"
  [[ -z "${body}" ]]
}

# --- Files and slugs ----------------------------------------------------------

non_gitkeep_md_files() {
  find "$1" -maxdepth 1 -type f -name '*.md' ! -name '.gitkeep' 2>/dev/null | sort
}

slug_from_path() {
  basename "$1" .md
}

# Flattens an inline YAML list value to space-separated slugs.
normalize_list_value() {
  tr -d '[]",' | tr "'" " " | tr ',' ' ' | xargs
}

file_has_real_content() {
  local file="$1"
  [[ -s "${file}" ]] && ! grep -qi 'status.*template' "${file}"
}

# Turns a kebab-case slug into a loose regex: acme-corp -> acme[ _-]*corp
slug_to_regex() {
  printf "%s" "$1" | sed 's/-/[ _-]*/g'
}

# --- Dates --------------------------------------------------------------------

# Whole days between an ISO date and today. Negative means the date is in the future.
days_since() {
  local date_str="$1" then now
  then="$(date -j -f "%Y-%m-%d" "${date_str}" "+%s" 2>/dev/null ||
    date -d "${date_str}" "+%s" 2>/dev/null || echo "")"
  [[ -z "${then}" ]] && return 1
  now="$(date "+%s")"
  echo $(((now - then) / 86400))
}

# --- Brands -------------------------------------------------------------------
# The mode is detected, never configured: 0 or 1 file in firm/brands/ means
# single-brand (flat paths, exactly the pre-brand layout), 2+ means multi-brand
# (market-side paths carry a {brand}/ segment). See the Brand Scope Gate in
# AGENTS.md and the path map in docs/WORKSPACE.md.

brands_dir() {
  echo "${WS}/firm/brands"
}

list_brands() {
  local file
  while IFS= read -r file; do
    slug_from_path "${file}"
  done < <(non_gitkeep_md_files "$(brands_dir)")
}

brand_count() {
  list_brands | grep -c '[^[:space:]]' || true
}

is_multi_brand() {
  [[ "$(brand_count)" -ge 2 ]]
}

brand_exists() {
  [[ -f "$(brands_dir)/$1.md" ]]
}

# Picks the working brand in multi-brand mode: an explicit argument wins, then
# B2BFORCE_BRAND. Prints nothing (status 1) when neither is set — the caller
# decides whether that is an error. In single-brand mode prints nothing (status 0).
current_brand() {
  local explicit="${1:-}"
  if ! is_multi_brand; then
    return 0
  fi
  if [[ -n "${explicit}" ]]; then
    echo "${explicit}"
    return 0
  fi
  if [[ -n "${B2BFORCE_BRAND:-}" ]]; then
    echo "${B2BFORCE_BRAND}"
    return 0
  fi
  return 1
}

# Extracts the brand segment from a path like {area_root}/{brand}/... .
# Prints nothing in single-brand mode, where paths carry no segment.
brand_from_path() {
  local path="$1" area_root="$2"
  is_multi_brand || return 0
  case "${path}" in
    "${area_root}"/*) ;;
    *) return 1 ;;
  esac
  local rest="${path#"${area_root}"/}"
  echo "${rest%%/*}"
}

# Resolves a frontmatter reference to a file path.
#
#   resolve_ref {service|icp|persona} {ref} [brand]
#
# In single-brand mode the ref is a bare slug and the path is flat. In multi-brand
# mode a "brand/slug" ref carries its own brand (the qualified form shared entities
# use); a bare slug resolves inside [brand], which then must be non-empty — a bare
# ref without brand context is unresolvable and returns status 1.
resolve_ref() {
  local kind="$1" ref="$2" brand="${3:-}"
  local slug="${ref}"

  if is_multi_brand; then
    case "${ref}" in
      */*)
        brand="${ref%%/*}"
        slug="${ref##*/}"
        ;;
    esac
    [[ -n "${brand}" ]] || return 1
  else
    brand=""
  fi

  local segment=""
  [[ -n "${brand}" ]] && segment="${brand}/"

  case "${kind}" in
    service) echo "${WS}/firm/services/${segment}${slug}.md" ;;
    icp) echo "${WS}/marketing/icp/${segment}${slug}.md" ;;
    persona)
      if [[ -n "${brand}" ]]; then
        echo "${WS}/marketing/icp/${brand}/personas/${slug}.md"
      else
        echo "${WS}/marketing/icp/personas/${slug}.md"
      fi
      ;;
    *) return 1 ;;
  esac
}

# Prints the directory for a market-side entity, brand-segmented in multi-brand mode.
#
#   entity_dir {services|icp|personas|channels|ideas|drafts|opportunities|prospecting|ai-visibility|placements|landing-pages} [brand]
entity_dir() {
  local kind="$1" brand="${2:-}"
  local segment=""
  if is_multi_brand && [[ -n "${brand}" ]]; then
    segment="${brand}/"
  fi
  case "${kind}" in
    services) echo "${WS}/firm/services/${segment}" ;;
    icp) echo "${WS}/marketing/icp/${segment}" ;;
    personas)
      if [[ -n "${segment}" ]]; then
        echo "${WS}/marketing/icp/${segment}personas/"
      else
        echo "${WS}/marketing/icp/personas/"
      fi
      ;;
    channels) echo "${WS}/marketing/channels/${segment}" ;;
    ideas) echo "${WS}/marketing/content/${segment}ideas/" ;;
    drafts) echo "${WS}/marketing/content/${segment}drafts/" ;;
    opportunities) echo "${WS}/sales/opportunities/${segment}" ;;
    prospecting) echo "${WS}/sales/prospecting/${segment}" ;;
    ai-visibility) echo "${WS}/intelligence/ai-visibility/${segment}" ;;
    placements) echo "${WS}/marketing/placements/${segment}" ;;
    landing-pages) echo "${WS}/marketing/landing-pages/${segment}" ;;
    *) return 1 ;;
  esac
}
