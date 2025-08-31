# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/) + [Homebrew](https://brew.sh/).
Provides a layered setup: **core tools**, optional **developer toolchain**, and optional **workstation apps**.

---

## 🚀 Initialize on a new machine

Clone this repo and let chezmoi manage it:

```bash
# 1. Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

# 2. Clone this repo into chezmoi's source directory
chezmoi init --apply bpb/dotfiles
```
