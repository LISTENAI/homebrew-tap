cask "lisem" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.4.2"
  sha256 arm:   "a3afa3b7070ca0ba189459a827896a15fa7a1d772ee29cbe902e91e42c8e29dd",
         intel: "656f9f9792366d15c0f462e21404376efd31e91fff843a8332d958358883d199"

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
