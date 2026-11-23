cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.4.4"
  sha256 arm:   "6e3c20f9950094dde09af8af2fc6cc87677ee5db1ebac98a93424b4681100418",
         intel: "e322e6bc5a7da2b5543ed351917f67e8d41abdd7d5ecc40f7b0afeb563831437"

  url "https://github.com/LISTENAI/Lisem/releases/download/v#{version}/Lisem-darwin-#{arch}.tar.gz"
  name "Lisem"
  desc "Run and debug firmware for LISTENAI devices"
  homepage "https://github.com/LISTENAI/Lisem"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sequoia

  app "Lisem.app"
  binary "#{appdir}/Lisem.app/Contents/MacOS/lisem"

  caveats <<~EOS
    Lisem is not notarized. If macOS blocks the first launch, allow it in
    System Settings > Privacy & Security.
  EOS
end
