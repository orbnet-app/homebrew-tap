# orbnet-app Homebrew tap

Homebrew formulas for Orb's command-line tools.

## Install the Orb CLI

One command — no `brew tap`, no `brew trust`:

```bash
brew install orbnet-app/tap/orb-cli
```

Naming the tap in the install command makes Homebrew tap it and trust **only
this one formula** on the way in, which is what Homebrew 7's tap-trust policy
wants anyway (narrower than trusting the whole tap). Upgrade later with
`brew upgrade orb-cli`.

### Why not plain `brew install orb-cli`

That spelling only works for formulae in `homebrew/core`, and core requires
open source under a DFSG-compatible licence **built from source**. `orb-cli` is
closed source, so core rejects it outright:

> Our policy is that formulae in the core tap (homebrew/core) must be
> open-source with a Debian Free Software Guidelines license and either built
> from source or producing cross-platform binaries.
> — [Acceptable Formulae](https://docs.brew.sh/Acceptable-Formulae)

`homebrew/cask` is not an escape hatch: it is for pre-built applications, and
on macOS "executable artefacts that Gatekeeper can assess must pass Homebrew's
Gatekeeper checks"
([Acceptable Casks](https://docs.brew.sh/Acceptable-Casks)). These binaries are
only adhoc/linker-signed, so they do not pass. Plain `brew install orb-cli`
would need `orb-cli` to become open source and buildable from source — a
licensing decision, not a packaging one.

If you would rather tap first:

```bash
brew tap orbnet-app/tap
brew trust --formula orbnet-app/tap/orb-cli
brew install orb-cli
```

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
