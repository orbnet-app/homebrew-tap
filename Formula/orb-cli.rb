# orb-cli formula — third-party tap (orbnet-app/homebrew-tap).
#
# orb-cli is a single-file, closed-source Mach-O binary, so homebrew-core will
# not take it (core requires buildable source). A tap is the supported route.
#
# Why this tap fixes the Gatekeeper problem: Homebrew fetches with curl, so the
# downloaded file never gets the com.apple.quarantine xattr. The binary is only
# adhoc/linker-signed (Go sets that minimum signature so arm64 will exec), which
# means Gatekeeper refuses it as soon as a browser has stamped it:
#
#   $ xattr -p com.apple.quarantine ~/Downloads/orb-cli_0.3.2_darwin_arm64
#   0083;...;Safari;...
#   $ ./orb-cli_0.3.2_darwin_arm64 --version
#   (blocked; syspolicyd: GatekeeperPolicyScanError -67018
#    "Code did not match any currently allowed policy")
#
# No quarantine xattr means no assessment and no prompt. This formula is
# therefore the recommended macOS install path. It does not change the bytes on
# the download page: those stay unsigned until the darwin binaries are
# Developer ID signed and notarized in orb-cli.yml.
#
# `version` must be declared explicitly. The artifact names end in arm64/amd64
# and Homebrew's version detector takes the last numeric run it finds, so
# left to itself it installs into a Cellar named "64". Not a style preference.
# scripts/bump-formula.sh in orbnet-app/orb rewrites the version line and the
# two sha256 lines; the urls interpolate `version` so they follow it.
class OrbCli < Formula
  desc "Command-line client for Orb topics, sessions, and messages"
  homepage "https://orbnet.app"
  version "0.3.2"

  # Every artifact this formula can install is darwin-only. The Linux and
  # Windows binaries on the download page are not covered here.
  depends_on :macos

  # url/sha256 may not live inside on_arm/on_intel — FormulaAudit/ComponentsOrder
  # rejects that in Homebrew 7 (checked with `brew style`), so the arch branch is
  # a plain conditional.
  if Hardware::CPU.arm?
    url "https://download.orbnet.app/files/orb-cli_#{version}_darwin_arm64"
    sha256 "dd2ef1b3984068102e5515217963615f52ce2bf27437efdfb4fbed246266cd38"
  else
    url "https://download.orbnet.app/files/orb-cli_#{version}_darwin_amd64"
    sha256 "5b706472ce5f6574eb0447b46df0085bc5b1939cf1f7e5b784df8cf00c62f253"
  end

  def install
    # The downloaded name is arch specific, so derive it instead of hardcoding.
    bin.install File.basename(stable.url) => "orb-cli"

    # curl writes the download 0644. Set the mode explicitly rather than rely
    # on Homebrew's handling of `bin` children.
    chmod 0755, bin/"orb-cli"
  end

  test do
    # No network: --version is answered locally from the build-time ldflag.
    assert_equal version.to_s, shell_output("#{bin}/orb-cli --version").strip.delete_prefix("orb-cli ")
  end
end
