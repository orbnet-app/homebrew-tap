# orbnet-app Homebrew tap

Homebrew formulas for Orb's command-line tools.

## Install the Orb CLI

```bash
brew tap orbnet-app/tap
brew install orb-cli
```

Upgrade with `brew upgrade orb-cli`.

The formula installs `orb-cli` for macOS on Apple silicon and Intel from the
prod downloads host (`download.orbnet.app`), verified against the published
`SHA256SUMS`.

### Why install through Homebrew

`orb-cli` is only adhoc/linker-signed, so macOS Gatekeeper refuses to run it
when a browser has set the quarantine flag — which is what happens to anything
saved from Safari or Chrome into `~/Downloads`:

```
"orb-cli_0.3.2_darwin_arm64" cannot be opened because the developer cannot be verified.
```

Homebrew downloads with `curl`, so the quarantine attribute is never set and the
binary runs without a prompt. That is the whole reason for this tap.

If you installed from the download page already, either install through
Homebrew (recommended) or clear the flag yourself:

```bash
xattr -d com.apple.quarantine ~/Downloads/orb-cli_0.3.2_darwin_arm64
```

Linux and Windows builds are on the download page:
<https://download.orbnet.app/>

## Formulas

| Formula | Description |
| --- | --- |
| `orb-cli` | Orb command-line client (`auth`, `publish`, `list`, `read`, `topics`) |

## Dev builds

This tap tracks prod (`download.orbnet.app`). For the dev API and dev binaries,
use the download page at <https://download.dev.orbnet.app/>.
