cask "cskburn-desktop" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.2.0"
  sha256 arm:   "5c29db2267633e7003d3055da53dadb0e08ae5ece6f44580c4313851b727c7f9",
         intel: "c8aac889bdc7c7e346ba301e891d8793d543c289a16770f93a150626e47a3abc"

  url "https://github.com/LISTENAI/cskburn-desktop/releases/download/v#{version}/cskburn-desktop_darwin-#{arch}.dmg",
      verified: "github.com/LISTENAI/cskburn-desktop/"
  name "cskburn desktop"
  desc "Desktop app for flashing LISTENAI CSK series chips"
  homepage "https://github.com/LISTENAI/cskburn-desktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :catalina

  app "cskburn desktop.app"

  zap trash: [
    "~/Library/Application Support/com.listenai.cskburn-desktop",
    "~/Library/Caches/com.listenai.cskburn-desktop",
    "~/Library/Preferences/com.listenai.cskburn-desktop.plist",
    "~/Library/Saved Application State/com.listenai.cskburn-desktop.savedState",
    "~/Library/WebKit/com.listenai.cskburn-desktop",
  ]

  caveats <<~EOS
    cskburn desktop is not notarized, so macOS Gatekeeper blocks it on first launch.
    After installing, clear the quarantine flag:

      sudo xattr -dr com.apple.quarantine "#{appdir}/cskburn desktop.app"
  EOS
end
