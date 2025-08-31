# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/) + [Homebrew](https://brew.sh/).
Provides a layered setup: **core tools**, optional **developer toolchain**, and optional **workstation apps**.

---

## 🚀 Initialize on a new machine

Clone this repo and let chezmoi manage it:

# 1. Install chezmoi

mkdir -p ~/.local/bin
BINDIR=~/.local/bin sh -c "$(curl -fsLS get.chezmoi.io)"

# 2. Clone this repo into chezmoi's source directory

chezmoi init --apply bpb/dotfiles

```

#!/usr/bin/env bash
# install-chezmoi.sh
# One-shot installer for chezmoi on macOS (no Homebrew required).
# - Fetches latest release from GitHub
# - Installs to /usr/local/bin (or ~/.local/bin if --no-sudo)
# - Verifies install
# - Optionally initializes your dotfiles repo

set -euo pipefail

## -----------------------
## Defaults & CLI parsing
## -----------------------
PREFIX="/usr/local/bin"
USE_SUDO="yes"
INIT_REPO=""
APPLY="no"

usage() {
  cat <<'USAGE'
Usage: bash install-chezmoi.sh [options]

Options:
  --no-sudo             Install to ~/.local/bin instead of /usr/local/bin
  --prefix <dir>        Custom install dir (implies --no-sudo if not writable)
  --init <git-url>      Run `chezmoi init <git-url>` after install
  --apply               Use --apply with init (applies immediately)
  -h, --help            Show this help

Examples:
  bash install-chezmoi.sh
  bash install-chezmoi.sh --no-sudo
  bash install-chezmoi.sh --init git@github.com:yourname/dotfiles.git --apply
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-sudo) USE_SUDO="no"; shift ;;
    --prefix)  PREFIX="$2"; shift 2 ;;
    --init)    INIT_REPO="${2:-}"; shift 2 ;;
    --apply)   APPLY="yes"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  end
done

## -----------------------
## Sanity checks
## -----------------------
OS="$(uname -s || true)"
ARCH="$(uname -m || true)"

if [[ "${OS}" != "Darwin" ]]; then
  echo "This script is for macOS (Darwin). Detected: ${OS}" >&2
  exit 1
fi

# Map macOS arch to release arch
case "${ARCH}" in
  x86_64) REL_ARCH="amd64" ;;   # 2016 Mac (Intel)
  arm64)  REL_ARCH="arm64" ;;
  *) echo "Unsupported CPU arch: ${ARCH}" >&2; exit 1 ;;
esac

# Decide final install dir & sudo
if [[ "${USE_SUDO}" = "no" ]]; then
  PREFIX="${PREFIX:-$HOME/.local/bin}"
fi
if [[ ! -w "$(dirname "${PREFIX}")" ]] && [[ "${USE_SUDO}" = "no" ]]; then
  # If not writable and no sudo requested, fallback to ~/.local/bin
  PREFIX="$HOME/.local/bin"
fi
mkdir -p "${PREFIX}"

# Will we need sudo?
NEED_SUDO="no"
if [[ ! -w "${PREFIX}" ]]; then
  NEED_SUDO="yes"
fi

## -----------------------
## Temp dir (BSD mktemp)
## -----------------------
TMPDIR="$("/usr/bin/mktemp" -d -t chezmoi.XXXXXX)"
cleanup() { rm -rf "${TMPDIR}"; }
trap cleanup EXIT

## -----------------------
## Get latest version tag
## -----------------------
echo "Fetching latest chezmoi release info..."
if ! VER_JSON="$(curl -fsSL https://api.github.com/repos/twpayne/chezmoi/releases/latest)"; then
  echo "Failed to query GitHub API for latest release." >&2
  exit 1
fi
TAG="$(printf '%s' "${VER_JSON}" | grep -oE '"tag_name":\s*"v[^"]*"' | cut -d'"' -f4)"
if [[ -z "${TAG}" ]]; then
  echo "Could not determine latest release tag from GitHub API." >&2
  exit 1
fi
VER="${TAG#v}"

ASSET="chezmoi_${VER}_darwin_${REL_ARCH}.tar.gz"
URL="https://github.com/twpayne/chezmoi/releases/download/${TAG}/${ASSET}"

echo "Latest version: ${TAG}"
echo "Downloading:    ${ASSET}"

## -----------------------
## Download & extract
## -----------------------
curl -fsSL -o "${TMPDIR}/chezmoi.tgz" "${URL}"
tar -xzf "${TMPDIR}/chezmoi.tgz" -C "${TMPDIR}"

if [[ ! -f "${TMPDIR}/chezmoi" ]]; then
  echo "Extracted archive does not contain 'chezmoi' binary." >&2
  exit 1
fi
chmod +x "${TMPDIR}/chezmoi"

## -----------------------
## Install binary
## -----------------------
DEST="${PREFIX%/}/chezmoi"
if [[ "${NEED_SUDO}" = "yes" ]]; then
  echo "Installing to ${DEST} (sudo required)..."
  sudo mv "${TMPDIR}/chezmoi" "${DEST}"
else
  echo "Installing to ${DEST}..."
  mv "${TMPDIR}/chezmoi" "${DEST}"
fi

## -----------------------
## Ensure PATH includes PREFIX
## -----------------------
BIN_DIR="$(dirname "${DEST}")"
if ! command -v chezmoi >/dev/null 2>&1; then
  # Try temporary PATH augmentation for this session
  export PATH="${BIN_DIR}:${PATH}"
fi

## -----------------------
## Verify
## -----------------------
echo -n "chezmoi version: "
if ! chezmoi --version; then
  echo "chezmoi not found on PATH. Add this to your shell config:"
  echo "  export PATH=\"${BIN_DIR}:\$PATH\""
  exit 1
fi

## -----------------------
## Optional init
## -----------------------
if [[ -n "${INIT_REPO}" ]]; then
  echo "Initializing chezmoi with repo: ${INIT_REPO}"
  if [[ "${APPLY}" = "yes" ]]; then
    chezmoi init --apply "${INIT_REPO}"
  else
    chezmoi init "${INIT_REPO}"
    echo "Run 'chezmoi apply' when ready."
  fi
fi

echo "✅ Done."
``
```
