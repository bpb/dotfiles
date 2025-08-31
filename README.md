# Dotfiles with chezmoi

Opinionated, composable dotfiles for macOS using [chezmoi].
We separate concerns into **core** (always on), **dev** (developer toolchain), and **apps** (workstation apps).
On first run you will be prompted which ones to enable.

---

## 1. How to run

```bash
# 0) Install chezmoi (one-time)
/bin/bash -c "$(curl -fsLS get.chezmoi.io)"

# 1) Initialize from this repo (prompts will appear)
/usr/local/bin/chezmoi init --apply bpb/dotfiles
```



During initialization, you’ll be asked (yes/no) for:

- **Install developer toolchain?** (sets `dev`)
- **Install workstation apps?** (sets `apps`)

The chosen answers are written into your `~/.config/chezmoi/chezmoi.yaml` so you don’t need to re-enter them again.

Re-applying later just respects your saved config:

```bash
chezmoi apply
```

---

## 2. Flags

| Flag   | Default  | Description                                              |
| ------ | -------- | -------------------------------------------------------- |
| `core` | `true`   | Always-on base system setup (shell, zsh/OMZ, fonts, XDG) |
| `dev`  | prompted | Developer toolchain (Docker/Colima, Git tools, runtimes) |
| `apps` | prompted | Workstation apps (browsers, editors, productivity apps)  |

These are set at **first init** by interactive prompts, and persisted in [`chezmoi.yaml`](./dot_config/chezmoi/chezmoi.yaml.tmpl).
To change them later, edit that file directly.

---

## 3. First-run authentication & Keychain

On first run, scripts under `run_once_*` will prompt for authentication and store tokens in the **macOS Keychain**.
Subsequent shells read them automatically.

- **OpenAI API key** → [`dot_config/zsh/shrc.d/20-openai.sh.tmpl`](./dot_config/zsh/shrc.d/20-openai.sh.tmpl)
- **Docker / Registries** → [`run_once_30-docker-auth.sh.tmpl`](./run_once_30-docker-auth.sh.tmpl)
- **GitHub CLI** → [`run_once_25-github-auth.sh.tmpl`](./run_once_25-github-auth.sh.tmpl)

Secrets are never stored in the repo. Shell startup scripts only _read_ them from Keychain.

---

## 4. Brew installs by flag

We use separate Brewfiles per concern:

- **Core** → [`dot_config/homebrew/Brewfile.core`](./dot_config/homebrew/Brewfile.core)
- **Dev** → [`dot_config/homebrew/Brewfile.dev`](./dot_config/homebrew/Brewfile.dev)
- **Apps** → [`dot_config/homebrew/Brewfile.apps`](./dot_config/homebrew/Brewfile.apps)

Applied by [`run_once_before_10-bootstrap-macos.sh.tmpl`](./run_once_before_10-bootstrap-macos.sh.tmpl).

---

## 5. Common tasks

```bash
chezmoi apply                # re-apply with saved flags
chezmoi diff                 # dry-run changes
chezmoi edit ~/.zshrc        # edit a managed file
chezmoi add ~/.config/ghostty/config  # add a new file
```

---

## 6. Repo layout

```
.
├─ .chezmoiignore
├─ README.md
├─ dot_config/
│  ├─ chezmoi/chezmoi.yaml.tmpl
│  ├─ homebrew/
│  │  ├─ Brewfile.core
│  │  ├─ Brewfile.dev
│  │  └─ Brewfile.apps
│  └─ zsh/shrc.d/20-openai.sh.tmpl
├─ run_once_before_10-bootstrap-macos.sh.tmpl
├─ run_once_25-github-auth.sh.tmpl
├─ run_once_30-docker-auth.sh.tmpl
└─ run_once_31-dockerhub-auth.sh.tmpl
```

---

## 7. Design

- **Separation of concerns** → predictable, composable setups.
- **Keychain-first** → secrets never in repo/plaintext.
- **Idempotent scripts** → safe to re-apply.
- **Brewfile per concern** → minimal, clear diffs.

---
